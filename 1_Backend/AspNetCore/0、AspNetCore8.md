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

    WebApplication：
        指定端口：
            app.Run("https://*:3000");
        多个端口：
            app.Urls.Add("https://*:3000");
            app.Urls.Add("https://*:4000");
        配置指定自定义证书：
            builder.Configuration["Kestrel:Certificates:Default:Path"] = "cert.pem";
            builder.Configuration["Kestrel:Certificates:Default:KeyPath"] = "key.pem";
    NET Generic Host(泛型主机)：
        通用主机（不提供HTTP接口的服务）：
            await Host.CreateDefaultBuilder(args)
            .ConfigureServices(services =>
            {
                services.AddHostedService<SampleHostedService>();
            }).Build().RunAsync();
        通用主机（提供HTTP接口的服务）：
            await Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder =>
            {
                // 指定端口
                webBuilder.UseUrls("http://*:5000");
                webBuilder.UseStartup<Startup>();
            }).Build().RunAsync();
    WEB主机：
        与泛型主机启动HTTP服务的区别在于：启动使用的是[WebHost],泛型主机为[Host]，且不需要再调用[ConfigureWebHostDefaults]。
        WebHost.CreateDefaultBuilder(args)
            .UseUrls("http://*:5000") // 指定端口
            .UseStartup<Startup>().Build().Run();

---

>## 配置

---

    读取配置,方案1（如果在配置中找不到 NumberKey，则使用默认值 99。）：
        private readonly IConfiguration Configuration;
        public TestModel(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public ContentResult OnGet()
        {
            var number = Configuration.GetValue<int>("NumberKey", 99);
        }
    读取配置,方案2：
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
    
    读取配置,方案3：
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
    读取配置,方案4：
        该方案，不会读取在应用启动后对 JSON 配置文件所做的更改。 若要读取在应用启动后的更改，请使用 IOptionsSnapshot。
        builder.Services.Configure<PositionOptions>(builder.Configuration.GetSection(PositionOptions.Position));
        public class Test2Model : PageModel
        {
            private readonly PositionOptions _options;
            // 读取在应用启动后的更改,使用IOptionsSnapshot
            public Test2Model(IOptions<PositionOptions> options)
            {
                _options = options.Value;
            }
        }
    添加自定义配置Json（可用于非当前程序目录的Json配置文件）:
        builder.Configuration.AddJsonFile("MyConfig.json",optional: true,reloadOnChange: true);
    添加内存配置：
        var configDic = new Dictionary<string, string>
        {
           {"MyKey", "Dictionary MyKey Value"},
           {"Position:Title", "Dictionary_Title"},
        };
        builder.Configuration.AddInMemoryCollection(configDic);
    启动时，修改配置：
        builder.Services.Configure<MyOptions>(myOptions =>
        {
            myOptions.Option1 = "Value configured in delegate";
            myOptions.Option2 = 500;
        });
    启动时，显示所有的配置：
        var builder = WebApplication.CreateBuilder(args);
        var app = builder.Build();
        foreach (var c in builder.Configuration.AsEnumerable())
        {
            Console.WriteLine(c.Key + " = " + c.Value);
        }
    修改配置文件appsettings.json：
        // 对appsettings.json文件修改，使用IOptions读取配置参数不会读取到新的配置，因为该接口实例被注册为全局单例生命周期。
        // 所以同时要对IOptions的对象进行修改。
        var filePath = Path.Combine(webHostEnvironment.ContentRootPath, "appsettings.json");
        var text = System.IO.File.ReadAllText(filePath);

        // 修改配置项 
        JObject obj = JObject.Parse(text);
        obj["Author"] = "Herry";
        obj["AppSettings"]["MaxLevel"] = 20;

        // 重新写入
        appsettings.json string result = obj.ToString();
        System.IO.File.WriteAllText(filePath, result);

---

>## 日志

---

    可以结合NLog把日志输出到文件。
    使用方式:
        public AboutModel(ILogger<AboutModel> logger)

---

>## 记录所有的HTTP请求和响应

---

    builder.Services.AddHttpLogging(o => { });
    app.UseHttpLogging();

---

>## HttpClient

---

    1、简单使用：
        builder.Services.AddHttpClient();
        public BasicModel(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }
        var httpClient = _httpClientFactory.CreateClient();
    2、命名HttpClient：
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
    3、HttpClient中间件(可以统一添加异常处理、日志等):
        HttpClient 具有委托处理程序的概念，这些委托处理程序DelegatingHandler可以链接在一起，处理出站 HTTP 请求。
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
        // 先运行ValidateHeaderHandler先运行，再运行 SampleHandler2,最终 HttpClientHandler 执行请求。
        builder.Services.AddHttpClient("HttpMessageHandler")
        .AddHttpMessageHandler<ValidateHeaderHandler>()
        .AddHttpMessageHandler<SampleHandler2>();
    4、使用Nuget Polly包
        请求失败后最多可以重试三次，每次尝试间隔 600 ms
            builder.Services.AddHttpClient("PollyWaitAndRetry")
            .AddTransientHttpErrorPolicy(policyBuilder =>policyBuilder.WaitAndRetryAsync(3, retryNumber => TimeSpan.FromMilliseconds(600)));
        如果出站请求为 HTTP GET，则应用 10 秒超时。 其他所有 HTTP 方法应用 30 秒超时。
            var timeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(10));
            var longTimeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(30));
            builder.Services.AddHttpClient("PollyDynamic")
                .AddPolicyHandler(httpRequestMessage =>httpRequestMessage.Method == HttpMethod.Get ? timeoutPolicy : longTimeoutPolicy);
        Polly 注册表添加策略
            var timeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(10));
            var longTimeoutPolicy = Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(30));

            var policyRegistry = builder.Services.AddPolicyRegistry();
            policyRegistry.Add("Regular", timeoutPolicy);
            policyRegistry.Add("Long", longTimeoutPolicy);

            builder.Services.AddHttpClient("PollyRegistryLong")
            .AddPolicyHandlerFromRegistry("Long")
            .AddPolicyHandlerFromRegistry("Regular");            
    5、在控制台程序中使用HttpClient,引用以下2个包：
        Microsoft.Extensions.Hosting
        Microsoft.Extensions.Http
        var host = new HostBuilder().ConfigureServices(services =>
        {
            services.AddHttpClient();
        })=.Build();
    
---