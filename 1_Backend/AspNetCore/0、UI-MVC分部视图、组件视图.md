# �ֲ���ͼ�������ͼ

># �ֲ���ͼ�������ͼ����

---

    ��ͼ����� ASP.NET Core MVC �������ԣ������ڷֲ���ͼ��������ǿ����ͼ�����ʹ��ģ�Ͱ󶨣��������ڵ�����ʱ���ṩ�����ݡ����ҿ���ʹ�ú�̨�����߼���

---

>## �ֲ���ͼ

---

    1���������
        <h3>Model��ViewData����</h3>
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
    2����̨��ȡ�ֲ���ͼ���������£�
        new PartialViewResult
        {
            ViewName = "_AuthorPartialRP",
            ViewData = ViewData,
        };
    3���ڱ���ļ���ʹ�÷ֲ���ͼ��
        1��<partial name="_PartialName.cshtml" />
        2��@await Html.PartialAsync("_PartialName")

---

>## ��ͼ���

---

    1��������ͼ�����̨����
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
    2��������ͼ���ǰ�˴��룬���Դ������ǰ�˴��룬��������ָ��ʹ��
        ���� Views/Shared/Components �ļ��С� ���ļ��� ���� ����Ϊ Components��
        ���� Views/Shared/Components/PriorityList �ļ��С� 
        ���� Views/Shared/Components/PriorityList/Default.cshtmlRazor ��ͼ��
        @model IEnumerable<ViewComponentSample.Models.TodoItem>
        <h3>Priority Items</h3>
        <ul>
            @foreach (var todo in Model)
            {
                <li>@todo.Name</li>
            }
        </ul>
    3��ʹ����ͼ���,����ָ��ʹ�õ�ǰ�����
        @await Component.InvokeAsync("PriorityList",
        new { 
            componentName="Default",
            maxPriority =  ViewData["maxPriority"],
            isDone = ViewData["isDone"]  }
        )

---
