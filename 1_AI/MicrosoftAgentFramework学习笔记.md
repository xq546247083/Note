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
        工作流构建器，见Demos-ai agent workflow.cs