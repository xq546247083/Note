# 并行编程-任务并行库-DataFlow

>## 预定义的数据流块类型

---

	1、TPL 数据流库提供了多个预定义的数据流块类型。 这些类型分为三个类别：缓冲块、执行块和分组块。 以下部分描述了组成这些类别的块类型。
	2、并发情况：
		默认情况下，TPL 数据流库提供三种执行块类型（ActionBlock<TInput>、TransformBlock<TInput,TOutput> 和 TransformManyBlock<TInput,TOutput>），一次处理一条消息。 这些数据流块类型也会按照接收消息的顺序对消息进行处理。 若要使这些数据流块同时处理该消息，请在构造数据流对象块时设置 ExecutionDataflowBlockOptions.MaxDegreeOfParallelism 属性。MaxDegreeOfParallelism 的默认值为 1，这保证了数据流块一次处理一条消息。 将该属性设置为大于 1 的值将使数据流块可以同时处理多条消息。 将该属性设置为 DataflowBlockOptions.Unbounded 将使基础任务计划程序管理最大并发程度。
		
---

>## 缓冲块

---

	1、BufferBlock<T>
		BufferBlock<T> 类表示一般用途的异步消息结构。 此类存储先进先出 (FIFO) 消息队列，此消息队列可由多个源写入或从多个目标读取。 在目标收到来自 BufferBlock<T> 对象的消息时，将从消息队列中删除此消息。 因此，虽然一个 BufferBlock<T> 对象可以具有多个目标，但只有一个目标将接收每条消息。 需将多条消息传递给另一个组件，且该组件必须接收每条消息时，BufferBlock<T> 类十分有用。
	2、BroadcastBlock<T>
		BroadcastBlock的作用不像BufferBlock，它是使命是让所有和它相联的目标Block都收到数据的副本，这点从它的命名上面就可以看出来了。还有一点不同的是，BroadcastBlock并不保存数据，在每一个数据被发送到所有接收者以后，这条数据就会被后面最新的一条数据所覆盖。如没有目标Block和BroadcastBlock相连的话，数据将被丢弃。但BroadcastBlock总会保存最后一个数据，不管这个数据是不是被发出去过，如果有一个新的目标Block连上来，那么这个Block将收到这个最后一个数据。
	3、WriteOnceBlock<T>
		如果说BufferBlock是最基本的Block，那么WriteOnceBock则是最最简单的Block。它最多只能存储一个数据，一旦这个数据被发送出去以后，这个数据还是会留在Block中，但不会被删除或被新来的数据替换，同样所有的接收者都会收到这个数据的备份。

---

>## 执行块

---
	1、ActionBlock<T>
		ActionBlock实现ITargetBlock，说明它是消费数据的，也就是对输入的一些数据进行处理。它在构造函数中，允许输入一个委托，来对每一个进来的数据进行一些操作。如果使用Action(T)委托，那说明每一个数据的处理完成需要等待这个委托方法结束，如果使用了Func<TInput, Task>)来构造的话，那么数据的结束将不是委托的返回，而是Task的结束。
	2、TransformBlock<TInput, TOutput>
		TransformBlock是TDF提供的另一种Block，顾名思义它常常在数据流中充当数据转换处理的功能。在TransformBlock内部维护了2个Queue，一个InputQueue，一个OutputQueue。InputQueue存储输入的数据，而通过Transform处理以后的数据则放在OutputQueue，OutputQueue就好像是一个BufferBlock。最终我们可以通过Receive方法来阻塞的一个一个获取OutputQueue中的数据。TransformBlock的Completion.Wait()方法只有在OutputQueue中的数据为0的时候才会返回。
	3、TransformManyBlock<TInput, TOutput>
		TransformManyBlock和TransformBlock非常类似，关键的不同点是，TransformBlock对应于一个输入数据只有一个输出数据，而TransformManyBlock可以有多个，及可以从InputQueue中取一个数据出来，然后放多个数据放入到OutputQueue中。
---

>## 分组块

---

	1、BatchBlock<T>
		BatchBlock提供了能够把多个单个的数据组合起来处理的功能，如上图。应对有些需求需要固定多个数据才能处理的问题。在构造函数中需要制定多少个为一个Batch，一旦它收到了那个数量的数据后，会打包放在它的OutputQueue中。当BatchBlock被调用Complete告知Post数据结束的时候，会把InputQueue中余下的数据打包放入OutputQueue中等待处理，而不管InputQueue中的数据量是不是满足构造函数的数量。
		BatchBlock执行数据有两种模式：贪婪模式和非贪婪模式。贪婪模式是默认的。贪婪模式是指任何Post到BatchBlock，BatchBlock都接收，并等待个数满了以后处理。非贪婪模式是指BatchBlock需要等到构造函数中设置的BatchSize个数的Source都向BatchBlock发数据，Post数据的时候才会处理。不然都会留在Source的Queue中。也就是说BatchBlock可以使用在每次从N个Source那个收一个数据打包处理或从1个Source那里收N个数据打包处理。这里的Source是指其他的继承ISourceBlock的，用LinkTo连接到这个BatchBlock的Block。
	2、JoinBlock<T1, T2, ...>
		JoinBlock一看名字就知道是需要和两个或两个以上的Source Block相连接的。它的作用就是等待一个数据组合，这个组合需要的数据都到达了，它才会处理数据，并把这个组合作为一个Tuple传递给目标Block。举个例子，如果定义了JoinBlock<int, string>类型，那么JoinBlock内部会有两个ITargetBlock，一个接收int类型的数据，一个接收string类型的数据。那只有当两个ITargetBlock都收到各自的数据后，才会放到JoinBlock的OutputQueue中，输出。
	3、BatchedJoinBlock<T1, T2, ...>
		BatchedJoinBlock一看就是BacthBlock和JoinBlick的组合。JoinBlick是组合目标队列的一个数据，而BatchedJoinBlock是组合目标队列的N个数据，当然这个N可以在构造函数中配置。如果我们定义的是BatchedJoinBlock<int, string>， 那么在最后的OutputQueue中存储的是Tuple<IList<int>, IList<string>>，也就是说最后得到的数据是Tuple<IList<int>, IList<string>>。它的行为是这样的，还是假设上文的定义，BatchedJoinBlock<int, string>， 构造BatchSize输入为3。那么在这个BatchedJoinBlock种会有两个ITargetBlock，会接收Post的数据。那什么时候会生成一个Tuple<IList<int>，IList<string>>到OutputQueue中呢，测试下来并不是我们想的需要有3个int数据和3个string数据，而是只要2个ITargetBlock中的数据个数加起来等于3就可以了。3和0,2和1，1和2或0和3的组合都会生成Tuple<IList<int>，IList<string>>到OutputQueue中。

---