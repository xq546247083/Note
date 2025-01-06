# MVC

>## MVC

---

    1��inject ��ҳ����ע����󣬰������£�
        @inject IConfiguration Configuration
    2��ViewData��ViewBag��TempData
        ViewData��ViewBag��ʵ��һ���£� ViewBag��ʵ�Ƕ�ViewData�ķ�װ�� ���ڲ���ʵ��ʹ��ViewDataʵ�����ݴ洢�ġ�Ψһ�Ĳ�ͬ���ǣ�ViewBag���Դ洢��̬����(dynamic)�ı���ֵ�� ��ViewDataֻ�ܴ洢String Key/Object Value�ֵ����顣
        TempDataҲ��һ��String Key/Object Value�ֵ����顣 ��ViewData��ViewBag��ͬ���������洢�����ݶ�����������ڡ� ���ҳ�淢������ת(Redirection)��ViewBag��ViewData�е�ֵ���������ڣ� ����TempData�е�ֵ��Ȼ���ڡ�
    3�� ViewDataAttribute�� TempDataAttribute
        ���Ա��������ViewData��TempData��
    4��FromServicesAttribute��������ֱ��ע�뵽����������������ʹ�ù��캯��ע�롣
        public IActionResult About([FromServices] IDateTime dateTime)
        {
            return Content( $"Current server time: {dateTime.Now}");
        }

        [HttpGet("small")]
        public ActionResult<object> GetSmallCache([FromKeyedServices("small")] ICache cache)
        {
            return cache.Get("data-mvc");
        }
    5��ǰ��ҳ��ע�����,�������£�
        @using System.Threading.Tasks
        @using ViewInjectSample.Model
        @using ViewInjectSample.Model.Services
        @model IEnumerable<ToDoItem>
        @inject StatisticsService StatsService
        <!DOCTYPE html>
        <html>
        <body>
            <div>
                <h1>To Do Items</h1>
                <ul>
                    <li>Total Items: @StatsService.GetCount()</li>
                </ul>
            </div>
        </body>
        </html>

        builder.Services.AddTransient<StatisticsService>();

        using System.Linq;
        using ViewInjectSample.Interfaces;
        namespace ViewInjectSample.Model.Services
        {
            public class StatisticsService
            {
                private readonly IToDoItemRepository _toDoItemRepository;

                public StatisticsService(IToDoItemRepository toDoItemRepository)
                {
                    _toDoItemRepository = toDoItemRepository;
                }

                public int GetCount()
                {
                    return _toDoItemRepository.List().Count();
                }
            }
        }   
        
---