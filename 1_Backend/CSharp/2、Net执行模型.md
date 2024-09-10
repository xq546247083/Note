# .Net执行模型

>## 类型转发

---

    作用：
	    使用类型转发可以将类型移到另一个程序集，而不必重新编译使用原始程序集的应用程序。
    说明：
        A项目使用B项目的Exapmle类。这个时候，把B项目的Exapmle类迁移到C项目，然后B项目引用C项目，并在B项目的Exapmle类上添加[assembly:TypeForwardedTo(typeof(Example))]属性，A项目不需要重新编译即可运行。

---

>## 友元程序集

---

    作用：
	    友元程序集可以访问当前程序集的internal方法。
    说明：
        [assembly: InternalsVisibleTo("AssemblyB")]

---

>## NET 运行时配置设置

---

    作用：
	    NET 5+（包括 .NET Core 版本）支持使用配置文件和环境变量在运行时配置 .NET 应用程序的行为。
    说明：
        可以配置以下项目：
            1、配置垃圾回收方式、是否并发GC。
            2、线程最大数量、最小熟练等。
            3、WPF配置，是否使用GPU渲染。

---