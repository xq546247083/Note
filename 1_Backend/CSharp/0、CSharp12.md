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

>## 属性

---

	required
		设置为要求的
	init
		可以初始化

	案例：
	public class Person
	{
		public Person() { }

		[SetsRequiredMembers]
		public Person(string firstName) => FirstName = firstName;

		public required string FirstName { get; init; }
	}

---

>## 索引器

---

	public class Student
	{
		public Dictionary<string, string> ObjDic { get; set; } = new Dictionary<string, string>();
		// 定义索引器
		public string this[string key]
		{
			get
			{
				if (ObjDic.ContainsKey(key))
					return ObjDic[key];
				return string.Empty;
			}
			set
			{
				ObjDic[key] = value;
			}
		}
	}

	// 使用索引器
	var newStudent = new Student();
	newStudent["cellphone"] = "iphone";
	Console.WriteLine(newStudent["cellphone"]);

---


>## 委托和事件

---

	1、不要重复创建委托
		理论上：不需要为创建的任何需要委托的新功能定义新的委托类型。

		案例：
		public delegate bool Predicate(string obj);
		private Predicate AnotherTestForString;
		等同于
		private Func<string, bool> TestForString;

	2、委托和事件区别
		private Action<string> TestForString;
		private event Action<string> TestForString;

		event也是委托，只是特殊的委托。特殊如下：
		1、event只能用+=、-=来注册\移除方法。普通的委托除了可以用+=、-=来注册、移除方法，还可以直接用=来赋值。
		2、event，TestForString方法只能在类中调用。不添加event，随时可以调用TestForString方法。
		3、event，编辑器会自动为+=、-=推荐代码。

	3、执行异步的委托或事件
		// 定义委托
		public class Student
		{
			public Action<string> TestForString;
		}

		// 注册异步委托
		var newStudent = new Student();
		newStudent.TestForString += TestForStringAsync;
		newStudent.TestForString("test");

		// 实现异步委托，这里的方法是异步的。和Task.Run是一样的效果。
		private async void TestForStringAsync(string str)
		{
			try
			{
				await Task.Delay(1000);
				Console.WriteLine(str);
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex);
			}
		}

---

>## 捕捉非CLS异常

---

	使用RuntimeWrappedException捕获异常：
	try
	{
		myClass.TestThrowNotClsExcepiton();
	}
	catch (RuntimeWrappedException e)
	{
		String s = e.WrappedException as String;
		if (s != null)
		{
			Console.WriteLine(s);
		}
	}
	
---