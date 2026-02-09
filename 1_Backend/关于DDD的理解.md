# 关于DDD的理解

    DDD的英文为Domain Driven Design,领域驱动设计，其中Domain的在分层中为*.Domain,其中包含了数据库的数据实体，以及其业务。主要的代码为处理该实体的业务,不依赖具体技术（数据库、HTTP、UI）的纯业务逻辑代码。

# 传统的三层架构

    业务逻辑全在BLL层里面写。

# DDD思想

    最纯粹的业务逻辑写在Domain层中，聚合不同的业务逻辑写在ApplicationService中。【充血模型】就是DDD思想的一种实现方式。ABP使用的是实体+Manager(继承DomainService)实现，实体只做简单的数据校验，Manager实现业务。

## 简单理解

    把核心业务从ApplicationService下沉到Domain层的Manager，就是DDD。

## 什么时候需要使用DDD

    如果需要调用其他业务的ApplicationService的方法，那就把该方法下沉到Manager中。绝不允许ApplicationService直接调用其它的ApplicationService方法。

## DDD的作用

    1、复用业务逻辑（别重写两遍）
    2、业务逻辑收束，不会散落在各个ApplicationService方法中（别到处乱找）
    3、业务内聚（相关的东西在一起）

## ABP的使用

    ABP没有严谨的使用DDD实现:
        1、没有把所有逻辑都写在实体中
            因为在ABP的依赖注入框架下，实体只能New或者从数据库中查询出来，不能直接注入一个实体。所以添加了一个Manager来注入，并操作实体。
        2、ABP在ApplicationService中直接调用了IRepository
            如果每个实体都有Manager，这样就太复杂了，过度设计。应该是在业务需要在后面的开发中，重复使用，为核心业务，才需要实现Manager。

## DDD的解耦利器：

    在ABP的BasicAggregateRoot（实体都需要继承该类的子类AuditedAggregateRoot）中包含了AddLocalEvent和AddDistributedEvent方法，通过发布事件，其他业务监听事件来解耦业务。

# 充血模型

    1、充血模型强调将完整的业务逻辑封装在领域对象内部，使其成为业务行为的主要执行者。
    2、在这种模型下，领域对象不仅包含属性，还拥有丰富的业务方法来表达领域行为，如复杂的验证逻辑、业务规则的执行、与其他领域对象的协作等。
    3、充血模型的领域对象是自主的、有生命力的实体，能够代表领域内的一个具体概念并完全负责与其相关的所有业务操作。
    4、充血模型鼓励将业务逻辑紧密地与数据结合，从而形成高度内聚的业务组件，有助于保持领域模型的清晰性和完整性。
