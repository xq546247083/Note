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