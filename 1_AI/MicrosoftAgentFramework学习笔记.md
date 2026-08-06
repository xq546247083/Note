# MAF库

  - 1. 核心与抽象 (Core & Abstractions)
    - Microsoft.Agents.AI.Abstractions：
      框架核心抽象库，提供 AIAgent、AgentSession、AIContextProvider 等核心接口与基类。
    - Microsoft.Agents.AI：
      框架核心实现库，提供 ChatClientAgent、TextSearchProvider (RAG) 及基础会话管理能力。
  - 2. 模型与平台 Provider 接入 (Model Providers)
    - Microsoft.Agents.AI.OpenAI：
      提供对 OpenAI 及 OpenAI API 兼容服务（如 DeepSeek、Ollama）的 Agent 接入适配。
    - Microsoft.Agents.AI.Anthropic：
      提供对 Anthropic Claude 系列模型的 Agent 接入适配。
    - Microsoft.Agents.AI.Foundry：
      提供对 Azure AI Foundry 云端托管 Agent 和模型的接入适配。
    - Microsoft.Agents.AI.AzureAI：
      提供对 Azure AI 服务基础模型与 Agent 的接入适配。
    - Microsoft.Agents.AI.AzureAI.Persistent：
      提供对 Azure AI 云端持久化 Agent（云端保留 Thread/Run 状态）的接入适配。
    - Microsoft.Agents.AI.CopilotStudio：
      提供对微软 Copilot Studio 智能体的接入适配。
    - Microsoft.Agents.AI.GitHub.Copilot：
      提供对 GitHub Copilot SDK 的 Agent 接入适配。
  - 3. 工作流编排 (Workflows & Declarative)
    - Microsoft.Agents.AI.Workflows：
      工作流核心库，提供基于 Executor（处理节点）和 Edge（数据边）的 C# 代码管道编排。
    - Microsoft.Agents.AI.Workflows.Generators：
      Roslyn 源码生成器，在编译期自动生成工作流节点路由代码以提升性能。
    - Microsoft.Agents.AI.Workflows.Declarative：
      提供基于 JSON/YAML 声明式语法定义与执行工作流的能力。
    - Microsoft.Agents.AI.Declarative：
      提供基于 JSON/YAML 声明式语法定义与配置 Agent 的能力。
    - Microsoft.Agents.AI.Workflows.Declarative.Mcp：
      提供在声明式工作流中调用 MCP (Model Context Protocol) 服务工具的能力。
    - Microsoft.Agents.AI.Workflows.Declarative.AzureAI：
      提供在声明式工作流中接入 Azure AI Agent 的能力。
    - Microsoft.Agents.AI.Workflows.Declarative.Foundry：
      提供在声明式工作流中接入 Azure AI Foundry Agent 的能力。
  - 4. 服务宿主与 Web 部署 (Hosting & Server)
    - Microsoft.Agents.AI.Hosting：
      通用 Agent 宿主扩展，提供与 .NET 依赖注入 (DI) 容器的集成支持。
    - Microsoft.Agents.AI.Hosting.AspNetCore：
      支持将 Agent 直接注册并发布为 ASP.NET Core Web API / REST 服务。
    - Microsoft.Agents.AI.Hosting.AzureFunctions：
      支持将 Agent 部署在 Azure Functions 无服务器函数上运行。
    - Microsoft.Agents.AI.Hosting.OpenAI：
      支持将本地 Agent 服务暴露为兼容 OpenAI 官方 REST API 格式的 HTTP 接口。
    - Microsoft.Agents.AI.Foundry.Hosting：
      提供 Azure AI Foundry 容器化环境下的 Agent 宿主运行支持。
    - Microsoft.Agents.AI.DurableTask：基
      于 Durable Task Framework 提供分布式、防崩溃的长运行工作流状态恢复与持久化。
  - 5. 协议与 Agent 互联 (Protocols & Interop)
    - Microsoft.Agents.AI.A2A：
      提供 Agent2Agent (A2A) 跨网络智能体互联通信协议的核心支持。
    - Microsoft.Agents.AI.Hosting.A2A：
      提供 A2A 协议在通用宿主环境下的服务注册与响应支持。
    - Microsoft.Agents.AI.Hosting.A2A.AspNetCore：
      提供在 ASP.NET Core 中将 Agent 暴露为符合 A2A 规范端点支持。
    - Microsoft.Agents.AI.AGUI：
      提供 Agent-User Interaction (AG-UI) 协议客户端能力，用于前端 UI 实时互动。
    - Microsoft.Agents.AI.Hosting.AGUI.AspNetCore：
      提供在 ASP.NET Core 中托管 AG-UI 协议端点、向前端流式传输 UI 的支持。
    - Microsoft.Agents.AI.Mcp：
      提供 Model Context Protocol (MCP) 支持，允许 Agent 跨服务调用 MCP 工具。
  - 6. 数据与状态持久化 (Storage & Memory)
    - Microsoft.Agents.AI.CosmosNoSql：
      使用 Azure Cosmos DB NoSQL 实现对话历史 (ChatHistoryProvider) 与检查点的持久化存储。
    - Microsoft.Agents.AI.Valkey：
      使用 Valkey (Redis) 实现高并发对话历史存储及基于全文检索的上下文检索。
    - Microsoft.Agents.AI.FoundryMemory：
      提供接入 Azure AI Foundry 云端记忆组件的集成支持。
  - 7. 工具、沙箱与代码执行 (Tools & Execution)
    - Microsoft.Agents.AI.Tools.Shell：
      提供跨平台 Shell 命令行工具，允许 Agent 在授权下运行本地终端命令（支持安全审批）。
    - Microsoft.Agents.AI.Hyperlight：
      集成 Hyperlight 轻量级虚拟机微沙箱，提供极高安全级别的 Python 代码执行 (CodeAct) 能力。
    - Microsoft.Agents.AI.LocalCodeAct：
      提供带语法树 (AST) 校验的本地 Python 代码执行器支持。
    - Microsoft.Agents.AI.Harness：
      提供开箱即用的预配置智能体 HarnessAgent，专用于自动化长运行任务。
  - 8. 开发调试与合规治理 (DevTools & Governance)
    - Microsoft.Agents.AI.DevUI：
      提供本地开发调试 UI 控制台界面（类似 Swagger），方便可视化测试与调优 Agent。
    - Aspire.Hosting.AgentFramework.DevUI：
      提供在 .NET Aspire 分布式应用中一键集成并启动 Agent DevUI 的支持。
    - Microsoft.Agents.AI.Purview：
      连接 Microsoft Purview 数据治理平台，提供企业级 AI 合规与数据防泄漏审计支持。
    - Microsoft.Agents.AI.ProjectTemplates：
      提供 dotnet new 脚手架模版包，用于快速初始化 Agent 开发工程。

# 客户端模式

    使用 OpenAIClient 时，可通过不同的子客户端工厂方法获得针对特定 AI 场景优化的专用客户端对象：

    1. 核心对话与响应模式 (最常用)
    ChatClient `GetChatClient(string model)`
    - 定位：传统 OpenAI 聊天模式 (Chat Completions API)。
    - 用途：基础文本输入输出、通用 Agent 交互及提示词对话。
    ResponsesClient `GetResponsesClient()`
    - 定位：新一代原生 Agent 响应与结构化模式 (Responses API)。
    - 用途：原生支持结构化强类型输入输出（如 JSON Schema 映射 C# 强类型对象）、托管工具调用及更高级的 Agent 增量流响应。

    2. 智能体与工具管理
    AssistantClient `GetAssistantClient()`：云端 Assistants API 客户端，用于管理带有云端持久化状态与内置代码解释器的 Assistant 实体。
    VectorStoreClient `GetVectorStoreClient()`：云端向量数据库客户端，用于创建与管理向量索引（RAG 检索）。
    OpenAIFileClient `GetOpenAIFileClient()`：文件管理客户端，用于上传/下载文档与训练集。

    3. 多模态与多媒体
    AudioClient `GetAudioClient(string model)`：音频客户端（语音识别 Whisper 与 TTS 语音合成）。
    ImageClient `GetImageClient(string model)`：图像客户端（DALL-E 文本生成图片与图像重绘）。
    VideoClient `GetVideoClient()`：视频客户端（Sora 等文本/图像生成视频模型）。
    RealtimeClient `GetRealtimeClient()`：低延迟实时双向语音/文本流会话客户端 (WebSockets)。
    
    4. 微调、评估与管理
    EmbeddingClient `GetEmbeddingClient(string model)`：文本向量化客户端，用于将文本转换为密集向量数组。
    ModerationClient `GetModerationClient(string model)`：内容安全审核客户端，用于检测敏感/违规内容。
    OpenAIModelClient `GetOpenAIModelClient()`：模型列表管理客户端，用于查询当前账号可用模型及元数据。
    FineTuningClient `GetFineTuningClient()`：模型微调客户端，用于提交与管理大模型自定义训练任务。
    EvaluationClient `GetEvaluationClient()` / GraderClient `GetGraderClient()`：模型输出质量评估与打分客户端。
    BatchClient `GetBatchClient()`：大批量异步任务批处理客户端（成本更低，24小时内异步返回）。
    ConversationClient `GetConversationClient()` / ContainerClient `GetContainerClient()`：高级托管环境下的会话历史与沙箱容器客户端。

# AI Agent Framework

    1、AIFunctionFactory
        创建工具，用[Description]描述入参和出参的含义
    2、var session = await agent.CreateSessionAsync();
        创建一个会话，里面会自动管理对话上下文
    3、AIContextProvider
        AI的上下文提供者，记忆组件，一般是基于向量数据库实现，实现RAG。其中：
        ProvideAIContextAsync：在大模型开口前，把准备好的记忆喂给大模型。
        StoreAIContextAsync：在大模型回答后，从刚结束的对话中搜集新记忆存起来。
    4、WorkflowBuilder
        工作流构建器，见【Demos-workflow.cs】
        也可以用于Agent，见【Demos-agent workflow.cs】
        1、工作流模式
          1、顺序型
          2、并发型
          3、条件型
        2、工作流架构
          1、执行器
            这是基本的处理单元。
          2、边
            定义消息在执行器之间的传递路径。
          3、工作流
            协调整个流程，管理执行器、边及整体执行流。

# MCP

  模型上下文协议（MCP） 是一个开放标准，为应用程序向大型语言模型（LLM）提供上下文和工具的方式提供了标准化方法。这使得 AI 代理能够通过“通用适配器”一致地连接到不同的数据源和工具。

  1、MCP 基于客户端-服务器架构，其核心组件包括：
    1、主机 是启动与 MCP 服务器连接的 LLM 应用程序（例如代码编辑器 VSCode）。
    2、客户端 是主机应用内维护与服务器一对一连接的组件。
    3、服务器 是提供具体功能的轻量级程序。
  2、MCP 服务器的能力,为协议中包含三个核心基础功能：
    1、工具：AI 代理可调用的离散动作或功能。例如，天气服务可能提供“获取天气”工具，电子商务服务器可能提供“购买产品”工具。MCP 服务器在能力列表中公布每个工具的名称、描述及输入/输出格式。
    2、资源：由 MCP 服务器提供的只读数据项或文档，客户端可按需获取。示例包括文件内容、数据库记录或日志文件。资源可以是文本（如代码或 JSON）或二进制（如图像或 PDF）。
    3、提示：预定义的模板，提供建议的提示，以支持更复杂的工作流程。
  3、MCP 为 AI 代理带来了显著的优势：
    1、动态工具发现：代理可以动态获取服务器提供的可用工具列表及其描述。相比传统 API 往往需要静态编码集成，且 API 变更需要更新代码，MCP 提供“一次集成”的方式，更具适应性。
    2、跨 LLM 互操作性：MCP 可跨不同 LLM 工作，灵活切换核心模型以评估并提升性能。
    3、标准化安全：MCP 包含标准认证方法，便于扩展对更多 MCP 服务器的访问管理，相较于管理各种传统 API 不同密钥和认证方式，简化了安全管理。

# A2A

  MCP 主要连接 LLM 与工具，代理间协议（A2A） 更进一步，实现不同 AI 代理之间的通信与协作。A2A 将不同组织、环境和技术栈的 AI 代理连接起来，共同完成共享任务。

  1、A2A 核心组件
    A2A 致力于使代理之间通信并协作完成用户子任务。协议中的每个组件均支持这一点：
    1、代理卡,类似 MCP 服务器分享工具列表，代理卡包含：
      1、代理名称。
      2、其完成的一般任务的描述。
      3、具体技能列表及描述，帮助其他代理（甚至人类用户）理解何时及为何调用该代理。
      4、当前代理的端点 URL。
      5、代理的版本及功能，如流式响应和推送通知。
    2、代理执行器
      代理执行器负责传递用户聊天上下文给远程代理，远程代理需要这些信息来理解待完成的任务。在 A2A 服务器中，代理通过自身的 LLM 解析请求并利用内部工具执行任务。
    3、工件
      当远程代理完成请求的任务，其工作成果以工件形式创建。工件包含代理工作的结果，所完成工作的描述以及通过协议传递的文本上下文。工件发送后，远程代理的连接关闭，直至再次需要。
    4、事件队列
      此组件用于处理更新和消息传递。在生产环境中尤为重要，以防任务尚未完成时代理间连接被关闭，尤其是任务完成可能耗时较长。
  2、A2A 的优势
    1、增强协作：使来自不同厂商和平台的代理能够互动、共享上下文并协作，促进传统分离系统间无缝自动化。
    2、模型选择灵活性：每个 A2A 代理可自主选择使用的 LLM，允许按代理优化或微调模型，与某些 MCP 场景中单一 LLM 连接不同。
    3、内置认证：认证集成于 A2A 协议中，为代理交互提供强健安全框架。

# NLWeb

  可以用自然语言使用的网站。

  1、NLWeb 组件
    NLWeb 应用（核心服务代码）：处理自然语言问题的系统。它连接平台各部分生成响应。可以将其视为为网站自然语言功能提供动力的引擎。
  2、NLWeb 协议
    网站自然语言交互的基本规则集。响应以 JSON 格式返回（常用 Schema.org）。其目的是为“AI 网”打造简单基础，就像 HTML 让文档在线共享成为可能。
  3、MCP 服务器（模型上下文协议端点）
    每个 NLWeb 配置也充当MCP 服务器。意味着可以与其他 AI 系统共享工具（如“ask”方法）和数据。实际上，使网站内容和功能可被 AI 代理使用，让网站成为更广泛“代理生态系统”的一部分。
  4、嵌入模型
    用于将网站内容转换为称为向量的数值表示（嵌入）。这些向量以计算机可比较和搜索的方式捕捉含义。向量存储于特殊数据库，用户可选择使用的嵌入模型。
  5、向量数据库（检索机制）
    存储网站内容嵌入的数据库。当有人查询时，NLWeb 检查向量数据库，快速找到最相关信息，返回按相似度排序的可能答案列表。NLWeb 支持多种向量存储系统，如 Qdrant、Snowflake、Milvus、Azure AI Search 和 Elasticsearch。