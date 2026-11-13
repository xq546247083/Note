# MAF源码解析

## AgentSession

    用来存储Agent运行中的会话状态
        1、任意的对象，可以通过ProviderSessionState，和session的StateBag挂钩，保存运行状态
        2、StateBag通过虚拟化和反序列化，可以进行数据库存储。

## AIAgent和DelegatingAIAgent

    1、AIAgent的【直接】继承者，是干活的
    2、DelegatingAIAgent的【直接】继承者，不是直接干活的额，主要是处理数据，中转到内部的InnerAgent

## 解析MapOpenAIResponses

    1、MicrosoftAgentAIHostingOpenAIEndpointRouteBuilderExtensions
        通过这个，添加OpenAI Responses端点
    2、ResponsesHttpHandler
        转发请求，处理异常
    3、InMemoryResponsesService 这个注释表明，这个是测试或者开发调试用的
        处理请求
        1、IConversationStorage 一个OpenAI的会话存储
        2、校验会话是否存在
        3、获取聊天历史
        4、组装和输出OpenAI Output
    4、HostedAgentResponseExecutor
        1、获取agent，创建hostagent
        2、获取Agent的AgentSessionStore会话存储
    5、AgentResponseExecution
        1、获取Agent的会话
        2、组装Agent的请求，消息列表
        3、调用agent.RunStreamingAsync这个，请求大模型

## 解析MapAGUIServer

    1、AGUIEndpointRouteBuilderExtensions
        通过MapAGUIServerCore这个，添加端点，接受RunAgentInput输入。
        通过下面的方法，获取session会话，转发请求，以及保存会话。

``` Csharp
var session = await hostAgent.GetOrCreateSessionAsync(threadId, cancellationToken).ConfigureAwait(false);

var events = hostAgent
    .RunStreamingAsync(
        ctx.Messages,
        session: session,
        options: new ChatClientAgentRunOptions { ChatOptions = ctx.ChatOptions },
        cancellationToken: cancellationToken)
    .AsChatResponseUpdatesAsync()
    .AsAGUIEventStreamAsync(ctx, cancellationToken);

// Wrap the event stream to save the session after streaming completes.
var eventsWithSessionSave = SaveSessionAfterStreamingAsync(events, hostAgent, threadId, session, cancellationToken);
```
