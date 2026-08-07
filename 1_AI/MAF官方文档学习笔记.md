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
            AgentResponse<PersonInfo> response = await agent.RunAsync<PersonInfo>("Please provide information about John Smith, who is a 35-year-old software engineer.", options: runOptions)
        3、方案2：先获取，再序列化（如果是流式，是先获取完，再序列化）
            IAsyncEnumerable<AgentResponseUpdate> updates = agent.RunStreamingAsync("Please provide information about John Smith, who is a 35-year-old software engineer.");
            AgentResponse response = await updates.ToAgentResponseAsync()
            JsonElement result = JsonSerializer.Deserialize<JsonElement>(response.Text)
    3、AIContextProviders VS Tools
        1、AIContextProviders
            在把请求发给 AI 之前/之后，框架自动去拿数据（如聊天历史、知识库/RAG），默默地加到 Prompt 里。AI 本身感知不到过程，只看结果。
        2、Tools
            把能力包装成函数交给 AI，由 AI 自己决定“我要不要用”、“什么时候用”、“用什么参数去用”。
    4、Observability、Evaluation
        可观测性、评估

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

## 后台运行响应

    1、非流式处理后台响应
        var options = new(){AllowBackgroundResponses = true};
        var session = await agent.CreateSessionAsync();
        var response = await agent.RunAsync("Write a very long novel about otters inspace.", session, options);
        // 获取到就退出
        while (response.ContinuationToken is not null)
        {
            await Task.Delay(TimeSpan.FromSeconds(2));
            options.ContinuationToken = response.ContinuationToken;

            // 持续获取结果
            response = await agent.RunAsync(session, options);
        }
    2、流式处理后台响应
        var options = new(){AllowBackgroundResponses = true};
        var session = await agent.CreateSessionAsync();
        AgentResponseUpdate? latestReceivedUpdate = null;
        await foreach (var update in agent.RunStreamingAsync("Write a very long novel about otters in space.", session, options))
        {
            Console.Write(update.Text);
            latestReceivedUpdate = update;
            
            // 模拟中断了获取
            break;
        }

        // 从中断的地方恢复，继续获取文本
        options.ContinuationToken = latestReceivedUpdate?.ContinuationToken;
        await foreach (var update in agent.RunStreamingAsync(session, options))
        {
            Console.Write(update.Text);
        }

## RAG-TextSearchProvider

    Microsoft代理框架支持通过将 AI 上下文提供程序添加到代理，轻松地向代理添加检索增强生成（RAG）功能。

    1、配置文本搜索提供者
        var textSearchOptions = new(){SearchTime = TextSearchProviderOptions.TextSearchBehavior.BeforeAIInvoke,};
    2、创建一个有文本搜索的AI
        var agent = azureOpenAIClient
        .GetChatClient(deploymentName)
        .AsAIAgent(new ChatClientAgentOptions
        {
            ChatOptions = new() { Instructions = "You are a helpful support specialist. Answer questions using the provided context and cite the source document when available." },
            AIContextProviders = [new TextSearchProvider(SearchAdapter, textSearchOptions)]
        });
    3、创建一个搜索函数
        static Task<IEnumerable<TextSearchProvider.TextSearchResult>> SearchAdapter(string query, CancellationToken cancellationToken){}

## 声明式Agent（还有声明式工作流）

    用Yaml/Json来配置一个Agent，代码如下：
        // 声明一个yarm配置
        var yamlDefinition =
            """
            kind: Prompt
            name: Assistant
            description: Helpful assistant
            instructions: You are a helpful assistant. You answer questions in the language specified by the user. You return your answers in a JSON format.
            model:
                options:
                    temperature: 0.9
                    topP: 0.95
            outputSchema:
                properties:
                    language:
                        type: string
                        required: true
                        description: The language of the answer.
                    answer:
                        type: string
                        required: true
                        description: The answer text.
            """;
        // 从yarm配置中，创建agent
        var agentFactory = new ChatClientPromptAgentFactory(chatClient);
        var agent = await agentFactory.CreateFromYamlAsync(yamlDefinition);

## Skills

    1、Skills是指令、脚本和资源的可移植包，可提供代理的专用功能和域专业知识。 技能遵循开放规范并实现渐进式披露模式，以便代理在需要时仅加载所需的上下文。在需要时使用代理技能：
        1、封装领域专业知识
            将专业知识（费用政策、法律工作流、数据分析管道）封装为可复用、可移植的软件包。
        2、扩展代理功能
            为代理提供新功能，而无需更改其核心指令。
        3、确保一致性
            将多步骤任务转换为可重复的可审核工作流。
        4、启用互操作性
            在不同的代理技能兼容产品中重复使用相同的技能
    2、Skills结构
        skills是一个目录，包含一个 SKILL.md 文件，并且可以选择包括用于存放资源的子目录：
        expense-report/
        ├── SKILL.md                          # 必填 - 元数据 + 指引提示词
        ├── scripts/
        │   └── validate.py                   # 可执行代码
        ├── references/
        │   └── POLICY_FAQ.md                 # 参考文档 — Agent 会在需要时按需加载
        └── assets/
            └── expense-report-template.md    # 模板与静态资源
    3、SKILL.md格式
        SKILL.md 文件必须包含 YAML 前置元数据，后跟 Markdown 内容：
        ---
        name: expense-report
        description: File and validate employee expense reports according to company policy. Use when asked about expense submissions, reimbursement rules, or spending limits.
        license: Apache-2.0
        compatibility: Requires python3
        metadata:
            author: contoso-finance
            version: "2.1"
        ---
    4、渐进式披露
        代理技能使用四阶段渐进式披露模式来最大程度地减少上下文使用情况：
            1、宣告
                在每次运行开始时，技能名称和描述会被注入到系统提示中，让代理知道有哪些可用技能。
            2、加载
                当任务与技能的域匹配时，代理会调用 load_skill 该工具以检索完整的 SKILL.md 正文，其中包含详细说明。
            3、读取资源
                代理仅在需要时调用 read_skill_resource 该工具以提取补充文件（引用、模板、资产）。
            4、运行脚本
                代理仅在需要时调用该工具 run_skill_script 以执行与技能捆绑的脚本。
    5、技能的组成部分
        1、供应商
            AgentSkillsProvider是向代理公开技能的上下文提供程序。它播发系统提示中的可用技能，并注册代理用于加载技能、读取资源和运行脚本的工具。
        2、源
            源向提供程序提供技能。 技能可能来自多种源类型：
                1、基于文件的技能 - 从 SKILL.md 文件系统目录中的文件发现的技能。
                    var skillsProvider = new AgentSkillsProvider(Path.Combine(AppContext.BaseDirectory, "skills"));
                2、代码定义的技能 - 使用 AgentInlineSkill在代码中以内联方式定义的技能。用于代码控制技能内容，动态生成技能。
                    var codeStyleSkill = new AgentInlineSkill();
                3、基于类的技能 — 封装于派生自 AgentClassSkill<T>的类中的技能。
                    public class UnitConverterSkill : AgentClassSkill<UnitConverterSkill>
                    var skillsProvider = new AgentSkillsProvider(new UnitConverterSkill());
                4、基于MCP的技能 - 通过UseMcpSkills从MCP（模型上下文协议）服务器发现的技能。
                    await using McpClient client = await McpClient.CreateAsync(new StdioClientTransport(new(){Name = "skills-server",Command = "dotnet",Arguments = [skillsServerPath, "--server"],}));
                    基于 MCP 的技能支持两种索引条目类型：
                    1、skill-md - 技能的 SKILL.md 及其同级资源按需从 MCP 服务器获取
                        var skillsProvider = new AgentSkillsProviderBuilder().UseMcpSkills(client).Build();
                    2、Archive - 技能作为一个打包存档（ZIP、TAR 或 gzip 压缩的 TAR）分发，该存档在本地下载和解压缩
                        var skillsProvider = new AgentSkillsProviderBuilder().UseMcpSkills(client, 
                        new AgentMcpSkillsSourceOptions{ArchiveSkillsDirectory = Path.Combine(AppContext.BaseDirectory, "extracted-skills"),ArchiveMaxFileCount = 50,ArchiveMaxSizeBytes = 2 * 1024 * 1024,}).Build();
        3、建设者
            AgentSkillsProviderBuilder将多个源组合到单个提供程序中，应用聚合、重复数据删除、缓存和可选筛选。
    6、技能源的构建
        1、AgentSkillsProvider 从一个或多个源（实现了 AgentSkillsSource 的对象）中检索技能。 源分为三类：
            1、发现或持有技能的叶源（如 AgentFileSkillsSource 用于基于文件的技能）
            2、转换另一个源输出的装饰器（聚合、去重、缓存和筛选）。
            3、自定义源
        2、每个源实现单个方法 - GetSkillsAsync(AgentSkillsSourceContext context, CancellationToken cancellationToken = default)
            1、Agent - 请求技能的 AIAgent 实例。
            2、Session - 与调用关联的 AgentSession ，如果没有会话，则为 null
        3、叶源
            1、AgentFileSkillsSource
                从磁盘上的 SKILL.md 文件中发现技能。
            2、AgentInMemorySkillsSource
                将 AgentSkill 实例（代码定义或基于类）包装在内存中。
        4、装饰器源
            1、组合器 AggregatingAgentSkillsSource
                将多个源合并为一个源。 技能按注册顺序返回，且未应用重复数据删除或筛选。
            2、修饰器 DeduplicatingAgentSkillsSource
                修饰器包装内部源并转换其输出。 可以将它们串联起来以构建一个管道。移除重复的技能名称（不区分大小写，保留首次出现的名称）。
            3、缓存器 CachingAgentSkillsSource
                缓存内部源返回的技能列表。 并发调用方按缓存密钥进行序列化，因此每次只运行一个提取。
            4、筛选器 FilteringAgentSkillsSource
                使用谓词以决定包含还是排除技能。
        5、自定义源
            当内置源无法满足你的场景时，请实现你自己的源。 
                1、对于叶源（从新来源 [如数据库或远程服务]生成技能的源），请子类化 AgentSkillsSource
                2、对于转换另一个源输出的装饰器，请子类化DelegatingAgentSkillsSource
        6、构建AgentSkillsProvider的3种方案
            1、AgentSkillsProviderBuilder
                使用自动聚合、重复数据删除、缓存和可选筛选将多个技能类型组合到一个提供程序中。 最适合结合基于文件、代码定义、类和 MCP 的技能的场景。
                通过串联 UseFileSkill 、 UseSkill 、 UseMcpSkills 和 UseFileScriptRunne、UseFilter的构建。
            2、直接源组合
                使用公共 AgentSkillsSource 类自行构造源管道。
                var fileSource = new AgentFileSkillsSource([Path.Combine(AppContext.BaseDirectory, "skills")],SubprocessScriptRunner.RunAsync);
                var inMemorySource = new AgentInMemorySkillsSource([volumeConverterSkill, temperatureConverter]);
                var aggregated = new AggregatingAgentSkillsSource([fileSource, inMemorySource]);
                var deduplicated = new DeduplicatingAgentSkillsSource(aggregated);
                var cached = new CachingAgentSkillsSource(deduplicated);
                var skillsProvider = new AgentSkillsProvider(cached,options: new AgentSkillsProviderOptions(),ownsSource: true);
            3、构造函数
                直接从文件路径或技能实例创建提供程序。 自动应用重复数据删除和缓存。最适用于单一源场景。
                var skillsProvider = new AgentSkillsProvider(Path.Combine(AppContext.BaseDirectory, "skills"),scriptRunner: SubprocessScriptRunner.RunAsync);
        7、工具审批与处理审批请求
            1、工具的使用，一般需要暂停，并返回一个审批：ToolApprovalRequestContent
                UseToolApproval可以配置工具审批规则
            2、处理审批请求
        8、传递Skills的脚本错误信息
            FunctionInvokingChatClient、UseFunctionInvocation、IncludeDetailedErrors 

## harness

    1、harness的组成
        1、函数调用
            具有可配置迭代限制的自动工具调用循环。
        2、每次服务调用的历史记录持久化
            每次单独的模型调用后，聊天记录都会被持久化保存，从而支持故障恢复以及在运行过程中进行检查。
        3、压缩
            上下文窗口压缩可防止长时间的工具调用循环溢出上下文窗口。 提供令牌预算（或自定义策略）时生效。
        4、待办事项提供程序
            智能体用于跟踪多步骤计划的持久待办事项列表。
        5、代理模式提供程序
            计划/执行/自定义模式跟踪，用于构建智能体的工作方式
        6、文件内存提供程序
            基于文件的会话内存，用于存储跨轮次持久化的笔记和项目。
        7、文件访问提供程序
            限定在工作目录内的读写文件工具。
        8、工具审批
            “不再询问”的常设审批规则，加上针对安全、无人值守执行的启发式自动审批。
        9、OpenTelemetry
            遵循生成式 AI 语义规范的内置可观测性。
        10、Web搜索
            默认情况下添加的托管 Web 搜索工具。
        11、技能提供程序
            发现并从文件系统逐步加载代理技能。
        12、后台代理
            将并行工作委托给后台子代理。
        13、Shell 环境
            Shell 命令执行以及对操作系统/Shell/工作目录的探测。
        14、Looping
            循环调用代理，直到满足完成条件。
    2、创建HarnessAgent
        // 方案1
        var agent = new HarnessAgent(chatClient);
        // 方案2
        var agent = chatClient.AsHarnessAgent(new HarnessAgentOptions
        {
            Name = "research-agent",
            ChatOptions = new ChatOptions
            {
                Instructions = "You are a research assistant focused on academic sources.",
                Tools = [AIFunctionFactory.Create(GetStockPrice)],
            },
        });
    3、启用压缩
        new HarnessAgentOptions
        {
            MaxContextWindowTokens = 128_000,
            MaxOutputTokens = 16_384,
        }
    4、自定义和禁用功能
        new HarnessAgentOptions
        {
            HarnessInstructions = "Custom operating guidelines here.",
            DisableTodoProvider = true,      // No todo list
            DisableAgentModeProvider = true, // No plan/execute modes
            DisableWebSearch = true,         // No hosted web search tool
            DisableFileMemory = true,        // No file-based session memory
        };
    5、循环直到完成
        new HarnessAgentOptions
        {
            LoopEvaluators = [new CompletionMarkerLoopEvaluator("DONE")],
        }
    6、Shell和后台智能体
    7、规划和执行工作流
        智能体模式提供程序支持一种两阶段工作风格，与待办事项列表天然契合：
            1、计划模式 - 交互式。 代理会提出澄清问题、起草待办事项列表和计划，并在完成重大工作之前获得批准。
            2、执行模式 - 自治。 智能体独立处理待办事项，并随时报告进度。