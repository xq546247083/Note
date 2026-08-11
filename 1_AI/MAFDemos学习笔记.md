# MAF Demos 学习笔记

# 01-get-started

    1、创建Agent，并执行

``` Csharp
var clientOptions = new OpenAIClientOptions { Endpoint = new Uri(endpoint) };
var client = new OpenAIClient(new ApiKeyCredential(apiKey), clientOptions);

var agent = client
    .GetChatClient(model)
    .AsAIAgent(instructions: "你是一个幽默的助手，擅长讲笑话。", name: "Joker");

await foreach (var update in agent.RunStreamingAsync("给我讲一个笑话。"))
{
    Console.Write(update);
}
```

    2、添加工具

``` Csharp
var agent = client
    .GetChatClient(model)
    .AsAIAgent(instructions: "你是一个幽默的助手，擅长讲笑话。", name: "Joker"
    , tools: [AIFunctionFactory.Create(GetWeather)]);
```

    3、创建会话


``` Csharp
var session = await agent.CreateSessionAsync();
await foreach (var update in agent.RunStreamingAsync("我叫啥？", session))
{
    Console.Write(update);
}
```

    4、添加上下文


``` Csharp
var agent = chatClient.AsAIAgent(new ChatClientAgentOptions
{
    ChatOptions = new ChatOptions
    {
        Instructions = "你是一个友好的助手。在回复时，如果知道了用户的名字，请务必称呼用户的名字。",
    },
    AIContextProviders = [new UserInfoMemory(extractionClient)]
});
```

    5、序列化会话和恢复会话

``` Csharp
// 创建会话
var session = await agent.CreateSessionAsync();
// 序列化会话
var sessionElement = await agent.SerializeSessionAsync(session);
// 恢复会话
var deserializedSession = await agent.DeserializeSessionAsync(sessionElement);
```

    6、工作流

``` Csharp
Func<string, string> uppercaseFunc = s => s.ToUpperInvariant();
var uppercase = uppercaseFunc.BindAsExecutor("UppercaseExecutor");

ReverseTextExecutor reverse = new();

// Build the workflow by connecting executors sequentially
WorkflowBuilder builder = new(uppercase);
builder.AddEdge(uppercase, reverse).WithOutputFrom(reverse);
var workflow = builder.Build();

// Execute the workflow with input data
await using Run run = await InProcessExecution.RunAsync(workflow, "Hello, World!");
foreach (WorkflowEvent evt in run.NewEvents)
{
    if (evt is ExecutorCompletedEvent executorComplete)
    {
        Console.WriteLine($"{executorComplete.ExecutorId}: {executorComplete.Data}");
    }
}
```

# 02-agents

## A2A

    1、Agent转变为工具

``` Csharp
// 方案1
agent.AsAIFunction()
// 方案2
AIFunctionFactory.Create(RunAgentAsync, options);
async Task<string> RunAgentAsync(string input, CancellationToken cancellationToken)
{
    var response = await a2aAgent.RunAsync(input, cancellationToken: cancellationToken).ConfigureAwait(false);

    return response.Text;
}
```

    2、后台响应

``` Csharp

// 允许服务器返回一个Task
var options = new() { AllowBackgroundResponses = true };
var session = await agent.CreateSessionAsync();
var response = await agent.RunAsync("some messages", session, options: options);

// 循环直到完成
while (response.ContinuationToken is { } token)
{
    // Wait before polling again.
    await Task.Delay(TimeSpan.FromSeconds(2));

    // 继续获取回复
    response = await agent.RunAsync(session, options: new AgentRunOptions { ContinuationToken = token });
}
```

    3、选择沟通方式

``` Csharp
var options = new()
{
    PreferredBindings = [ProtocolBindingNames.HttpJson]
    // PreferredBindings = [ProtocolBindingNames.JsonRpc]
};
var agent = agentCard.AsAIAgent(options: options);
```

    4、重连

``` Csharp
ResponseContinuationToken? continuationToken = null;
await foreach (var update in agent.RunStreamingAsync("some messages.", session))
{
    // 保存一个token，用于恢复
    if (update.ContinuationToken is { } token)
    {
        continuationToken = token;
    }

    // Imitating stream interruption
    break;
}

// 从恢复token继续获取流
if (continuationToken is not null)
{
    await foreach (var update in agent.RunStreamingAsync(session, options: new() { ContinuationToken = continuationToken }))
    {
        if (!string.IsNullOrEmpty(update.Text))
        {
            Console.WriteLine(update.Text);
        }
    }
}
```

## AgentProviders

    1、接入OpenAI

``` Csharp
// 下面的ResponsesClient可以替换为ChatClient，用来表示对话的
// 创建Agent方式1
var agent =
    new ResponsesClient(new ApiKeyCredential(apiKey))
    .AsAIAgent(model: model, instructions: "You are good at telling jokes.", name: "Joker");
// 创建Agent方式2
var client = new OpenAIClient(apiKey)
        // 使用Response接口
        .GetResponsesClient()
        // 获取ChatClient的聊天方式
        .AsIChatClient(model).AsBuilder()
        .ConfigureOptions(o =>
        {
            // 开启深度思考，力度中，输出完整结果
            o.Reasoning = new()
            {
                Effort = ReasoningEffort.Medium,
                Output = ReasoningOutput.Full,
            };
        }).Build();
var agent = new ChatClientAgent(client);
// 执行
var response = await agent.RunAsync("Some Messages.");
// 转换为OpenAI SDK的结果
// response.AsOpenAIChatCompletion()
// response.AsOpenAIResponse()
```

    2、接入OpenAI的云端会话

``` Csharp
// 创建云端会话客户端
var conversationClient = openAIClient.GetConversationClient();
// 向 OpenAI 服务器请求创建一个新会话，拿到云端唯一的 conversationId（如 conv_123abc）
var createConversationResult = await conversationClient.CreateConversationAsync(...);
using JsonDocument createConversationResultAsJson = JsonDocument.Parse(createConversationResult.GetRawResponse().Content.ToString());
var conversationId = createConversationResultAsJson.RootElement.GetProperty("id"u8)!.GetString()!;
// 根据会话id，创建会话
var session = await agent.CreateSessionAsync(conversationId);
// 从 OpenAI 云端拉取该 conversationId 存储的所有历史消息记录
var getConversationItemsResults = conversationClient.GetConversationItems(conversationId);
// 在 OpenAI 云端删除/销毁这个会话，清理云端数据
var deleteConversationResult = conversationClient.DeleteConversation(conversationId);
```
    3、接入OpenAI的云端代码编译执行和下载生成的文件
``` Csharp
// 挂载 HostedCodeInterpreterTool 赋予 Agent 跑 Python 代码的能力
var agent = openAIClient
    .GetResponsesClient()
    .AsAIAgent(
        model: model,
        instructions: "你是一个可以通过写代码生成文件的助手。",
        name: "CodeInterpreterAgent",
        // Hosted，在云端执行代码的工具。指定给 AI 服务的托管工具，使它能够执行生成的代码。
        tools: [new HostedCodeInterpreterTool()]); 
// 让 Agent 生成 1 到 12 的乘法口诀表 CSV 文件
AgentResponse response = await agent.RunAsync(
    "Create a CSV file with the multiplication times tables from 1 to 12. Include headers.");
// 遍历 Agent 返回消息中的“标注引用 (Annotations)”
foreach (AIAnnotation annotation in content.Annotations)
{
    // 如果找到了代码解释器容器文件引用 (ContainerFileCitationMessageAnnotation)
    if (annotation is CitationAnnotation citation
        && citation.RawRepresentation is ContainerFileCitationMessageAnnotation containerCitation)
    {
        string filename = containerCitation.Filename;   // 文件名 (如 times_table.csv)
        string containerId = containerCitation.ContainerId; // 容器 ID (cntr_xxx)
        string fileId = containerCitation.FileId;      // 文件 ID (cfile_xxx)
        ...
    }
}
// 获取专用于下载沙箱容器文件的 ContainerClient
ContainerClient containerClient = openAIClient.GetContainerClient();

// 下载容器中的文件字节流
var fileData = await containerClient.DownloadContainerFileAsync(
    containerCitation.ContainerId,
    containerCitation.FileId);

// 保存到本地物理磁盘
var outputPath = Path.Combine(Directory.GetCurrentDirectory(), safeFilename);
await File.WriteAllBytesAsync(outputPath, fileData.ToArray());
```

    4、A2A方式提供Agent

``` Csharp
var agentCardResolver = new A2ACardResolver(new Uri(a2aAgentHost));
AIAgent agent = await agentCardResolver.GetAIAgentAsync();
```
    5、OpenAI的Chat、Response
    6、自定义Agent

``` Csharp
// 继承这个，实现对应的方法即可
public class UpperCaseParrotAgent : AIAgent
{
}
```

## Agents

    1、使用工具提示
        ToolApprovalRequestContent
    2、结构化输出
        ResponseFormat
    3、持久化会话
        var serializedSession = await agent.SerializeSessionAsync(session);
        var str=JsonSerializer.Serialize(serializedSession, new JsonSerializerOptions { WriteIndented = true }) + "\n"
    4、聊天记录存储
        ChatHistoryProvider
        // 裁剪历史记录
        ChatHistoryProvider = new InMemoryChatHistoryProvider(new() { ChatReducer = new MessageCountingChatReducer(2) })
    5、可观测性
        .UseOpenTelemetry(sourceName: sourceName)
    6、服务依赖注入
        builder.Services.AddSingleton(agent);
    7、服务添加MCP服务
        var tool = McpServerTool.Create(agent.AsAIFunction());
        var builder = Host.CreateEmptyApplicationBuilder(settings: null);
        builder.Services.AddMcpServer().WithStdioServerTransport().WithTools([tool]);
    8、多模态输入-图片
        var message = new(ChatRole.User, [
            new TextContent("你在这张图片里看到了什么？"),
            // 传入图片数据（异步从本地文件 Assets/walkway.jpg 加载）
            await DataContent.LoadFromAsync("Assets/walkway.jpg"),
        ]);
    9、Agent转换为工具
        weatherAgent.AsAIFunction()
    10、添加中间件
        .Use(FunctionCallMiddleware)
    11、后台响应
        var options = new() { AllowBackgroundResponses = true };
    12、YAML定义
    13、Shell执行
        LocalShellExecutor
    14、Todo任务列表
        TodoProvider