# AspNetCore 7.0

>## 简化项目引用

---

    在AspNetCore7.0中，引用整个框架的方式如下(通过Nuget包的引用方式不得行了，很多包没有7.0的版本)：
    <ItemGroup>
        <FrameworkReference Include="Microsoft.AspNetCore.App" />
    </ItemGroup>
    也可以通过修改项目类型：
    <Project Sdk="Microsoft.NET.Sdk">修改为<Project Sdk="Microsoft.NET.Sdk.Web">

---