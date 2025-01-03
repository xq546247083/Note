# SignalR

>## SignalR

---

    1、使用案例：
        后端代码：
        builder.Services.AddSignalR();
        app.MapHub<ChatHub>("/Chat");
        public class ChatHub : Hub
        {
            public async Task SendMessage(string user, string message)
                => await Clients.All.SendAsync("ReceiveMessage", user, message);
        }
        Typescript代码：
        const connection = new signalR.HubConnectionBuilder()
            .withUrl("/chathub")
            .withAutomaticReconnect()
            .configureLogging(signalR.LogLevel.Information)
            .build();
        async function start() {
            try {
                await connection.start();
                console.log("SignalR Connected.");
                try {
                    await connection.invoke("SendMessage", "userA", "messageA");
                } catch (err) {
                    console.error(err);
                }
            } catch (err) {
                console.log(err);
                setTimeout(start, 5000);
            }
        };
        connection.onclose(async () => {
            await start();
        });
        connection.on("ReceiveMessage", async () => {
                    let promise = new Promise((resolve, reject) => {
                        setTimeout(() => {
                            resolve("message");
                        }, 100);
                    });
                    return promise;
                });
        // Start the connection.
        start();
        
    2、Client
        SendAsync：发送消息。
        InvokeAsync：该方法可用于等待来自客户端的结果。
    3、SignalR 中心 API 提供 OnConnectedAsync 和 OnDisconnectedAsync 虚拟方法来管理和跟踪连接。
    4、后台主动向客户端发送消息：
        public class HomeController : Controller
        {
            private readonly IHubContext<NotificationHub> _hubContext;
            public HomeController(IHubContext<NotificationHub> hubContext)
            {
                _hubContext = hubContext;
            }
        }
        public async Task<IActionResult> Index()
        {
            await _hubContext.Clients.All.SendAsync("Notify", $"Home page loaded at: {DateTime.Now}");
            return View();
        }
---

>## HUB

---

    1、Context
        ConnectionId
            获取连接的唯一 ID（由 SignalR 分配）。 每个连接有一个连接 ID。
        UserIdentifier
            获取用户标识符。 默认情况下，SignalR 使用与连接关联的 ClaimsPrincipal 中的 ClaimTypes.  NameIdentifier 作为用户标识符。
        User
            获取与当前用户关联的 ClaimsPrincipal。
        Items
            获取可用于在此连接范围内共享数据的键/值集合。 数据可以存储在此集合中，会在不同的中心方法调用间为连接持久保存。
        Features
        	获取连接上可用的功能的集合。 目前，在大多数情况下不需要此集合，因此未对其进行详细记录。
        ConnectionAborted
        	获取一个 CancellationToken，它会在连接中止时发出通知。
        GetHttpContext()
        	返回连接的 HttpContext，如果连接不与 HTTP 请求关联，则返回 null。 对于 HTTP 连接，可以使用此方法获取 HTTP 标头和查询字符串等信息。
        Abort()
        	中止连接。
    2、Clients
        All
            对所有连接的客户端调用方法
        Caller
            对调用了中心方法的客户端调用方法
        Others
            对所有连接的客户端调用方法（调用了方法的客户端除外）
        AllExcept
        	对所有连接的客户端调用方法（指定连接除外）
        Client
        	对连接的一个特定客户端调用方法
        Clients
        	对连接的多个特定客户端调用方法
        Group
        	对指定组中的所有连接调用方法
        GroupExcept
        	对指定组中的所有连接调用方法（指定连接除外）
        Groups
        	对多个连接组调用方法
        OthersInGroup
        	对一个连接组调用方法（不包括调用了中心方法的客户端）
        User
        	对与一个特定用户关联的所有连接调用方法
        Users
        	对与多个指定用户关联的所有连接调用方法

---

>## 中心筛选器

---

    1、定一个筛选器：
    public class LanguageFilter : IHubFilter
    {
        // populated from a file or inline
        private List<string> bannedPhrases = new List<string> { "async void", ".Result" };

        public async ValueTask<object> InvokeMethodAsync(HubInvocationContext invocationContext, 
            Func<HubInvocationContext, ValueTask<object>> next)
        {
            var languageFilter = (LanguageFilterAttribute)Attribute.GetCustomAttribute(
                invocationContext.HubMethod, typeof(LanguageFilterAttribute));
            if (languageFilter != null &&
                invocationContext.HubMethodArguments.Count > languageFilter.FilterArgument &&
                invocationContext.HubMethodArguments[languageFilter.FilterArgument] is string str)
            {
                foreach (var bannedPhrase in bannedPhrases)
                {
                    str = str.Replace(bannedPhrase, "***");
                }

                var arguments = invocationContext.HubMethodArguments.ToArray();
                arguments[languageFilter.FilterArgument] = str;
                invocationContext = new HubInvocationContext(invocationContext.Context,
                    invocationContext.ServiceProvider,
                    invocationContext.Hub,
                    invocationContext.HubMethod,
                    arguments);
            }

            return await next(invocationContext);
        }
    }
    2、标记属性，给筛选器使用：
    public class ChatHub
    {
        [LanguageFilter(filterArgument = 0)]
        public async Task SendMessage(string message, string username)
        {
            await Clients.All.SendAsync("SendMessage", $"{username} says: {message}");
        }
    }
    3、配置筛选器：
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSignalR(hubOptions =>
        {
            hubOptions.AddFilter<LanguageFilter>();
        });

        services.AddSingleton<LanguageFilter>();
    }

---