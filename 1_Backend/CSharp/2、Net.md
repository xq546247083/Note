# .Net

>## Span<T>��Memeory<T>

---

    ���ã�
	    �ӷ��й��ڴ��з����������ڴ�
	
---

>## ��������

---

    ���ã�
	    һ����̨����ļ�����һЩ��ܵķ���
    
[����](https://learn.microsoft.com/zh-cn/dotnet/core/extensions/generic-host?tabs=appbuilder)
	
---

>## �ļ�ͨ��

---

    ���ã�
        �����ļ���Microsoft.Extensions.FileSystemGlobbing����Matcher�ࡣ
    
---

>## ͨ�����Ա�go��channel��

---

    ���ã�
        �����ߡ������ߵ�ģ�͡�
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