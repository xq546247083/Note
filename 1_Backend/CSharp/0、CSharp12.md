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

>## 表达式树(Expression)【为啥需要表达式树】

---

	1、表达式树的定义，如：Expression<Func<int,bool>>。它表达一个具有int输入，bool返回值的表达式树（只是通过Func来表达这个意思，但是完全不是Func）。

	2、使用和Func<int,bool>很像，但是增加了很多的限制。所以为什么有表达式树：
		表达式树是给框架的作者用的。试想一下：当你调用框架方法的时候，你会传入一个简单的lambda表达式（lambda表达式还是很方便的），然后框架拿到你传入的表达式树（编译器编译时就已经将你的lambda表达式改装成了表达式树）并进行分析结构，然后做一些东西（对于entity framework来说就是分析表达式树 -> 生成适当sql语句->执行sql语句）。
	
	3、Lambda表达式
		1、代码如：x => x * x;
		2、表达式树的语法糖版本，在使用时会翻译为表达式树，而不是方法。

	4、表达式树可以的操作：
		1、拼接其他表达式树。（这个是很关键的差别）
		2、编译为方法。

---


>## ref(现在可以用于返回值、结构体等)

---

	1、在方法签名和方法调用中，通过引用将参数传递给方法。
	2、在方法签名中，按引用将值返回给调用方。ref return。
	3、ref 局部变量。
	4、在 struct 声明中，声明 ref struct。 
	5、在 ref struct 定义中，声明 ref 字段。

---


>## 新增的关键字

---

	1、operator 和 implicit 或 explicit 关键字分别用于定义隐式转换或显式转换。
	2、required：可以使用 required 关键字强制调用方使用对象初始值设定项设置属性或字段的值。 不需要将所需属性设置为构造函数参数。 编译器可确保所有调用方初始化这些值。
	3、init：在创建对象的时候可以初始化赋值。（get、set、init）
	4、索引器
		public T this[int i]
		{
			get { return arr[i]; }
			set { arr[i] = value; }
		}

---