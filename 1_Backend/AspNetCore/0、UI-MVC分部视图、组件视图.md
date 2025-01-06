# 分部视图、组件视图

># 分部视图、组件视图区别

---

    视图组件是 ASP.NET Core MVC 的新特性，类似于分部视图，但它更强大。视图组件不使用模型绑定，仅依赖于调用它时所提供的数据。而且可以使用后台代码逻辑。

---

>## 分部视图

---

    1、创建组件
        <h3>Model和ViewData数据</h3>
        <div>
            <h4>Model:</h4>
            @if (Model != null) 
            {
                <label>@Model.ToString()</label>
            }
        <br />
        <h4>ViewData:</h4>
            @foreach (var item in @ViewData)
            {
                <label>@item.Key</label>
                <label>@item.Value</label>
                <br />
            }
        </div>
    2、后台获取分部视图，代码如下：
        new PartialViewResult
        {
            ViewName = "_AuthorPartialRP",
            ViewData = ViewData,
        };
    3、在标记文件中使用分部视图：
        1、<partial name="_PartialName.cshtml" />
        2、@await Html.PartialAsync("_PartialName")

---

>## 视图组件

---

    1、创建视图组件后台代码
        using Microsoft.AspNetCore.Mvc;
        using Microsoft.EntityFrameworkCore;
        using ViewComponentSample.Models;

        namespace ViewComponentSample.ViewComponents;

        public class PriorityListViewComponent : ViewComponent
        {
            private readonly ToDoContext db;

            public PriorityListViewComponent(ToDoContext context) => db = context;

            public async Task<IViewComponentResult> InvokeAsync(string componentName,int maxPriority, bool isDone)
            {
                var items = await GetItemsAsync(maxPriority, isDone);
                return View(componentName,items);
            }

            private Task<List<TodoItem>> GetItemsAsync(int maxPriority, bool isDone)
            {
                return db!.ToDo!.Where(x => x.IsDone == isDone &&
                                    x.Priority <= maxPriority).ToListAsync();
            }
        }
    2、创建视图组件前端代码，可以创建多个前端代码，供第三步指定使用
        创建 Views/Shared/Components 文件夹。 此文件夹 必须 命名为 Components。
        创建 Views/Shared/Components/PriorityList 文件夹。 
        创建 Views/Shared/Components/PriorityList/Default.cshtmlRazor 视图：
        @model IEnumerable<ViewComponentSample.Models.TodoItem>
        <h3>Priority Items</h3>
        <ul>
            @foreach (var todo in Model)
            {
                <li>@todo.Name</li>
            }
        </ul>
    3、使用视图组件,可以指定使用的前端组件
        @await Component.InvokeAsync("PriorityList",
        new { 
            componentName="Default",
            maxPriority =  ViewData["maxPriority"],
            isDone = ViewData["isDone"]  }
        )

---
