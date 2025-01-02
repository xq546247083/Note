# Razor 标记帮助程序

>## 内置标记帮助程序

---

[ASP.NET Core 内置标记帮助程序](https://learn.microsoft.com/zh-cn/aspnet/core/mvc/views/tag-helpers/built-in/anchor-tag-helper?view=aspnetcore-8.0 "ASP.NET Core 内置标记帮助程序")

    1、<a><a/>
    2、<cache>@DateTime.Now</cache>
    3、<component type="typeof(EmbeddedCounter)" render-mode="ServerPrerendered" />
    4、<distributed-cache name="my-distributed-cache-unique-key-101">
            Time Inside Cache Tag Helper: @DateTime.Now
        </distributed-cache>
    5、<form asp-controller="Demo" asp-action="Register" method="post">
            <!-- Input and Submit elements -->
        </form>
    6、<img src="~/images/asplogo.png" asp-append-version="true">
    7、<input asp-for="<Expression Name>">
    8、<label asp-for="Email"></label>
    9、<link rel="stylesheet" 
            href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"
            asp-fallback-href="~/lib/bootstrap/dist/css/bootstrap.css"
            asp-fallback-test-class="sr-only" asp-fallback-test-property="position" 
            asp-fallback-test-value="absolute"
            crossorigin="anonymous"
            integrity="sha256-eSi1q2PG6J7g7ib17yAaWMcrr5GrtohYChqibrV7PBE=" />
    10、<partial name="Shared/_ProductPartial.cshtml" for="Product">
    11、<select asp-for="Country" asp-items="Model.Countries"></select>
    12、<textarea asp-for="Description"></textarea>
    13、<span asp-validation-for="Email"></span>
    14、<div asp-validation-summary="ModelOnly"></div>
 
---

>## 自定义标记帮助程序

---

    // 定义
    public class EmailTagHelper : TagHelper
    {
        private const string EmailDomain = "contoso.com";

        // Can be passed via <email mail-to="..." />. 
        // PascalCase gets translated into kebab-case.
        public string MailTo { get; set; }

        public override void Process(TagHelperContext context, TagHelperOutput output)
        {
            output.TagName = "a";    // Replaces <email> with <a> tag

            var address = MailTo + "@" + EmailDomain;
            output.Attributes.SetAttribute("href", "mailto:" + address);
            output.Content.SetContent(address);
        }
    }
    // 使用
        <email mail-to="Support"></email>
    // 结果
        <a herf=""mailto:Support@contoso.com"></a>

---