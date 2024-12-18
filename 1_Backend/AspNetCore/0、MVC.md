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
        
---

