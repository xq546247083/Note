# 大模型介绍

    1、按照模态分类
        1、LLM
            大语言模型，Large Language Modles
        2、Multimodal Understanding Model
            多模态理解大模型
        3、Multimodal Generative Model
            多模态生成模型
    2、按照功能分类：
        1、Generative LLM
            生成式大模型
        2、Embedding Model 
            嵌入模型，将文本、图像等离散数据转换为高维向量表示，在向量空间中捕捉语义关系。语义相似的文本在向量空间中距离更近，便于快速检索和比较，输出：固定维度向量（dense vector），不生成文本。知识库检索用。
        3、Reranking
            重排序，相关性打分模型。对知识库检索的数据进行排序。
        4、Classifier
            根据数据特征预测其所属的预定义类别，输出离散的类别标签或概率分布。
    3、AIGC和AGI
        AIGC就是用AI生成内容。Artificial Intelligence Generated Content，人工智能生成内容。
        AGI是通用人工智能，可以自主学习并解决大多数人类可以解决的问题。Artificial General Intelligence，通用人工智能。
        
# 工程实现

    1、提示词工程
    2、RAG
        Retrieval-Augmented Generation，检索增强生成
    3、智能体开发
        智能体通常指一种以大语言模型为推理与决策核心，结合记忆、工具调用与环境交互能力，能够进行规划决策并执行动作以达成目标的软件系统。
    4、微调
    5、续训

# 智能体开发

    1、工具调用的实现方式
        1、Function Call（函数调用，Tools call，工具调用）
            就是大模型支持 tools中定义function，告诉大模型这个function的作用，大模型根据需求决定是否调用这个function，然后智能体再把结果再次传给大模型。
        2、MCP
            MCP（Model Context Protocol，模型上下文协议）是一套标准化的通讯协议，旨在规范AI模型和外部工具、数据源的连接方式。通过MCP协议，AI应用和MCP Server可以建立多对多的双向数据流。过程如下：
            1、连接MCP服务，请求工具列表并缓存。
            2、调用请求MCP服务对应的工具，获取调用结果。

            https://mcp.so/
    2、工作流
    3、自助决策Agent

# RAG

    1、RAG的基本执行流程
        1、建立向量数据库
            解析原始数据，切割为Chunks,然后通过嵌入模型向量化，更新到向量数据库中。
                其中如何解析文件，如何切割，是后续向量查询是否正确的关键。
        2、知识检索
            把用户的提示词通过嵌入模型向量化，在知识库检索出来多个Chunks并排序
        3、然后把用户的提示词和检索出来的Chunks提供给LLM，得到结果

# LangChain

    微软的semantic-kernel对标这个
    1、它的主要点
        1、Models(模型)
        2、Memory(记忆)
        3、Retrieval(检索)
        4、Chains(链)
        5、Agents(智能体)
        6、Callback(回调)
    2、模型调用类型
        1、普通调用
            普通调用，处理单条输入，等待LLM完全推理完成后再返回调用结果
        2、流式调用
            流式响应，是一种逐步返回大模型生成结果的技术，生成一点返回一点，允许服务器将响应内容分批次实时传输给客户端，而不是等待全部内容生成完毕后再一次性返回
        3、批处理，并行调用
            处理批量输入，一次性向模型提交多个输入并并行处理，从而显著提升吞吐量
    3、提示词
        1、提示词消息分类
            1、SystemMessage
                系统消息，type为"system"，告诉大模型当前的背景是什么，应该如何做，并不是所有模型提供商都支持这个消息类型
            2、HumanMessage
                人类输入的消息
            3、AIMessage
                表示模型输出的内容类型，type为"ai"，这可以是文本，也可以是调用工具的请求。
            4、ToolMessage/FunctionMessage
                工具消息，type为"tool"，用于函数调用结果的消息类型
        2、提示词占位符
            可以用于脱敏等，传入{it}
        3、提示词模版
            就是用来构造提示词的，一般用不上。
    4、输出解析器
        用来格式化大模型的输出，先传入格式要求，再格式化输出。
    5、Runnable与LCEL
        Runnable：抽象所有的可执行对线为一个基类。包含：提示词、模型调用，解析器调用，工具调用等。
        LCEL：将多个组件按特定顺序组合起来以便完成复杂任务的一个工作流或管道（Pipeline）。
            1、RunnableSequence-顺序链
            2、RunnableBranch-分支链
            3、RunnableSerializable-串行链
                把多个链结合起来执行
            4、RunnableParallel-并行链
            5、RunnableLambda-函数链
    6、记忆缓存
        1、记忆缓存是聊天系统中的一个重要组件，短期记忆，用于存储和管理对话的上下文信息。它的主要作用是让AI助手能够”记住”之前的对话内容，从而提供连贯和个性化的回复。
        2、执行流程如下：
            1、在链执行前，把历史消息从记忆组件中读取出来，和用户的提示词，一起传递给大模型。
            2、执行完成后，记录用户的输入和大语言模型输出，一起写入到记忆组件。
            3、下次重复该过程。
        3、记忆组件
            1、内存
            2、文件持久
                推荐RedisStack redis的向量数据库，等于原生Redis + 搜索 + 图 + 时间序列 + JSON + 概率结构
        注：应该是可以做一个工具，提供给AI，通过RedisStack查询数据。
    7、Function Call
        通过 Tool（工具）机制，可以让模型具备“调用外部函数”的能力，使其能够与外部系统、API 或自定义函数交互，从而完成仅靠文本生成无法实现的任务。
        大模型不会直接调用，而是返回调用工具的意图，再由代码调用，再把结果传给大模型。


    