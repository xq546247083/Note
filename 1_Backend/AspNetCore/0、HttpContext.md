# HttpContext

>## 概述

---

    1、基础的属性
        HttpContext.Request 提供对 HttpRequest 的访问。
        HttpContext.Response 提供对 HttpResponse 的访问。
    2、读取Request的Header，两种方式：
        var userAgent = request.Headers.UserAgent;
        var customHeader = request.Headers["x-custom-header"];
    3、读取Request的Body的内容
        await HttpContext.Request.Body.CopyToAsync(writeStream);
    4、多次读取Request的Body的内容
        // 必须先启动缓存，不然读取一次后，就无法再次读取！
        HttpContext.Request.EnableBuffering();
        await HttpContext.Request.Body.CopyToAsync(writeStream);
        HttpContext.Request.Body.Position = 0;
    5、写入Response的Header，两种方式：
        response.Headers.CacheControl = "no-cache";
        response.Headers["x-custom-header"] = "Custom value";
    6、写入Response的Body的内容
        await fileStream.CopyToAsync(HttpContext.Response.Body);
    7、客户端取消请求，使用HttpContext.RequestAborted，此为CancellationToken，传入取消token。
        var stream = await httpClient.GetStreamAsync("http://contoso/books/{bookId}.json", HttpContext.RequestAborted);
    8、停止客户端的请求。中止HTTP请求会立即触发 HttpContext.RequestAborted 取消令牌，并向客户端发送通知，指明服务器中止了请求。
        HttpContext.Abort();
    9、HttpContext.User属性用于获取或设置请求的用户。
    10、HttpContext.Features 属性提供对当前请求的功能接口集合的访问。
        var feature = context.Features.Get<IHttpMinRequestBodyDataRateFeature>();
        var exceptionHandlerPathFeature = HttpContext.Features.Get<IExceptionHandlerPathFeature>();
    11、HttpContext并非线程安全型。


---
