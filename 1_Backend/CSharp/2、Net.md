# .Net

>## Span<T>、Memeory<T>

---

    作用：
	    从非托管内存中分配连续的内存
	
---

>## 泛型主机

---

    作用：
	    一个后台任务的集成了一些框架的服务。
    
[链接](https://learn.microsoft.com/zh-cn/dotnet/core/extensions/generic-host?tabs=appbuilder)
	
---

>## 文件通配

---

    作用：
        查找文件。Microsoft.Extensions.FileSystemGlobbing包，Matcher类。
    
---

>## 通道（对标go的channel）

---

    作用：
        生产者、消费者的模型。
        var channel = Channel.CreateUnbounded<T>();
        var channel = Channel.CreateBounded<T>(7);

        while (true)
        {
            // May throw ChannelClosedException if
            // the parent channel's writer signals complete.
            var obj = await reader.ReadAsync();
            Console.WriteLine(obj);
        }
    
---

>## 修改私有变量

---

    var person = new Person();
    GetAgeField(person) = 100;

    [UnsafeAccessor(UnsafeAccessorKind.Field, Name = "_age")]
    static extern ref int GetAgeField(Person counter);

---