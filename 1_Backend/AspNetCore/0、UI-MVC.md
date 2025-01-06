# MVC

>## MVC

---

    1、inject 在页面中注入对象，案例如下：
        @inject IConfiguration Configuration
    2、ViewData、ViewBag、TempData
        ViewData和ViewBag其实是一回事， ViewBag其实是对ViewData的封装， 其内部其实是使用ViewData实现数据存储的。唯一的不同点是，ViewBag可以存储动态类型(dynamic)的变量值， 而ViewData只能存储String Key/Object Value字典数组。
        TempData也是一个String Key/Object Value字典数组。 和ViewData与ViewBag不同的是其所存储的数据对象的生命周期。 如果页面发生了跳转(Redirection)，ViewBag和ViewData中的值将不复存在， 但是TempData中的值依然还在。
    3、 ViewDataAttribute、 TempDataAttribute
        可以标记属性是ViewData、TempData。
    4、FromServicesAttribute允许将服务直接注入到操作方法，而无需使用构造函数注入。
        public IActionResult About([FromServices] IDateTime dateTime)
        {
            return Content( $"Current server time: {dateTime.Now}");
        }

        [HttpGet("small")]
        public ActionResult<object> GetSmallCache([FromKeyedServices("small")] ICache cache)
        {
            return cache.Get("data-mvc");
        }
    5、前端页面注入服务,代码如下：
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