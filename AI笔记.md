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