# CSharp 12

>## 多态性

---

	override：重写
	new:新写，和继承的同名方法没关系。
	
---


>## record

---

	/// <summary>
	/// 通过反编译确定
	/// 1、在编译时，重写了Equals，判断了所有属性是否相同。
	/// 2、在编译时，重写了ToString
	/// 3、在编译时，重写了GetHashCode
	/// </summary>
	/// <param name="FirstName"></param>
	/// <param name="LastName"></param>
	public record Person(string FirstName, string LastName);
	
---

>## 模式匹配

---

	/// <summary>
	/// 测试是否为空
	/// </summary>
	/// <param name="someNumber"></param>
	private void TestNull(int? someNumber)
	{
		if (someNumber is int number)
		{
			output.WriteLine($"数字为 {number}");
		}
		else
		{
			output.WriteLine("数字为 NULL");
		}
	}

	private void ProvidesFormatInfo(object? obj) => output.WriteLine(obj switch
	{
		ITestOutputHelper tempOutput => $"{tempOutput.GetType()} 类型",
		null => "NULL 对象",
		_ => "未知 类型"
	});

---

>## 解构元组 Deconstruct

---

	public static class NullableExtensions
	{
		public static void Deconstruct<T>(
			this T? nullable,
			out bool hasValue,
			out T value) where T : struct
		{
			hasValue = nullable.HasValue;
			value = nullable.GetValueOrDefault();
		}
	}

	DateTime? questionableDateTime = default;
	var (hasValue, value) = questionableDateTime;
	Console.WriteLine($"{{ HasValue = {hasValue}, Value = {value} }}");

---

>## 异步操作的三种模式

---

	.NET 提供了执行异步操作的三种模式：
	基于任务的异步模式 (TAP) ，该模式使用单一方法表示异步操作的开始和完成。 TAP 是在 .NET Framework 4 中引入的。 这是在 .NET 中进行异步编程的推荐方法。 C# 中的 async 和 await 关键词以及 Visual Basic 中的 Async 和 Await 运算符为 TAP 添加了语言支持。 有关详细信息，请参阅基于任务的异步模式 (TAP)。

	基于事件的异步模式 (EAP)，是提供异步行为的基于事件的旧模型。 这种模式需要后缀为 Async 的方法，以及一个或多个事件、事件处理程序委托类型和 EventArg 派生类型。 EAP 是在 .NET Framework 2.0 中引入的。 建议新开发中不再使用这种模式。 有关详细信息，请参阅基于事件的异步模式 (EAP)。

	异步编程模型 (APM) 模式（也称为 IAsyncResult 模式），这是使用 IAsyncResult 接口提供异步行为的旧模型。 在这种模式下，同步操作需要 Begin 和 End 方法（例如，BeginWrite 和 EndWrite以实现异步写入操作）。 不建议新的开发使用此模式。 有关详细信息，请参阅异步编程模型 (APM)。

	模式的比较
	为了快速比较这三种模式的异步操作方式，请考虑使用从指定偏移量处起将指定量数据读取到提供的缓冲区中的Read方法：
	public class MyClass  
	{  
		public int Read(byte [] buffer, int offset, int count);  
	}  

	此方法对应的 TAP 将公开以下单个 ReadAsync 方法：
	public class MyClass  
	{  
		public Task<int> ReadAsync(byte [] buffer, int offset, int count);  
	}  

	对应的 EAP 将公开以下类型和成员的集：
	public class MyClass  
	{  
		public void ReadAsync(byte [] buffer, int offset, int count);  
		public event ReadCompletedEventHandler ReadCompleted;  
	}  

	对应的 APM 将公开 BeginRead 和 EndRead 方法：
	public class MyClass  
	{  
		public IAsyncResult BeginRead(byte [] buffer, int offset, int count,AsyncCallback callback, object state);  
		public int EndRead(IAsyncResult asyncResult);  
	}  
	
---

>## TAP异步

---

	要理解异步，好好读这个：https://learn.microsoft.com/zh-cn/dotnet/csharp/asynchronous-programming/

	await执行的位置很关键，如果马上await，表现出来更像顺序执行（实际也是异步执行）。但是如果后续再await，那么调用方法和执行的async异步方法都会一起执行，表现为异步执行。案例如下：

	public async Task Run()
	{
		// 1、该处调用了DoSomeThingAsync方法，马上会执行DoSomeThingAsync方法。
		// 2、在执行到await的时候，就会返回Task<int>这个任务。
		// 3、因为没有直接awaitTask<int>这个任务，所以代码继续执行。
		var doSomeThingTask = DoSomeThingAsync();

		// 1、这里的任务会和DoSomeThingAsync中的await Task.Delay(5000)同步执行。
		await Task.Delay(2000);

		// 1、不存在await等于Task<int>这个任务，那么DoSomeThingAsync方法中await后续的代码会自己异步执行。
		// 2、存在await等于Task<int>这个任务,那么DoSomeThingAsync方法中await后续的代码执行完成后，从await处返回，继续执行代码。
		await doSomeThingTask;
	}

	public async Task<int> DoSomeThingAsync()
	{
		Console.WriteLine("DoSomeThingAsync");
		await Task.Delay(5000);

		return 1;
	}

---

>## TAP异步 ConfigureAwait

---
	1、await DoSomeThingAsync()等同于await DoSomeThingAsync().ConfigureAwait(true)。
		这种情况下，异步方法直接等待 Task 时，延续任务通常会出现在创建任务的同一线程中。 此行为可能会降低性能，并且可能会导致 UI 线程发生死锁。
	2、await DoSomeThingAsync().ConfigureAwait(false);
		1、提升性能
		2、避免死锁。
		3、由于没有回到原来的线程，可能会导致更新UI报错。
	具体见链接：https://www.cnblogs.com/xiaoxiaotank/p/13529413.html

---

>## TAP异步底层的实现方式之一（制造Task）

---

	public Task<int> DelayAsync(int second, CancellationToken cancellationToken)
	{
		return Task.Run(() =>
		{
			int i = 0;
			for (i = 0; i < second; i++)
			{
				if (cancellationToken.IsCancellationRequested)
				{
					break;
				}

				Thread.Sleep(1000);
			}

			return i;
		}, cancellationToken);
	}

---

>## TAP异步底层的实现方式之二（制造Task）

---

	TaskCompletionSource。在使用Task不方便的地方，使用该办法制造Task。

	// 这里会等待，直到tcs.SetResult被执行。
	await DelayAsync(5,new CancellationToken());
	public Task<int> DelayAsync(int second, CancellationToken cancellationToken)
	{
		var tcs = new TaskCompletionSource<int>();
		Task.Factory.StartNew(() =>
		{
			int i = 0;
			for (i = 0; i < second; i++)
			{
				if (cancellationToken.IsCancellationRequested)
				{
					tcs.SetResult(i);
					break;
				}

				Thread.Sleep(1000);
			}

			tcs.SetResult(i);
		});

		return tcs.Task;
	}

---

>## TAP异步 操作多个异步

---
	
	await Task.WhenAll(eggsTask, baconTask, toastTask);
	Console.WriteLine("Eggs are ready");
	Console.WriteLine("Bacon is ready");
	Console.WriteLine("Toast is ready");
	Console.WriteLine("Breakfast is ready!");

	var breakfastTasks = new List<Task> { eggsTask, baconTask, toastTask };
	while (breakfastTasks.Count > 0)
	{
		Task finishedTask = await Task.WhenAny(breakfastTasks);
		if (finishedTask == eggsTask)
		{
			Console.WriteLine("Eggs are ready");
		}
		else if (finishedTask == baconTask)
		{
			Console.WriteLine("Bacon is ready");
		}
		else if (finishedTask == toastTask)
		{
			Console.WriteLine("Toast is ready");
		}
		await finishedTask;
		breakfastTasks.Remove(finishedTask);
	}
	Near the end, you see the line await finishedTask;The line await Task.WhenAny doesn't await the finished task. It awaits the Task returned by Task.WhenAny. The result of Task.WhenAny is the task that has completed (or faulted). You should await that task again, even though you know it's finished running. That's how you retrieve its result, or ensure that the exception causing it to fault gets thrown.

---

>## TAP异步异常处理

---

	await后面执行的任务，如果有异常，建议直接捕获。因为如果调用方没有await的话，异常就被吃掉了。
	
---

>## TAP异步-其他

---

	Task.FromResult
		Task.FromResult 方法的适用情景为，数据可能已存在，且只需通过提升到 Task<TResult> 的任务返回。例如：
		return TryGetCachedValue(out cachedValue) ? Task.FromResult(cachedValue) :GetValueAsyncInternal();

	Task.WhenAll
		注意聚合异常AggregateException

	Task.WhenAny
		WhenAny 方法可用于异步等待多个表示为要完成的任务的异步操作之一。 此方法适用于四个主要用例：
		1、冗余：多次执行一个操作并选择最先完成的一次（例如，联系能够生成一个结果的多个股市行情 Web 服务并选择完成最快的一个）。
		2、交错：启动多个操作并等待所有这些操作完成，但是在完成这些操作时对其进行处理。
		3、限制：允许其他操作完成时开始附加操作。 这是交错方案的扩展。
		4、早期释放：例如，用任务 t1 表示的操作可以与任务 t2 组成 WhenAny 任务，您可以等待 WhenAny 任务。 任务 t2 可以表示超时、取消或其他一些导致 WhenAny 任务先于 t1 完成的信号。

	Task.Delay
		配合Task.WhenAny实现下载超时。
		public async void btnDownload_Click(object sender, EventArgs e)
		{
			btnDownload.Enabled = false;
			try
			{
				Task<Bitmap> download = GetBitmapAsync(url);
				if (download == await Task.WhenAny(download, Task.Delay(3000)))
				{
					Bitmap bmp = await download;
					pictureBox.Image = bmp;
					status.Text = "Downloaded";
				}
				else
				{
					pictureBox.Image = null;
					status.Text = "Timed out";
					var ignored = download.ContinueWith(
						t => Trace("Task finally completed"));
				}
			}
			finally { btnDownload.Enabled = true; }
		}
		
	实例：AsyncCache - 用来做异步缓存
		// 异步缓存类
		public class AsyncCache<TKey, TValue>
		{
			private readonly Func<TKey, Task<TValue>> _valueFactory;
			private readonly ConcurrentDictionary<TKey, Lazy<Task<TValue>>> _map;

			public AsyncCache(Func<TKey, Task<TValue>> valueFactory)
			{
				if (valueFactory == null) throw new ArgumentNullException("valueFactory");
				_valueFactory = valueFactory;
				_map = new ConcurrentDictionary<TKey, Lazy<Task<TValue>>>();
			}

			public Task<TValue> this[TKey key]
			{
				get
				{
					if (key == null) throw new ArgumentNullException("key");
					return _map.GetOrAdd(key, toAdd =>
						new Lazy<Task<TValue>>(() => _valueFactory(toAdd))).Value;
				}
			}
		}

		// 创建一个key为string，value为stirng的异步缓存实例
		private AsyncCache<string,string> m_webPages = new AsyncCache<string,string>(DownloadStringTaskAsync);

		// 使用异步缓存，只会第一次下载，后面都是缓存。
		private async void btnDownload_Click(object sender, RoutedEventArgs e)
		{
			btnDownload.IsEnabled = false;
			try
			{
				txtContents.Text = await m_webPages["https://www.microsoft.com"];
			}
			finally { btnDownload.IsEnabled = true; }
		}
		
	实例：AsyncProducerConsumerCollection -用来做异步的生产者、消费者
		// 异步的生产者、消费者类
		public class AsyncProducerConsumerCollection<T>
		{
			private readonly Queue<T> m_collection = new Queue<T>();
			private readonly Queue<TaskCompletionSource<T>> m_waiting = new Queue<TaskCompletionSource<T>>();

			public void Add(T item)
			{
				TaskCompletionSource<T> tcs = null;
				lock (m_collection)
				{
					// m_waiting有数据，代表m_collection当前没有数据，取走TaskCompletionSource，通过tcs.TrySetResult(item)直接返回当前新增的数据。
					if (m_waiting.Count > 0){
						tcs = m_waiting.Dequeue();
					}
					else{
						m_collection.Enqueue(item);
					}
				}
				if (tcs != null){
					tcs.TrySetResult(item);
				}
			}

			public Task<T> Take()
			{
				lock (m_collection)
				{
					if (m_collection.Count > 0)
					{
						// 有数据，直接取走
						return Task.FromResult(m_collection.Dequeue());
					}
					else
					{
						// 没有数据，创建一个TaskCompletionSource入队，表示当前没有任务了。
						var tcs = new TaskCompletionSource<T>();
						m_waiting.Enqueue(tcs);
						return tcs.Task;
					}
				}
			}
		}

		// 创建一个异步的生产者、消费者实例
		private static AsyncProducerConsumerCollection<int> m_data = …;

		private static async Task ConsumerAsync()
		{
			while(true)
			{
				// 1、取走m_collection出队的数据。
				// 2、通过TaskCompletionSource取走才新增的数据。
				int nextItem = await m_data.Take();
				ProcessNextItem(nextItem);
			}
		}

		private static void Produce(int data)
		{
			m_data.Add(data);
		}

---