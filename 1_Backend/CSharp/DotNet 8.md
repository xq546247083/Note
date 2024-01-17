# DotNet 8

>## 并行编程的数据结构

---

	System.Collections.Concurrent.BlockingCollection<T>
        实现 System.Collections.Concurrent.IProducerConsumerCollection<T> 的线程安全集合提供阻塞和限制功能。 
        1、如果没有槽可用或回收已满，阻止制作者线程。 
        2、如果回收为空，阻止使用者线程。 
        3、此类型还支持使用者和制作者执行非阻止访问。
        4、可以将 BlockingCollection<T> 用作基类或后备存储，以便为支持 IEnumerable<T> 的任何回收类提供阻止和绑定。
    System.Collections.Concurrent.ConcurrentBag<T>
        提供可缩放的添加和获取操作的线程安全包实现。
    System.Collections.Concurrent.ConcurrentDictionary<TKey,TValue>
        可缩放的并发字典类型。
    System.Collections.Concurrent.ConcurrentQueue<T>
        可缩放的并发 FIFO 队列。
    System.Collections.Concurrent.ConcurrentStack<T>
        可缩放的并发 LIFO 堆栈。
    System.Lazy<T>
        提供线程安全的轻型迟缓初始化。
    System.AggregateException
    类型可用于捕获对各个线程并发抛出的多个异常，并将它们作为一个异常返回给联接线程。 为此，System.Threading.Tasks.Task 和 System.Threading.Tasks.Parallel 类型以及 PLINQ 大量使用 AggregateException。
        
---

>## PLINQ【和Parallel.ForEach相似】

---

	AsParallel	PLINQ 的入口点。 指定如果可能，应并行化查询的其余部分。
    AsSequential	指定查询的其余部分应像非并行的 LINQ 查询一样按顺序运行。
    AsOrdered	指定 PLINQ 应为查询的其余部分保留源序列的排序，或直到例如通过使用 orderby（在 Visual Basic 中为 Order By）子句更改排序为止。
    AsUnordered	指定保留源序列的排序不需要查询其余部分的 PLINQ。
    WithCancellation	指定 PLINQ 应定期监视请求取消时所提供的取消标记的状态以及取消执行。
    WithDegreeOfParallelism	指定 PLINQ 应用于并行化查询的处理器的最大数量。
    WithMergeOptions	提供有关 PLINQ 应如何（如果可能）将并行结果合并回使用线程上的一个序列的提示。
    WithExecutionMode	指定 PLINQ 应如何并行化查询（即使是当默认行为是按顺序运行查询时）。
    ForAll	一种多线程枚举方法，与循环访问查询结果不同，它允许在不首先合并回使用者线程的情况下并行处理结果。
    Aggregate 重载	对于 PLINQ 唯一的重载，它启用对线程本地分区的中间聚合以及一个用于合并所有分区结果的最终聚合函数。
	
---

>## PLINQ和TPL的自定义分区程序

---

	AsParallel	PLINQ 的入口点。 指定如果可能，应并行化查询的其余部分。
    AsSequential	指定查询的其余部分应像非并行的 LINQ 查询一样按顺序运行。
    AsOrdered	指定 PLINQ 应为查询的其余部分保留源序列的排序，或直到例如通过使用 orderby（在 Visual Basic 中为 Order By）子句更改排序为止。
    AsUnordered	指定保留源序列的排序不需要查询其余部分的 PLINQ。
    WithCancellation	指定 PLINQ 应定期监视请求取消时所提供的取消标记的状态以及取消执行。
    WithDegreeOfParallelism	指定 PLINQ 应用于并行化查询的处理器的最大数量。
    WithMergeOptions	提供有关 PLINQ 应如何（如果可能）将并行结果合并回使用线程上的一个序列的提示。
    WithExecutionMode	指定 PLINQ 应如何并行化查询（即使是当默认行为是按顺序运行查询时）。
    ForAll	一种多线程枚举方法，与循环访问查询结果不同，它允许在不首先合并回使用者线程的情况下并行处理结果。
    Aggregate 重载	对于 PLINQ 唯一的重载，它启用对线程本地分区的中间聚合以及一个用于合并所有分区结果的最终聚合函数。
	
---


