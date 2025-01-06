# Razor


>## Razor�﷨��.razor��.cshtml��MVC��ͼ��

--

    1��@if, else if, else, and @switch
        �������
    2��@for, @foreach, @while, and @do while
        ѭ�����
    3��@using
        �� C# �У�using �������ȷ���ͷŶ��� �� Razor �У���ʹ����ͬ�Ļ��������������������ݵ� HTML ��������
    4��@try, catch, finally
        �쳣����
    5��@lock
        ��
    6�� @attribute���������£�
        @attribute [Authorize]
    7��@implements
        ʵ�ֽӿ�
    8��@inherits
        �̳���
    9��@inject
        ע��ʵ��
    10��@model
        �˷����������� MVC ��ͼ�� Razor Pages (.cshtml)��
    11��@namespace
    12��@page
    13��@section
        @section ָ���� MVC �� RazorPages ���� ���ʹ�ã�������ͼ��ҳ�潫���ݳ����� HTML ҳ��Ĳ�ͬ���֡�
    14��@using
        �����ռ�
    
---

>##  Razor ��� (.razor)�����﷨

--

    1��@code
    2��@layout
        @layout ָ��Ϊ���� @page ָ��Ŀ�·�� Razor ���ָ�����֡�
    3��@rendermode
    4��@typeparam
        �������
    5��@bind
        ������
    6��@on{EVENT}
        �¼�
    7��@on{EVENT}:preventDefault
        ��ֹ�¼���Ĭ�ϲ�����
    8��@on{EVENT}:stopPropagation
        ֹͣ�¼����¼�������
    9��@key
        @key ָ������ʹ����Ƚ��㷨��֤���ڼ���ֵ����Ԫ�ػ������
    10��@ref
        ������� (@ref) �ṩ��һ���������ʵ���ķ������Ա�������ʵ����������

---


>## Razorҳ��

---

    1��inject ��ҳ����ע����󣬰������£�
        @inject IConfiguration Configuration
    2��ViewData,����ͨ�� ViewDataAttribute �����ݴ��ݵ�ҳ�档 ���� [ViewData] ���Ե����Դ� ViewDataDictionary ����ͼ���ֵ��
        [ViewData]
        public string Title { get; } = "About";
    3��TempData,����ͨ�� TempDataAttribute,�洢��ʱ���ݡ�����ˢ��ҳ��󣬱������ݣ����ߴ��ݸ�����ҳ�档���Ի���cookie������ÿ���û�������TempData��
        [TempData]
        public string Message{get; set;}

        public async Task<IActionResult> OnPostAsync()
        {
            _context.Movie.Add(Movie);
            await _context.SaveChangesAsync();

            Message = $"Movie {Movie.Title} added";
            return RedirectToPage("./Index");
        }

        // ��index.cshtml�����仰���ɶ�ȡ�޸�ҳ�汣�����ʱ����Message��TempData.Keepʹ���ζ�ȡ�����ݲ���ʧ��ˢ��ҳ��Message��ֵ�����ڡ�
        @{
            if (TempData["Message"] != null)
            {
                <h3>Message: @TempData["Message"]</h3>
            }
            TempData.Keep("Message");
        }
    4���ύ�������
        ʹ�� asp-page-handler ��ǰ�������Ϊ��������������ɱ�ǡ�
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

>##  ҳ��ɸѡ��

---

    Razor ҳ��ɸѡ�� IPageFilter �� IAsyncPageFilter ���� Razor Pages ������ Razor ҳ�洦�����ǰ�����д��롣����������Ȩɸѡ����
    ����1��ȫ��ɸѡ����
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
    ����2,����ɸѡ����
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddRazorPages(options =>
            {
                options.Conventions.AddFolderApplicationModelConvention(
                    "/Movies",
                    model => model.Filters.Add(new SampleAsyncPageFilter(Configuration)));
            });
        }
    ����3,Pageֱ����дɸѡ����
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
    ����4������ɸѡ����
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
