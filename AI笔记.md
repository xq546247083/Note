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
    4、微调
    5、续训