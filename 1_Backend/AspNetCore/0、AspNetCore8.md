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

>## 主机类型

---


---