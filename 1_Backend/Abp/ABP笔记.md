# 一、常用命令

|命令|描述|
| :--: | :--: |
|dotnet tool install -g Volo.Abp.Cli|添加abp cli|
|abp new TodoApp -d mongodb|新建项目|
|abp install-libs|安装lib|

# 二、个人理解

# 三、基础知识

---

## 1、配置

    1、通过PreConfigureServices和ConfigureServices为模块配置服务。
    2、通过var options = context.Services.ExecutePreConfiguredActions<MyPreOptions>();获取配置的值。

## 2、依赖注入

    自动注册：
        模块类注册为singleton.
        MVC控制器（继承Controller或AbpController）被注册为transient.
        MVC页面模型（继承PageModel或AbpPageModel）被注册为transient.
        MVC视图组件（继承ViewComponent或AbpViewComponent）被注册为transient.
        应用程序服务（实现IApplicationService接口或继承ApplicationService类）注册为transient.
        存储库（实现IRepository接口）注册为transient.
        域服务（实现IDomainService接口）注册为transient.
        ITransientDependency 注册为transient生命周期.
        ISingletonDependency 注册为singleton生命周期.
        IScopedDependency 注册为scoped生命周期.
    手动注册：
        //注册一个singleton实例
        context.Services.AddSingleton<TaxCalculator>(new TaxCalculator(taxRatio: 0.18));
        //注册一个从IServiceProvider解析得来的工厂方法
        context.Services.AddScoped<ITaxCalculator>(sp => sp.GetRequiredService<TaxCalculator>());
    获取实例：
        1、构造方法注入
            public class TaxAppService : ApplicationService
            {
                // 私有，不能赋值，只能通过构造方法注入
                private readonly ITaxCalculator _taxCalculator;
                public TaxAppService(ITaxCalculator taxCalculator)
                {
                    _taxCalculator = taxCalculator;
                }
            }
        2、属性注入
            public class MyService : ITransientDependency
            {
                // 公有，随时赋值注入
                public ILogger<MyService> Logger { get; set; }
                public MyService()
                {
                    // 设置一个默认的值
                    Logger = NullLogger<MyService>.Instance;
                }
            }
        3、从IServiceProvider解析服务
            var taxCalculator = _serviceProvider.GetService<ITaxCalculator>();

## 3、本地化

    1、添加资源，查看【https://docs.abp.io/zh-Hans/abp/latest/Localization】
    2、使用资源：

---
        后台使用
        public class MyService
        {
            private readonly IStringLocalizer<TestResource> _localizer;
            public MyService(IStringLocalizer<TestResource> localizer)
            {
                _localizer = localizer;
            }
            public void Foo()
            {
                var str = _localizer["HelloWorld"];
            }
        }

---
        MVC使用
        @inject IHtmlLocalizer<TestResource> Localizer
        <h1>@Localizer["HelloWorld"]</h1>

---
        JavaScript使用
        var testResource = abp.localization.getResource('Test');
        var str = testResource('HelloWorld');
        var str = abp.localization.localize('HelloWorld', 'Test');
        var str = abp.localization.localize('HelloWorld'); //uses the default resource
        
--- 

## 4、异常处理

    ABP提供了用于处理Web应用程序异常的标准模型：
    1、自动 处理所有异常 .如果是API/AJAX请求,会向客户端返回一个标准格式化后的错误消息 .
    2、自动隐藏 内部详细错误 并返回标准错误消息.
    3、为异常消息的 本地化 提供一种可配置的方式.
    4、自动为标准异常设置 HTTP状态代码 ,并提供可配置选项,以映射自定义异常.

    你可以通过 AbpExceptionHandlingOptions 类的 SendExceptionsDetailsToClients 属性异常发送到客户端:
    services.Configure<AbpExceptionHandlingOptions>(options =>
    {
        options.SendExceptionsDetailsToClients = true;
    });

## 5、数据验证

    1、数据注解 Attribute
        使用数据注解是一种以声明式对DTO进行验证的简单方法. 
        当使用该类作为应用服务或控制器的参数时,将对其自动验证并抛出本地化异常(由ABP框架处理).示例 :
        public class CreateBookDto
        {
            [Required]
            [StringLength(100)]
            public string Name { get; set; }

            [Required]
            [StringLength(1000)]
            public string Description { get; set; }

            [Range(0, 999.99)]
            public decimal Price { get; set; }
        }
    2、IObjectValidator
        除了自动验证你可能需要手动验证对象,这种情况下注入并使用 IObjectValidator 服务:
        ValidateAsync 方法根据验证​​规则验证给定对象,如果对象没有被验证通过会抛出 AbpValidationException 异常.
        GetErrorsAsync 不会抛出异常,只返回验证错误.
        IObjectValidator 默认由 ObjectValidator 实现. ObjectValidator是可扩展的; 可以实现IObjectValidationContributor接口提供自定义逻辑. 示例 :

        public class MyObjectValidationContributor
            : IObjectValidationContributor, ITransientDependency
        {
            public Task AddErrorsAsync(ObjectValidationContext context)
            {
                //Get the validating object
                var obj = context.ValidatingObject;

                //Add the validation errors if available
                context.Errors.Add(...);
                return Task.CompletedTask;
            }
        }
        记录将类注册到DI(实现ITransientDependency 如同本例)
        ABP会自动发现验证类,并用于任何类型的对象验证(包括自动方法调用验证).
    3、FluentValidation
        public class CreateUpdateBookDtoValidator : AbstractValidator<CreateUpdateBookDto>
        {
            public CreateUpdateBookDtoValidator()
            {
                RuleFor(x => x.Name).Length(3, 10);
                RuleFor(x => x.Price).ExclusiveBetween(0.0f, 999.0f);
            }
        }
        ABP会自动找到这个类并在对象验证时与 CreateUpdateBookDto 关联.

## 6、授权
## 7、缓存
