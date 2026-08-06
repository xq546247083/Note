// Copyright (c) Microsoft. All rights reserved.

using System.ClientModel;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.Agents.AI;
using Microsoft.Agents.AI.Workflows;
using Microsoft.Extensions.AI;
using OpenAI;

namespace WorkflowCustomAgentExecutorsSample;

/// <summary>
/// 本示例展示如何为 AI Agent 创建自定义执行器（Custom Executor）。
/// 这在希望对 Agent 在工作流中的行为进行更精细控制时非常有用。
///
/// 在本例中，我们创建了两个自定义执行器：
/// 1. SloganWriterExecutor: 一个负责根据任务生成宣传标语（Slogan）的 AI Agent。
/// 2. FeedbackExecutor: 一个负责对生成的宣传标语进行评审并给出反馈意见的 AI Agent。
///
/// 工作流将在两者之间交替迭代，直到标语达到评分标准或达到最大尝试次数。
/// </summary>
public static class Program
{
    private static async Task Main()
    {
        Console.OutputEncoding = Encoding.UTF8;

        const string ApiKey = "sk-4f17ba55c9124e80aa9d9a4b19aea80e";
        const string Endpoint = "https://api.deepseek.com";
        const string Model = "deepseek-chat";

        var clientOptions = new OpenAIClientOptions { Endpoint = new Uri(Endpoint) };
        var client = new OpenAIClient(new ApiKeyCredential(ApiKey), clientOptions);

        IChatClient chatClient = client.GetChatClient(Model).AsIChatClient();

        // 创建自定义执行器
        var sloganWriter = new SloganWriterExecutor("SloganWriter", chatClient);
        var feedbackProvider = new FeedbackExecutor("FeedbackProvider", chatClient);

        // 构建工作流：在标语生成器与反馈评审器之间建立双向边（循环迭代）
        var workflow = new WorkflowBuilder(sloganWriter)
            .AddEdge(sloganWriter, feedbackProvider)
            .AddEdge(feedbackProvider, sloganWriter)
            .WithOutputFrom(feedbackProvider)
            .Build();

        Console.WriteLine("==================================================");
        Console.WriteLine("    DeepSeek 宣传标语生成与自动评审工作流        ");
        Console.WriteLine("==================================================\n");

        // 运行工作流
        await using StreamingRun run = await InProcessExecution.RunStreamingAsync(workflow, input: "为一款性价比高且充满驾驶乐趣的新款电动 SUV 设计句宣传标语。");
        await foreach (WorkflowEvent evt in run.WatchStreamAsync())
        {
            if (evt is SloganGeneratedEvent or FeedbackEvent)
            {
                // 自定义事件输出，便于实时观察工作流进度
                Console.WriteLine($"{evt}\n");
            }

            if (evt is WorkflowOutputEvent outputEvent)
            {
                Console.WriteLine($"【工作流最终输出】:\n{outputEvent}\n");
            }

            if (evt is WorkflowErrorEvent errorEvent)
            {
                Console.WriteLine($"工作流错误: {errorEvent.Exception?.Message}");
                Console.WriteLine($"异常详情: {errorEvent.Exception}");
            }
        }
    }
}

/// <summary>
/// 标语生成 Agent 输出的结构化数据
/// </summary>
public sealed class SloganResult
{
    [JsonPropertyName("task")]
    public required string Task { get; set; }

    [JsonPropertyName("slogan")]
    public required string Slogan { get; set; }
}

/// <summary>
/// 反馈评审 Agent 输出的结构化数据
/// </summary>
public sealed class FeedbackResult
{
    [JsonPropertyName("comments")]
    public string Comments { get; set; } = string.Empty;

    [JsonPropertyName("rating")]
    public int Rating { get; set; }

    [JsonPropertyName("actions")]
    public string Actions { get; set; } = string.Empty;
}

/// <summary>
/// 宣传标语生成完成事件
/// </summary>
internal sealed class SloganGeneratedEvent(SloganResult sloganResult) : WorkflowEvent(sloganResult)
{
    public override string ToString() => $"[生成标语] 任务: {sloganResult.Task}\n标语: {sloganResult.Slogan}";
}

/// <summary>
/// 标语生成器执行器（处理初始任务以及修改反馈）
/// </summary>
internal sealed partial class SloganWriterExecutor : Executor
{
    private readonly AIAgent _agent;
    private AgentSession? _session;

    public SloganWriterExecutor(string id, IChatClient chatClient) : base(id)
    {
        ChatClientAgentOptions agentOptions = new()
        {
            ChatOptions = new()
            {
                Instructions = "你是一位专业的广告文案撰写师。你将接收一项任务来创作宣传标语。必须以 JSON 格式输出，包含 task 和 slogan 两个字段。例如：{\"task\":\"...\", \"slogan\":\"...\"}",
                ResponseFormat = ChatResponseFormat.Json
            }
        };

        this._agent = chatClient.AsAIAgent(agentOptions);
    }

    [MessageHandler]
    public async ValueTask<SloganResult> HandleAsync(string message, IWorkflowContext context, CancellationToken cancellationToken = default)
    {
        this._session ??= await this._agent.CreateSessionAsync(cancellationToken);

        var result = await this._agent.RunAsync(message, this._session, cancellationToken: cancellationToken);

        var sloganResult = JsonSerializer.Deserialize<SloganResult>(result.Text) ?? throw new InvalidOperationException("无法反序列化标语结果。");

        await context.AddEventAsync(new SloganGeneratedEvent(sloganResult), cancellationToken);
        return sloganResult;
    }

    [MessageHandler]
    public async ValueTask<SloganResult> HandleAsync(FeedbackResult message, IWorkflowContext context, CancellationToken cancellationToken = default)
    {
        var feedbackMessage = $"""
            这是针对你上一版标语的评审反馈：
            修改建议: {message.Comments}
            评分: {message.Rating}
            建议操作: {message.Actions}

            请根据以上反馈重新改进并输出新版标语。
            """;

        var result = await this._agent.RunAsync(feedbackMessage, this._session, cancellationToken: cancellationToken);
        var sloganResult = JsonSerializer.Deserialize<SloganResult>(result.Text) ?? throw new InvalidOperationException("无法反序列化标语结果。");

        await context.AddEventAsync(new SloganGeneratedEvent(sloganResult), cancellationToken);
        return sloganResult;
    }
}

/// <summary>
/// 反馈评审完成事件
/// </summary>
internal sealed class FeedbackEvent(FeedbackResult feedbackResult) : WorkflowEvent(feedbackResult)
{
    private readonly JsonSerializerOptions _options = new() { WriteIndented = true };
    public override string ToString() => $"[评审反馈]:\n{JsonSerializer.Serialize(feedbackResult, this._options)}";
}

/// <summary>
/// 反馈评审执行器（评估标语质量，合格则完成工作流，不合格则打回重写）
/// </summary>
[SendsMessage(typeof(FeedbackResult))]
[YieldsOutput(typeof(string))]
internal sealed partial class FeedbackExecutor : Executor<SloganResult>
{
    private readonly AIAgent _agent;
    private AgentSession? _session;

    public int MinimumRating { get; init; } = 8;

    public int MaxAttempts { get; init; } = 3;

    private int _attempts;

    public FeedbackExecutor(string id, IChatClient chatClient) : base(id)
    {
        ChatClientAgentOptions agentOptions = new()
        {
            ChatOptions = new()
            {
                Instructions = "你是一位严格的资深广告总监。你将审核提交的宣传标语，给出评价、1-10分的评分以及具体改进建议。必须以 JSON 格式输出，包含 comments, rating (数字 1-10), actions 三个字段。例如：{\"comments\":\"...\", \"rating\":8, \"actions\":\"...\"}",
                ResponseFormat = ChatResponseFormat.Json
            }
        };

        this._agent = chatClient.AsAIAgent(agentOptions);
    }

    public override async ValueTask HandleAsync(SloganResult message, IWorkflowContext context, CancellationToken cancellationToken = default)
    {
        this._session ??= await this._agent.CreateSessionAsync(cancellationToken);

        var sloganMessage = $"""
            任务 '{message.Task}' 的标语如下：
            标语: {message.Slogan}
            请对此标语进行评审，提供修改建议、1到10分的评分，以及具体的操作改进说明。
            """;

        var response = await this._agent.RunAsync(sloganMessage, this._session, cancellationToken: cancellationToken);
        var feedback = JsonSerializer.Deserialize<FeedbackResult>(response.Text) ?? throw new InvalidOperationException("无法反序列化反馈结果。");

        await context.AddEventAsync(new FeedbackEvent(feedback), cancellationToken);

        if (feedback.Rating >= this.MinimumRating)
        {
            await context.YieldOutputAsync($"该宣传标语已通过评审并采纳！\n最终标语:\n{message.Slogan}", cancellationToken);
            return;
        }

        if (this._attempts >= this.MaxAttempts)
        {
            await context.YieldOutputAsync($"已达到最大重试次数 ({this.MaxAttempts} 次)。最终选定的标语:\n{message.Slogan}", cancellationToken);
            return;
        }

        await context.SendMessageAsync(feedback, cancellationToken: cancellationToken);
        this._attempts++;
    }
}
