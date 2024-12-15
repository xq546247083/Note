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

>## MVC��Razor��Blazor����

---

    ����
        MVC:
            MVC��Model-View-Controller����һ��������ģʽ������Ӧ�ó����Ϊ������Ҫ���֣�ģ�ͣ�Model������ͼ��View���Ϳ�������Controller����ģ�͸������ݹ�����ͼ����������ݸ��û���������Э��ģ�ͺ���ͼ֮��Ľ������������û�������MVCģʽ�ܹ���ߴ���Ŀ�ά���ԡ�����չ�Ժ�������?��
        Razor:
            Razor Pages��ASP.NET Core�е�һ�����ܣ���������ʹ��Razor�﷨�ڵ���ҳ���б�д��ͼ�ʹ����߼���Razor Pages��ģ�ͺͿ��������������ҳ�汾���У����˿������̣��ر��ʺϼ򵥵�ҳ��Ӧ�á�Razor Pages�����MVC���Ӽ򵥺�ֱ�ۣ�������Ա���Ը����׵�����ά�����룬�����ʺ�С����Ŀ��ֻ������ҳ���Ӧ��?13�����⣬Razor Pages��SEO����Ҳ�����ƣ���Ϊ����������Ը����׵���������ҳ�������?3��
        Blazor��
            Blazor��ASP.NET Core��һ����ܣ�����ʹ��C#��Razor�﷨����дǰ�˴��롣Blazor�����ڿͻ�������C#���룬ʹ��WebAssembly�����������˷������Ϳͻ���֮���ͨ�ţ��ṩ�˸��õ����ܺ��û����顣Blazor֧��˫�����ݰ󶨣�ʹ��ǰ�˺ͺ�˿�����Ա����ʹ����ͬ�����Ժ͹��߽��и�ЧЭ����Blazor���ṩ��������ǰ�˿������飬ʹ�ÿ������̸���ֱ�ۺ͸�Ч?��
    д������
        MVC:
            Model-View-Controller
        Razor:
            Razor Pages��ģ�ͺͿ��������������ҳ�汾���У����˿������̣��ر��ʺϼ򵥵�ҳ��Ӧ�á�
        Blazor��
            Blazor��ASP.NET Core��һ����ܣ�����ʹ��C#��Razor�﷨����дǰ�˴��롣ǰ��˴���д����һ��

---

>## ��������

---


---