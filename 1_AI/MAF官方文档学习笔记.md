# Agents

    1、消息类型
        TextContent
            文本内容可以是输入，例如，来自用户或开发人员，以及代理的输出。 通常包含代理的文本结果。
        DataContent
            可以是输入和输出的二进制内容。 可用于向代理传入和传出图像、音频或视频数据2（其中受支持）。
        UriContent
            通常指向托管内容（如图像、音频或视频）的 URL。
        FunctionCallContent
            推理服务调用函数工具的请求。
        FunctionResultContent
            函数工具调用的结果
    2、结构化输出
        1、在调用时设置 ResponseFormat 属性 AgentRunOptions，ResponseFormat选项有：
            1、内置 ChatResponseFormat.Text 属性
                响应将为纯文本。
            2、具有内置 ChatResponseFormat.Json 属性
                响应将是一个没有任何特定模式的 JSON 对象。
            3、自定义 ChatResponseFormatJson 实例
                响应将是符合特定架构的 JSON 对象
        2、方案1：直接格式化输出：
            var runOptions = new(){ResponseFormat = ChatResponseFormat.ForJsonSchema<PersonInfo>()};
            AgentResponse<PersonInfo> response = await agent.RunAsync<PersonInfo>("Please provide
    information about John Smith, who is a 35-year-old software engineer.", options: runOptions)
        3、方案2：先获取，再序列化（如果是流式，是先获取完，再序列化）
            IAsyncEnumerable<AgentResponseUpdate> updates = agent.RunStreamingAsync("Pleaseprovide information about John Smith, who is a 35-year-old software engineer.");
            AgentResponse response = await updates.ToAgentResponseAsync()
            JsonElement result = JsonSerializer.Deserialize<JsonElement>(response.Text)
    3、


## ChatClientAgent执行逻辑（这是最常用的Client）

    1、ChatClientAgent管道
        1、智能体中间件
            通过 .Use() 包装智能体的可选装饰器，用于日志记录、验证或转换
        2、上下文层
            管理聊天历史记录（ ChatHistoryProvider ）并注入其他上下文
        （ AIContextProviders ）
        3、聊天客户端层
            带有处理 LLM 通信的可选中间件装饰器的 IChatClient
    2、调用代理时，请求将流经管道：
        1、智能体中间件 执行（如果已配置）
        2、ChatHistoryProvider 将对话历史记录加载到请求消息列表中
        3、AIContextProviders 向请求添加消息、工具或说明
        4、IChatClient 中间件执行（如果已装饰）
        5、IChatClient 将请求发送到 LLM
        6、响应通过相同的层返回
        7、ChatHistoryProvider 和 AIContextProviders 收到新消息的通知
    3、智能体中间件层
        类似ASP的管道体系，可以添加中间件。
        1、使用代理生成器模式添加中间件：
            var middlewareAgent = originalAgent.AsBuilder().Use(runFunc: MyAgentMiddleware, runStreamingFunc: MyStreamingMiddleware).Build();
        2、用 MessageAIContextProvider 代理中间件，将其他消息注入请求：
            var contextAgent = originalAgent.AsBuilder().UseAIContextProviders(new MyMessageContextProvider()).Build();
    4、上下文层
        1、ChatHistoryProvider （单一）
            管理对话历史记录存储和检索
        2、AIContextProviders （列表）
            注入其他上下文，如记忆、检索的文档或动态指令
    5、聊天客户端层
        使用AsIChatClient，然后new ChatClientAgent()

## 多模态智能体

    构建一个UriContent发送给AI即可
    var message = new(ChatRole.User, [new TextContent("What do you see in this image?"),new UriContent("https://demo.jpg","image/jpeg")]);