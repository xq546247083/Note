# Razor


>## Razor语法（.razor、.cshtml、MVC视图）

--

    1、@if, else if, else, and @switch
        条件语句
    2、@for, @foreach, @while, and @do while
        循环语句
    3、@using
        在 C# 中，using 语句用于确保释放对象。 在 Razor 中，可使用相同的机制来创建包含附加内容的 HTML 帮助程序。
    4、@try, catch, finally
        异常处理
    5、@lock
        锁
    6、 @attribute，案例如下：
        @attribute [Authorize]
    7、@implements
        实现接口
    8、@inherits
        继承类
    9、@inject
        注入实例
    10、@model
        此方案仅适用于 MVC 视图和 Razor Pages (.cshtml)。
    11、@namespace
    12、@page
    13、@section
        @section 指令与 MVC 和 RazorPages 布局 结合使用，允许视图或页面将内容呈现在 HTML 页面的不同部分。
    14、@using
        命名空间
    
---

>##  Razor 组件 (.razor)特殊语法

--

    1、@code
    2、@layout
        @layout 指令为具有 @page 指令的可路由 Razor 组件指定布局。
    3、@rendermode
    4、@typeparam
        泛型组件
    5、@bind
        绑定数据
    6、@on{EVENT}
        事件
    7、@on{EVENT}:preventDefault
        禁止事件的默认操作。
    8、@on{EVENT}:stopPropagation
        停止事件的事件传播。
    9、@key
        @key 指令属性使组件比较算法保证基于键的值保留元素或组件。
    10、@ref
        组件引用 (@ref) 提供了一种引用组件实例的方法，以便可以向该实例发出命令

---


>## Razor页面

---

    1、inject 在页面中注入对象，案例如下：
        @inject IConfiguration Configuration
    2、ViewData,可以通过 ViewDataAttribute 将数据传递到页面。 具有 [ViewData] 特性的属性从 ViewDataDictionary 保存和加载值。
        [ViewData]
        public string Title { get; } = "About";
    3、TempData,可以通过 TempDataAttribute,存储临时数据。可在刷新页面后，保持数据，或者传递给其他页面。可以基于cookie，保存每个用户单独的TempData。
        [TempData]
        public string Message{get; set;}

        public async Task<IActionResult> OnPostAsync()
        {
            _context.Movie.Add(Movie);
            await _context.SaveChangesAsync();

            Message = $"Movie {Movie.Title} added";
            return RedirectToPage("./Index");
        }

        // 在index.cshtml添加这句话，可读取修改页面保存的临时数据Message。TempData.Keep使本次读取后，数据不丢失，刷新页面Message的值还存在。
        @{
            if (TempData["Message"] != null)
            {
                <h3>Message: @TempData["Message"]</h3>
            }
            TempData.Keep("Message");
        }
    4、提交多个请求
        使用 asp-page-handler 标记帮助程序为两个处理程序生成标记。
        <input type="submit" asp-page-handler="JoinList" value="Join" />
        <input type="submit" asp-page-handler="JoinListUC" value="JOIN UC" />

        public async Task<IActionResult> OnPostJoinListAsync()
        {
            _db.Customers.Add(Customer);
            await _db.SaveChangesAsync();
            return RedirectToPage("/Index");
        }

        public async Task<IActionResult> OnPostJoinListUCAsync()
        {
            Customer.Name = Customer.Name?.ToUpperInvariant();
            return await OnPostJoinListAsync();
        }

---

>##  页面筛选器

---

    Razor 页面筛选器 IPageFilter 和 IAsyncPageFilter 允许 Razor Pages 在运行 Razor 页面处理程序前后运行代码。可用于做授权筛选器。
    方案1，全局筛选器：
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddRazorPages()
                .AddMvcOptions(options =>
                {
                    options.Filters.Add(new SampleAsyncPageFilter(Configuration));
                });
        }

        public class SampleAsyncPageFilter : IAsyncPageFilter
        {
            private readonly IConfiguration _config;

            public SampleAsyncPageFilter(IConfiguration config)
            {
                _config = config;
            }

            public Task OnPageHandlerSelectionAsync(PageHandlerSelectedContext context)
            {
                var key = _config["UserAgentID"];
                context.HttpContext.Request.Headers.TryGetValue("user-agent",
                                                                out StringValues value);
                ProcessUserAgent.Write(context.ActionDescriptor.DisplayName,
                                    "SampleAsyncPageFilter.OnPageHandlerSelectionAsync",
                                    value, key.ToString());

                return Task.CompletedTask;
            }

            public async Task OnPageHandlerExecutionAsync(PageHandlerExecutingContext context,
                                                        PageHandlerExecutionDelegate next)
            {
                // Do post work.
                await next.Invoke();
            }
        }
    方案2,部分筛选器：
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddRazorPages(options =>
            {
                options.Conventions.AddFolderApplicationModelConvention(
                    "/Movies",
                    model => model.Filters.Add(new SampleAsyncPageFilter(Configuration)));
            });
        }
    方案3,Page直接重写筛选器：
        public class IndexModel : PageModel
        {
            private readonly IConfiguration _config;

            public IndexModel(IConfiguration config)
            {
                _config = config;
            }

            public override Task OnPageHandlerSelectionAsync(PageHandlerSelectedContext context)
            {
                Debug.WriteLine("/IndexModel OnPageHandlerSelectionAsync");
                return Task.CompletedTask;
            }

            public async override Task OnPageHandlerExecutionAsync(PageHandlerExecutingContext context,PageHandlerExecutionDelegate next)
            {
                var key = _config["UserAgentID"];
                context.HttpContext.Request.Headers.TryGetValue("user-agent", out StringValues value);
                ProcessUserAgent.Write(context.ActionDescriptor.DisplayName,
                                    "/IndexModel-OnPageHandlerExecutionAsync",
                                        value, key.ToString());

                await next.Invoke();
            }
        }
    方案4，属性筛选器：
        public class AddHeaderAttribute  : ResultFilterAttribute
        {
            private readonly string _name;
            private readonly string _value;

            public AddHeaderAttribute (string name, string value)
            {
                _name = name;
                _value = value;
            }

            public override void OnResultExecuting(ResultExecutingContext context)
            {
                context.HttpContext.Response.Headers.Add(_name, new string[] { _value });
            }
        }

        [AddHeader("Author", "Rick")]
        public class TestModel : PageModel
        {
            public void OnGet()
            {

            }
        }

---
