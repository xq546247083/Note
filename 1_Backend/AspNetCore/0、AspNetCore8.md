# AspNetCore 8.0

>## 简化项目引用

---

    在AspNetCore8.0中，引用整个框架的方式如下(通过Nuget包的引用方式不得行了，很多包没有7.0的版本)：
    <ItemGroup>
        <FrameworkReference Include="Microsoft.AspNetCore.App" />
    </ItemGroup>
    也可以通过修改项目类型：
    <Project Sdk="Microsoft.NET.Sdk">修改为<Project Sdk="Microsoft.NET.Sdk.Web">

---

>## 启动过程

---

    1、创建WebApplicationBuilder
    2、DI注入，使用Builder.Services.Add注入DI，示例代码如下：
        builder.Services.AddRazorPages();
    3、构建WebApplication，示例代码如下：
        var webApplication = builder.Build();
    4、添加中间件，使用WebApplication.Use添加中间件，示例代码如下：
        webApplication.UseHsts();
        webApplication.UseRouting();
    5、映射路由，示例代码如下：
        webApplication.MapDefaultControllerRoute();
        webApplication.MapRazorPages();
    6、运行
        webApplication.Run();

---

>## MVC、Razor、Blazor区别

---

    区别：
        MVC:
            MVC（Model-View-Controller）是一种软件设计模式，它将应用程序分为三个主要部分：模型（Model）、视图（View）和控制器（Controller）。模型负责数据管理，视图负责呈现数据给用户，控制器协调模型和视图之间的交互，并处理用户的请求。MVC模式能够提高代码的可维护性、可扩展性和重用性?。
        Razor:
            Razor Pages是ASP.NET Core中的一个功能，允许开发者使用Razor语法在单个页面中编写视图和代码逻辑。Razor Pages将模型和控制器代码包含在页面本身中，简化了开发过程，特别适合简单的页面应用。Razor Pages相对于MVC更加简单和直观，开发人员可以更容易地理解和维护代码，尤其适合小型项目或只有少量页面的应用?13。此外，Razor Pages在SEO方面也有优势，因为搜索引擎可以更容易地理解和索引页面的内容?3。
        Blazor：
            Blazor是ASP.NET Core的一个框架，允许使用C#和Razor语法来编写前端代码。Blazor可以在客户端运行C#代码，使用WebAssembly技术，减少了服务器和客户端之间的通信，提供了更好的性能和用户体验。Blazor支持双向数据绑定，使得前端和后端开发人员可以使用相同的语言和工具进行高效协作。Blazor还提供了真正的前端开发体验，使得开发过程更加直观和高效?。
    写法区别：
        MVC:
            Model-View-Controller
        Razor:
            Razor Pages将模型和控制器代码包含在页面本身中，简化了开发过程，特别适合简单的页面应用。
        Blazor：
            Blazor是ASP.NET Core的一个框架，允许使用C#和Razor语法来编写前端代码。前后端代码写在了一起。

---

>## 主机类型

---


---