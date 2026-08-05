# 记录

# AI Agent Demo

```
// Copyright (c) Microsoft. All rights reserved.

// This sample shows how to create and use a simple AI agent with DeepSeek as the backend.

using System.ClientModel;
using OpenAI;
using OpenAI.Chat;

var apiKey = "sk-4f17ba55c9124e80aa9d9a4b19aea80e";
var endpoint = "https://api.deepseek.com";
var model = "deepseek-chat";

// Create an OpenAI client configured for the DeepSeek API endpoint.
var clientOptions = new OpenAIClientOptions { Endpoint = new Uri(endpoint) };
var client = new OpenAIClient(new ApiKeyCredential(apiKey), clientOptions);

var agent = client
    .GetChatClient(model)
    .AsAIAgent(instructions: "你是一个幽默的助手，擅长讲笑话。", name: "Joker");

Console.OutputEncoding = System.Text.Encoding.UTF8;

Console.Clear();
Console.WriteLine("=============================================");
Console.WriteLine("        DeepSeek AI 幽默助手 (Joker)         ");
Console.WriteLine("=============================================");
Console.WriteLine();

while (true)
{
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine("按 [Enter] 键生成笑话:");
    Console.ResetColor();

    Console.ReadLine();
    Console.WriteLine();
    Console.ForegroundColor = ConsoleColor.Green;
    Console.WriteLine("【DeepSeek 回复】:");
    Console.ResetColor();

    Console.ForegroundColor = ConsoleColor.DarkYellow;
    await foreach (var update in agent.RunStreamingAsync("给我讲一个笑话。"))
    {
        Console.Write(update);
    }

    Console.WriteLine();
    Console.WriteLine();
    Console.WriteLine("---------------------------------------------");
    Console.WriteLine();
}
```

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

# 库

    Microsoft.Extensions.AI：统一的工具抽象层
    Microsoft.Agents.AI：企业级工具编排

# AI Agent Framework

    1、AIFunctionFactory
        创建工具，用[Description]描述入参和出参的含义
    2、var session = await agent.CreateSessionAsync();
        创建一个会话，里面会自动管理对话上下文
    3、AIContextProvider
        AI的上下文提供者，记忆组件，一般是基于向量数据库实现，实现RAG。其中：
        ProvideAIContextAsync：在大模型开口前，把准备好的记忆喂给大模型。
        StoreAIContextAsync：在大模型回答后，从刚结束的对话中搜集新记忆存起来。
