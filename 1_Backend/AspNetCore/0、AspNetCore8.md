# AspNetCore 8.0

>## ����Ŀ����

---

    ��AspNetCore8.0�У�����������ܵķ�ʽ����(ͨ��Nuget�������÷�ʽ�������ˣ��ܶ��û��7.0�İ汾)��
    <ItemGroup>
        <FrameworkReference Include="Microsoft.AspNetCore.App" />
    </ItemGroup>
    Ҳ����ͨ���޸���Ŀ���ͣ�
    <Project Sdk="Microsoft.NET.Sdk">�޸�Ϊ<Project Sdk="Microsoft.NET.Sdk.Web">

---

>## ��������

---

    1������WebApplicationBuilder
    2��DIע�룬ʹ��Builder.Services.Addע��DI��ʾ���������£�
        builder.Services.AddRazorPages();
    3������WebApplication��ʾ���������£�
        var webApplication = builder.Build();
    4������м����ʹ��WebApplication.Use����м����ʾ���������£�
        webApplication.UseHsts();
        webApplication.UseRouting();
    5��ӳ��·�ɣ�ʾ���������£�
        webApplication.MapDefaultControllerRoute();
        webApplication.MapRazorPages();
    6������
        webApplication.Run();

---

>## ��������

---


---