# SignalR

>## SignalR

---

    1��ʹ�ð�����
        ��˴��룺
        builder.Services.AddSignalR();
        app.MapHub<ChatHub>("/Chat");
        public class ChatHub : Hub
        {
            public async Task SendMessage(string user, string message)
                => await Clients.All.SendAsync("ReceiveMessage", user, message);
        }
        Typescript���룺
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
        
    2��Client
        SendAsync��������Ϣ��
        InvokeAsync���÷��������ڵȴ����Կͻ��˵Ľ����
    3��SignalR ���� API �ṩ OnConnectedAsync �� OnDisconnectedAsync ���ⷽ��������͸������ӡ�
    4����̨������ͻ��˷�����Ϣ��
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

    1��Context
        ConnectionId
            ��ȡ���ӵ�Ψһ ID���� SignalR ���䣩�� ÿ��������һ������ ID��
        UserIdentifier
            ��ȡ�û���ʶ���� Ĭ������£�SignalR ʹ�������ӹ����� ClaimsPrincipal �е� ClaimTypes.  NameIdentifier ��Ϊ�û���ʶ����
        User
            ��ȡ�뵱ǰ�û������� ClaimsPrincipal��
        Items
            ��ȡ�������ڴ����ӷ�Χ�ڹ������ݵļ�/ֵ���ϡ� ���ݿ��Դ洢�ڴ˼����У����ڲ�ͬ�����ķ������ü�Ϊ���ӳ־ñ��档
        Features
        	��ȡ�����Ͽ��õĹ��ܵļ��ϡ� Ŀǰ���ڴ��������²���Ҫ�˼��ϣ����δ���������ϸ��¼��
        ConnectionAborted
        	��ȡһ�� CancellationToken��������������ֹʱ����֪ͨ��
        GetHttpContext()
        	�������ӵ� HttpContext��������Ӳ��� HTTP ����������򷵻� null�� ���� HTTP ���ӣ�����ʹ�ô˷�����ȡ HTTP ��ͷ�Ͳ�ѯ�ַ�������Ϣ��
        Abort()
        	��ֹ���ӡ�
    2��Clients
        All
            ���������ӵĿͻ��˵��÷���
        Caller
            �Ե��������ķ����Ŀͻ��˵��÷���
        Others
            ���������ӵĿͻ��˵��÷����������˷����Ŀͻ��˳��⣩
        AllExcept
        	���������ӵĿͻ��˵��÷�����ָ�����ӳ��⣩
        Client
        	�����ӵ�һ���ض��ͻ��˵��÷���
        Clients
        	�����ӵĶ���ض��ͻ��˵��÷���
        Group
        	��ָ�����е��������ӵ��÷���
        GroupExcept
        	��ָ�����е��������ӵ��÷�����ָ�����ӳ��⣩
        Groups
        	�Զ����������÷���
        OthersInGroup
        	��һ����������÷��������������������ķ����Ŀͻ��ˣ�
        User
        	����һ���ض��û��������������ӵ��÷���
        Users
        	������ָ���û��������������ӵ��÷���

---

>## ����ɸѡ��

---

    1����һ��ɸѡ����
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
    2��������ԣ���ɸѡ��ʹ�ã�
    public class ChatHub
    {
        [LanguageFilter(filterArgument = 0)]
        public async Task SendMessage(string message, string username)
        {
            await Clients.All.SendAsync("SendMessage", $"{username} says: {message}");
        }
    }
    3������ɸѡ����
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSignalR(hubOptions =>
        {
            hubOptions.AddFilter<LanguageFilter>();
        });

        services.AddSingleton<LanguageFilter>();
    }

---