# MAF Demos 学习笔记

# 01-get-started

    1、创建Agent，并执行

```Csharp
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

```Csharp
var agent = client
    .GetChatClient(model)
    .AsAIAgent(instructions: "你是一个幽默的助手，擅长讲笑话。", name: "Joker"
    , tools: [AIFunctionFactory.Create(GetWeather)]);
```

    3、创建会话

```Csharp
var session = await agent.CreateSessionAsync();
await foreach (var update in agent.RunStreamingAsync("我叫啥？", session))
{
    Console.Write(update);
}
```

    4、添加上下文

```Csharp
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

```Csharp
// 创建会话
var session = await agent.CreateSessionAsync();
// 序列化会话
var sessionElement = await agent.SerializeSessionAsync(session);
// 恢复会话
var deserializedSession = await agent.DeserializeSessionAsync(sessionElement);
```

    6、工作流

```Csharp
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

```Csharp
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

```Csharp

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

```Csharp
var options = new()
{
    PreferredBindings = [ProtocolBindingNames.HttpJson]
    // PreferredBindings = [ProtocolBindingNames.JsonRpc]
};
var agent = agentCard.AsAIAgent(options: options);
```

    4、重连

```Csharp
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

```Csharp
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

```Csharp
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

```Csharp
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

```Csharp
var agentCardResolver = new A2ACardResolver(new Uri(a2aAgentHost));
AIAgent agent = await agentCardResolver.GetAIAgentAsync();
```

    5、OpenAI的Chat、Response
    6、自定义Agent

```Csharp
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
    12、Declarative
        YAML定义
    13、Shell执行
        LocalShellExecutor
    14、Todo任务列表
        TodoProvider

## AgentSkills

    1、基于MCP的Skills

```Csharp
await using McpClient client = await McpClient.CreateAsync(
    new StdioClientTransport(new()
    {
        Name = "skills-server",
        Command = "dotnet",
    }));

var skillsProvider = new AgentSkillsProviderBuilder()
    .UseMcpSkills(client)
    .Build();
```

    2、基于文件的Skills

```Csharp
// 创建基于文件的Skills提供者
var skillsProvider = new AgentSkillsProvider(Path.Combine(AppContext.BaseDirectory, "skills"),SubprocessScriptRunner.RunAsync);

// 加载skillsProvider
var agent = new AIProjectClient(new Uri(endpoint), new DefaultAzureCredential())
    .AsAIAgent(new ChatClientAgentOptions
    {
        Name = "UnitConverterAgent",
        ChatOptions = new()
        {
            ModelId = deploymentName,
            Instructions = "You are a helpful assistant that can convert units.",
        },
        AIContextProviders = [skillsProvider],
    })
    .AsBuilder()
    .UseToolApproval(new ToolApprovalAgentOptions
    {
        // 自动审核工具
        AutoApprovalRules = [AgentSkillsProvider.AllToolsAutoApprovalRule],
    })
    .Build();

// 执行
var response = await agent.RunAsync(
    "How many kilometers is a marathon (26.2 miles)? And how many pounds is 75 kilograms?");
```

    3、基于代码的Skills
        AgentInlineSkill
    4、基于类的Skills
        public class UnitConverterSkill : AgentClassSkill<UnitConverterSkill>{}
        var unitConverter = new UnitConverterSkill();
        var skillsProvider = new AgentSkillsProvider(unitConverter);
    5、混合Skills
        var skillsProvider = new AgentSkillsProviderBuilder()
            // 基于文件的Skills
            .UseFileSkill(Path.Combine(AppContext.BaseDirectory, "skills"))
            // 基于代码的Skills
            .UseSkill(volumeConverterSkill)
            // 基于类的Skills
            .UseSkill(temperatureConverter)
            .UseFileScriptRunner(SubprocessScriptRunner.RunAsync)
            .Build();

## AgentWithCodeAct

    1、HyperlightCodeActProvider、HyperlightExecuteCodeFunction、HostedCodeInterpreterTool的区别
        1、HyperlightCodeActProvider是跑在本地的，通过AIContextProviders添加
        2、HyperlightExecuteCodeFunction是跑在本地的，通过Tools添加
        2、HostedCodeInterpreterTool是跑在服务器
        3、其它它们是一样的，本质就是执行代码的工具
    2、创建执行代码工具

```Csharp
using var codeAct = new HyperlightCodeActProvider(HyperlightCodeActProviderOptions.CreateForWasm(guestPath));

AIAgent agent = new AIProjectClient(
    new Uri(endpoint),
    new DefaultAzureCredential())
    .AsAIAgent(new ChatClientAgentOptions()
    {
        ChatOptions = new() { ModelId = deploymentName, Instructions = "Some Messages." },
        AIContextProviders = [codeAct],
    });
```

    3、提供给代码的工具

```Csharp
var calculate = AIFunctionFactory.Create(
    (double a, double b) => a * b,
    name: "multiply",
    description: "Multiply two numbers.");
var options = HyperlightCodeActProviderOptions.CreateForWasm(guestPath);
options.Tools = [calculate];
using var codeAct = new HyperlightCodeActProvider(options);

```

    4、通过工具的方式添加代码执行器
    using var executeCodeFuncation = new HyperlightExecuteCodeFunction(HyperlightCodeActProviderOptions.CreateForWasm(guestPath));
    tools: [executeCodeFuncation]

## AgentWithMemory

    1、聊天记录提供者
        ChatHistoryMemoryProvider
    2、Mem0
        一个服务，专门用来记忆聊天记录的服务。Mem0Provider
    3、Valkey
        Redis开源的数据库分支，可以用来记忆聊天记录的服务。ValkeyChatHistoryProvider
    4、文件记忆聊天记录
        FileMemoryProvider

## AgentWithRAG

    1、文本搜索
        TextSearchProvider
    2、Qdrant向量数据库
    3、Neo4j向量数据库

## AGUI

    他是开源的基于事件的协议,让Agent与前端无缝对话的事件通信标准。它的主要作用是实现 “AI 智能体前后端分离”：把 Agent 的核心计算逻辑放在后台服务器运行，前端（Web 网页、命令行终端、手机 App 等）只负责展示和交互。
    1、创建服务端

```Csharp
var clientOptions = new OpenAIClientOptions { Endpoint = new Uri(endpoint) };
var openAIClient = new OpenAIClient(new ApiKeyCredential(apiKey), clientOptions);
var chatClient = openAIClient.GetChatClient(model).AsIChatClient();
var agent = chatClient.AsAIAgent(
    name: "AGUIAssistant",
    instructions: "You are a helpful assistant.");

app.MapAGUIServer("/", agent);
await app.RunAsync();
```

    2、创建客户端

```Csharp
using HttpClient httpClient = new()
{
    Timeout = TimeSpan.FromSeconds(60)
};

var chatClient = new AGUIChatClient(new AGUIChatClientOptions(httpClient, serverUrl));
var agent = chatClient.AsAIAgent(
    name: "agui-client",
    description: "AG-UI Client Agent");

var session = await agent.CreateSessionAsync();
var messages =[new(ChatRole.System, "You are a helpful assistant.")];
while (true)
{
    string? message = Console.ReadLine();
    messages.Add(new ChatMessage(ChatRole.User, message));
    await foreach (AgentResponseUpdate update in agent.RunStreamingAsync(messages, session))
    {
        var chatUpdate = update.AsChatResponseUpdate();
        foreach (AIContent content in update.Contents)
        {
            if (content is TextContent textContent)
            {
                Console.Write(textContent.Text);
            }
            else if (content is ErrorContent errorContent)
            {
                Console.WriteLine($"\n[Error: {errorContent.Message}]");
            }
        }
    }
}
```

    3、服务器添加工具
        1、服务器添加tools
        2、客户端回调
            1、FunctionCallContent 服务器工具调用内容
            2、functionResultContent 服务器工具调用结果
    4、客户端添加工具
        1、客户端添加tools
        2、服务器正常使用
        这种模式下：客户端的工具传递到服务器->服务器给大模型->大模型调用工具->服务器调用客户端->客户端调用工具->把结果给服务器->服务器传递给大模型。
    5、工具使用审批
        这个demo主要是演示服务器的工具使用，客户端怎么审批。具体见案例【AGUI-Step04_HumanInLoop】
    6、状态管理
        这个demo主要是演示状态管理。

## DevUI

    一个演示开发UI的Demo.

## 评估

    agent.EvaluateAsync()
    对结果进行评估。
    1、本地评估，不使用大模型
    2、大模型评估

## Harness

    1、创建harness

```Csharp
var chatClient =
    new AIProjectClient(
        new Uri(endpoint),
        new DefaultAzureCredential(),
        new AIProjectClientOptions { RetryPolicy = new ClientRetryPolicy(3) })  // Enable retries to improve resiliency.
    .GetProjectOpenAIClient()
    .GetResponsesClient()
    .AsIChatClient(deploymentName);

// AsHarnessAgent已经预先配置好了函数调用、每次服务调用的对话历史记录持久化、TodoProvider (待办事项提供者)、AgentModeProvider (模式提供者) 以及网络搜索功能。
var agent = chatClient.AsHarnessAgent(new HarnessAgentOptions
{
    ChatOptions = new ChatOptions
    {
        Instructions = instructions,
        Tools = [StockTools.CreateGetStockPriceTool()],
        Reasoning = new() { Effort = ReasoningEffort.Medium },
    },
});

// 启动一个harness的console
await HarnessConsole.RunAgentAsync(
    agent,
    userPrompt: "Ask about a stock or say 'Review my watchlist and recommend some stocks to add' to get started.",
    new HarnessConsoleOptions
    {
        Observers = [
            new OpenAIResponsesWebSearchDisplayObserver(),
            new OpenAIResponsesErrorObserver(),
            .. HarnessConsoleOptions.BuildObserversWithPlanning(
                agent,
                planModeName: "plan",
                executionModeName: "execute",
                toolFormatters: ToolCallFormatter.BuildDefaultToolFormatters())],
        CommandHandlers = HarnessConsoleOptions.BuildDefaultCommandHandlers(agent),
    });
```

    2、添加记忆、Skills、代码执行等
    3、loop执行、浏览器工具、本地记忆文件
        // 保存执行记录到本地文件
        using var tracerProvider = HarnessTracing.CreateFileTracerProvider(TracingSourceName);
        .AsHarnessAgent(new HarnessAgentOptions
        {
            // 存储一些记忆文件到本地
            FileMemoryStore = new FileSystemAgentFileStore(Path.Combine(AppContext.BaseDirectory, "agent-files")),
            LoopEvaluators =
            [
                // 当前有2个默认的模式: "plan" and "execute".
                new TodoCompletionLoopEvaluator(new TodoCompletionLoopEvaluatorOptions { Modes =["execute"] }),
            ],
            // 最多循环10次
            LoopAgentOptions = new LoopAgentOptions { MaxIterations = 10 },
            ChatOptions = new ChatOptions
            {
                Instructions = instructions,
                Tools =
                [
                    // 一个本地的浏览器工具，可以打开网页，并把html转换为md
                    new WebBrowsingTool(new WebBrowsingToolOptions { AllowPublicNetworks = true }),
                ],
                MaxOutputTokens = MaxOutputTokens,
                Reasoning = new() { Effort = ReasoningEffort.Medium },
            },
        });
    4、后台工作Agents
        配置Agent的后台工作Agent列表：BackgroundAgents
    5、工作区
        FileAccessStore = new FileSystemAgentFileStore()
    6、LoopAgent
        让Agent在结果不满意的情况下，循环调用。
        注意：Harness的LoopEvaluators，是Agent内部循环，直到执行完成。

## MCP

    1、连接MCP服务，创建Tools
        1、创建本地执行的MCP客户端（在本地执行）
            await using var mcpClient = await McpClient.CreateAsync(new StdioClientTransport());
        2、创建服务器执行的MCP客户端（在MCP服务器执行）
            await using var mcpClient = await McpClient.CreateAsync(new HttpClientTransport());
    2、创建主机执行的MCP服务工具
        new HostedMcpServerTool()

## Observability

    Telemetry，参考【02-agents-Observability-AgentOpenTelemetry】

# 03-workflows

## _StartHere

    1、创建工作流

``` Csharp
UppercaseExecutor uppercase = new();
ReverseTextExecutor reverse = new();
var builder = new(uppercase);
builder.AddEdge(uppercase, reverse).WithOutputFrom(reverse);
var workflow = builder.Build();
await using StreamingRun run = await InProcessExecution.RunStreamingAsync(workflow, input: "Hello, World!");
await foreach (WorkflowEvent evt in run.WatchStreamAsync())
{
    if (evt is ExecutorCompletedEvent executorCompleted)
    {
        Console.WriteLine($"{executorCompleted.ExecutorId}: {executorCompleted.Data}");
    }
    else if (evt is WorkflowErrorEvent workflowError)
    {
        Console.Error.WriteLine(workflowError.Exception?.ToString() ?? "Unknown workflow error occurred.");
    }
    else if (evt is ExecutorFailedEvent executorFailed)
    {
        Console.Error.WriteLine($"Executor '{executorFailed.ExecutorId}' failed with {(executorFailed.Data == null ? "unknown error" : $"exception {executorFailed.Data}")}.");
    }
}
```

    2、Agent直接放进工作流里面
        var workflow = new WorkflowBuilder(frenchAgent).AddEdge(frenchAgent, spanishAgent).AddEdge(spanishAgent, englishAgent).Build();
    3、Agent在工作流中的模式
        1、sequential
            AgentWorkflowBuilder.BuildSequential()
        2、sequential-chain-only
            AgentWorkflowBuilder.BuildSequential(chainOnlyAgentResponses: true)
        3、concurrent
            AgentWorkflowBuilder.BuildConcurrent()
        4、handoffs
            AgentWorkflowBuilder.CreateHandoffBuilderWith()
        5、groupchat
            AgentWorkflowBuilder.CreateGroupChatBuilderWith()
    4、子工作流
        把工作流转换为执行节点：subWorkflow.BindAsExecutor("TextProcessingSubWorkflow");

## Agents

    1、把Agent做到执行器里面
        执行节点里面本质是Agent
    2、工作流转换为Agent
        workflow.AsAIAgent()

## Checkpoint

    1、创建Checkpoint

``` Csharp
var checkpointManager = CheckpointManager.Default;
await using StreamingRun checkpointedRun = await InProcessExecution.RunStreamingAsync(workflow, NumberSignal.Init, checkpointManager);
await foreach (WorkflowEvent evt in checkpointedRun.WatchStreamAsync()){}
```

    2、恢复工作流
        await checkpointedRun.RestoreCheckpointAsync(savedCheckpoint, CancellationToken.None);

## Concurrent

    1、扇出，并发给多个节点执行
        AddFanOutEdge
    2、扇入，把多个节点的结果并发给一个节点
        AddFanInBarrierEdge

## ConditionalEdges

    1、条件边的最后一个参数是条件，传入后，就会判断
    2、SwitchCase

``` Csharp
 builder.AddSwitch(spamDetectionExecutor, switchBuilder =>
     switchBuilder
     .AddCase(
         GetCondition(expectedDecision: SpamDecision.NotSpam),
         emailAssistantExecutor
     )
     .AddCase(
         GetCondition(expectedDecision: SpamDecision.Spam),
         handleSpamExecutor
     )
     .WithDefault(
         handleUncertainExecutor
     )
 )
```

    3、多选条件边
        AddFanOutEdge中传入targetSelector，可以用代码控制下一个节点列表

## Declarative

    工作流使用yaml定义。使用方法在【03-workflows-Declarative】中，具体需要使用的时候再看。

## Evaluation

    1、启动评估
        await using Run run = await InProcessExecution.RunAsync(workflow,new ChatMessage(ChatRole.User, "Plan a weekend trip to Paris"));
        var results = await run.EvaluateAsync(local);

## HumanInTheLoop

    1、创建RequestPort

``` Csharp
var numberRequestPort = RequestPort.Create<NumberSignal, int>("GuessNumber");
var judgeExecutor = new JudgeExecutor(42);

// Build the workflow by connecting executors in a loop
return new WorkflowBuilder(numberRequestPort)
    .AddEdge(numberRequestPort, judgeExecutor)
    .AddEdge(judgeExecutor, numberRequestPort)
    .WithOutputFrom(judgeExecutor)
    .Build();
```

    2、其他见：【03-workflows-HumanInTheLoop】

## Loop

    可以把节点组成一个环状，通过YieldOutputAsync结束执行

## Observability

    1、开启链路追踪
        WithOpenTelemetry
    2、转换为Agent，再开启链路追踪
        new OpenTelemetryAgent(workflow.AsAIAgent())

## Orchestration(编排)

    1、Handoff
        var handoffBuilder = AgentWorkflowBuilder.CreateHandoffBuilderWith(agents.IntakeAgent);
    2、Magentic
        var workflow = new MagenticWorkflowBuilder(managerAgent)
            .AddParticipants([researcherAgent, coderAgent])
            .WithName("Magentic Orchestration Workflow")
            .WithDescription("Coordinates a researcher and coder to solve a complex analytical task.")
            .RequirePlanSignoff(false)
            .WithMaxRounds(10)
            .WithMaxStalls(3)
            .WithMaxResets(2)
            .Build();

## SharedStates

    1、写数据到共享状态
        context.QueueStateUpdateAsync(key, fileContent, scopeName)
    2、从共享状态读数据
        context.ReadStateAsync<T>(key, scopeName)

## Visualization

    workflow.ToMermaidString()

# 04-hosting

## af-hosting(重要)

    1、local_responses
        演示的是：在ASP.NET Core 服务中暴露一个 POST /responses 接口，把一个 AIAgent 按照 OpenAI Responses API 格式对外提供服务。具体代码实现在demo中看。
    2、local_responses_workflow
        演示的是：在ASP.NET Core 服务中暴露一个 POST /responses 接口，把一个 工作流 按照 OpenAI Responses API 格式对外提供服务。具体代码实现在demo中看。
    3、客户端的2种实现方案
        1、var chatClient = responseClient.AsIChatClient(model);
        2、var agent = responseClient.AsAIAgent(model: model, name: "HostedResponsesClient");

## FoundryHostedAgents

    在Azure上部署Agent，跳过。

# 05-end-to-end

## A2AClientServer

    演示的是：本地的主控Agent调度服务器的3个Agent。具体代码实现在demo中看。

## AgentWebChat(重要)

    演示的是：一个基于 .NET Aspire 打造的全栈 Web 聊天系统端到端示例。具体代码实现在demo中看。
    1、项目结构：
        1、AgentWebChat.AppHost:是Aspire主机
        2、AgentWebChat.ServiceDefaults：辅助Aspire的项目
        3、AgentWebChat.AgentHost:AI Agent 后端微服务
        4、AgentWebChat.Web：网页
    2、效果是：
        1、网页可以选择不同的Agent
        2、调用方式分：
            1、ChatClient
            2、Response
            3、A2A

## AGUIClientServer(重要)

    演示如何启用有个AGUI的AI服务，里面创建了各种需要的Agent。具体代码实现在demo中看。
    https://docs.ag-ui.com/introduction

## AspNetAgentAuthorization

    演示权限验证。具体代码实现在demo中看。