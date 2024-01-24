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