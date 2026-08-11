# MAF Demos 学习笔记

## 01-get-started

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