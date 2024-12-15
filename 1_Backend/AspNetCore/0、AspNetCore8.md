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

    WebApplication��
        ָ���˿ڣ�
            app.Run("https://*:3000");
        ����˿ڣ�
            app.Urls.Add("https://*:3000");
            app.Urls.Add("https://*:4000");
        ����ָ���Զ���֤�飺
            builder.Configuration["Kestrel:Certificates:Default:Path"] = "cert.pem";
            builder.Configuration["Kestrel:Certificates:Default:KeyPath"] = "key.pem";
    NET Generic Host(��������)��
        ͨ�����������ṩHTTP�ӿڵķ��񣩣�
            await Host.CreateDefaultBuilder(args)
            .ConfigureServices(services =>
            {
                services.AddHostedService<SampleHostedService>();
            }).Build().RunAsync();
        ͨ���������ṩHTTP�ӿڵķ��񣩣�
            await Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder =>
            {
                // ָ���˿�
                webBuilder.UseUrls("http://*:5000");
                webBuilder.UseStartup<Startup>();
            }).Build().RunAsync();
    WEB������
        �뷺����������HTTP������������ڣ�����ʹ�õ���[WebHost],��������Ϊ[Host]���Ҳ���Ҫ�ٵ���[ConfigureWebHostDefaults]��
        WebHost.CreateDefaultBuilder(args)
            .UseUrls("http://*:5000") // ָ���˿�
            .UseStartup<Startup>().Build().Run();

---

>## ����

---

    ��ȡ����,����1��������������Ҳ��� NumberKey����ʹ��Ĭ��ֵ 99������
        private readonly IConfiguration Configuration;
        public TestModel(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public ContentResult OnGet()
        {
            var number = Configuration.GetValue<int>("NumberKey", 99);
        }
    ��ȡ����,����2��
        private readonly IConfiguration Configuration;
        public TestModel(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public ContentResult OnGet()
        {
            var myKeyValue = Configuration["MyKey"];
            var title = Configuration["Position:Title"];
        }
    
    ��ȡ����,����3��
        public class PositionOptions
        {
            public const string Position = "Position";

            public string Title { get; set; } = String.Empty;
            public string Name { get; set; } = String.Empty;
        }

        public class Test22Model : PageModel
        {
            private readonly IConfiguration Configuration;
            public Test22Model(IConfiguration configuration)
            {
                Configuration = configuration;
            }

            public ContentResult OnGet()
            {
                var positionConfiguration = Configuration.GetSection(PositionOptions.Position);
                if (!positionConfiguration.Exists())
                {
                    throw new Exception("section2 does not exist.");
                }
                var positionOptions = positionConfiguration.Get<PositionOptions>();
            }
        }
    ��ȡ����,����4��
        �÷����������ȡ��Ӧ��������� JSON �����ļ������ĸ��ġ� ��Ҫ��ȡ��Ӧ��������ĸ��ģ���ʹ�� IOptionsSnapshot��
        builder.Services.Configure<PositionOptions>(builder.Configuration.GetSection(PositionOptions.Position));
        public class Test2Model : PageModel
        {
            private readonly PositionOptions _options;
            // ��ȡ��Ӧ��������ĸ���,ʹ��IOptionsSnapshot
            public Test2Model(IOptions<PositionOptions> options)
            {
                _options = options.Value;
            }
        }
    ����Զ�������Json�������ڷǵ�ǰ����Ŀ¼��Json�����ļ���:
        builder.Configuration.AddJsonFile("MyConfig.json",optional: true,reloadOnChange: true);
    ����ڴ����ã�
        var configDic = new Dictionary<string, string>
        {
           {"MyKey", "Dictionary MyKey Value"},
           {"Position:Title", "Dictionary_Title"},
        };
        builder.Configuration.AddInMemoryCollection(configDic);
    ����ʱ���޸����ã�
        builder.Services.Configure<MyOptions>(myOptions =>
        {
            myOptions.Option1 = "Value configured in delegate";
            myOptions.Option2 = 500;
        });
    ����ʱ����ʾ���е����ã�
        var builder = WebApplication.CreateBuilder(args);
        var app = builder.Build();
        foreach (var c in builder.Configuration.AsEnumerable())
        {
            Console.WriteLine(c.Key + " = " + c.Value);
        }
    �޸������ļ�appsettings.json��
        // ��appsettings.json�ļ��޸ģ�ʹ��IOptions��ȡ���ò��������ȡ���µ����ã���Ϊ�ýӿ�ʵ����ע��Ϊȫ�ֵ����������ڡ�
        // ����ͬʱҪ��IOptions�Ķ�������޸ġ�
        var filePath = Path.Combine(webHostEnvironment.ContentRootPath, "appsettings.json");
        var text = System.IO.File.ReadAllText(filePath);

        // �޸������� 
        JObject obj = JObject.Parse(text);
        obj["Author"] = "Herry";
        obj["AppSettings"]["MaxLevel"] = 20;

        // ����д��
        appsettings.json string result = obj.ToString();
        System.IO.File.WriteAllText(filePath, result);

---

>## ��־

---

    ���Խ��NLog����־������ļ���
    ʹ�÷�ʽ:
        public AboutModel(ILogger<AboutModel> logger)

---

>## ��¼���е�HTTP�������Ӧ

---

    builder.Services.AddHttpLogging(o => { });
    app.UseHttpLogging();

---

>## HttpClient

---

    1����ʹ�ã�
        builder.Services.AddHttpClient();
        public BasicModel(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }
        var httpClient = _httpClientFactory.CreateClient();
    2������HttpClient��
        builder.Services.AddHttpClient("GitHub", httpClient =>
        {
            httpClient.BaseAddress = new Uri("https://api.github.com/");

            // using Microsoft.Net.Http.Headers;
            // The GitHub API requires two headers.
            httpClient.DefaultRequestHeaders.Add(
                HeaderNames.Accept, "application/vnd.github.v3+json");
            httpClient.DefaultRequestHeaders.Add(
                HeaderNames.UserAgent, "HttpRequestsSample");
        });
        var httpClient = _httpClientFactory.CreateClient("GitHub");
    3��HttpClient�м��(����ͳһ����쳣������־��):
        HttpClient ����ί�д������ĸ����Щί�д������DelegatingHandler����������һ�𣬴����վ HTTP ����
        public class ValidateHeaderHandler : DelegatingHandler
        {
            protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
            {
                if (!request.Headers.Contains("X-API-KEY"))
                {
                    return new HttpResponseMessage(HttpStatusCode.BadRequest)
                    {
                        Content = new StringContent(
                            "The API key header X-API-KEY is required.")
                    };
                }

                return await base.SendAsync(request, cancellationToken);
            }
        }
        // ������ValidateHeaderHandler�����У������� SampleHandler2,���� HttpClientHandler ִ������
        builder.Services.AddHttpClient("HttpMessageHandler")
        .AddHttpMessageHandler<ValidateHeaderHandler>()
        .AddHttpMessageHandler<SampleHandler2>();
    4��ʹ��Nuget Polly��
        ����ʧ�ܺ��������������Σ�ÿ�γ��Լ�� 600 ms
            builder.Services.AddHttpClient("PollyWaitAndRetry")
            .AddTransientHttpErrorPolicy(policyBuilder =>policyBuilder.WaitAndRetryAsync(3, retryNumber => TimeSpan.FromMilliseconds(600)));
        �����վ����Ϊ HTTP GET����Ӧ�� 10 �볬ʱ�� �������� HTTP ����Ӧ�� 30 �볬ʱ��
            var timeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(10));
            var longTimeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(30));
            builder.Services.AddHttpClient("PollyDynamic")
                .AddPolicyHandler(httpRequestMessage =>httpRequestMessage.Method == HttpMethod.Get ? timeoutPolicy : longTimeoutPolicy);
        Polly ע�����Ӳ���
            var timeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(10));
            var longTimeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(30));

            var policyRegistry = builder.Services.AddPolicyRegistry();
            policyRegistry.Add("Regular", timeoutPolicy);
            policyRegistry.Add("Long", longTimeoutPolicy);

            builder.Services.AddHttpClient("PollyRegistryLong")
            .AddPolicyHandlerFromRegistry("Long")
            .AddPolicyHandlerFromRegistry("Regular");            
    5���ڿ���̨������ʹ��HttpClient,��������2������
        Microsoft.Extensions.Hosting
        Microsoft.Extensions.Http
        var host = new HostBuilder().ConfigureServices(services =>
        {
            services.AddHttpClient();
        })=.Build();
    
---