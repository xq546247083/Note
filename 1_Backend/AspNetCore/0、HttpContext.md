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
        来自Microsoft.AspNetCore.Http.Features的功能接口：
            IHttpRequestFeature：
                定义 HTTP 请求的结构，包括协议、路径、查询字符串、标头和正文。 此功能是处理请求所必需的。
            IHttpResponseFeature：
                定义 HTTP 响应的结构，包括状态代码、标头和响应的正文。 此功能是处理请求所必需的。
            IHttpResponseBodyFeature：
                定义使用 Stream、PipeWriter 或文件写出响应正文的不同方式。 此功能是处理请求所必需的。 这会替换 IHttpResponseFeature.Body 和 IHttpSendFileFeature。
            IHttpAuthenticationFeature：
                保存当前与请求关联的 ClaimsPrincipal。
            IFormFeature：
                用于分析和缓存传入的 HTTP 和多部分表单提交。
            IHttpBodyControlFeature：
                用于控制请求或响应正文是否允许同步 IO 操作。
            IHttpActivityFeature：
                用于添加诊断侦听器的 Activity 信息。
            IHttpConnectionFeature：
                为连接 ID 以及本地和远程地址和端口定义属性。
            IHttpMaxRequestBodySizeFeature：
                控制当前请求允许的最大请求正文大小。
            IHttpRequestBodyDetectionFeature：
                指示请求是否可以有正文。
            IHttpRequestIdentifierFeature：
                添加一个可以实现的属性来唯一标识请求。
            IHttpRequestLifetimeFeature：
                定义支持中止连接，或者检测是否已提前终止请求（如由于客户端断开连接）。
            IHttpRequestTrailersFeature：
                提供对请求尾部标头（如果有）的访问权限。
            IHttpResetFeature：
                用于为支持它们的协议（如 HTTP/2 或 HTTP/3）发送重置消息。
            IHttpResponseTrailersFeature：
                允许应用程序提供响应尾部标头（如支持）。
            IHttpUpgradeFeature：
                定义对 HTTP 升级的支持，允许客户端指定在服务器需要切换协议时要使用的其他协议。
            IHttpWebSocketFeature：
                定义支持 WebSocket 的 API。
            IHttpsCompressionFeature：
                控制是否应通过 HTTPS 连接使用响应压缩。
            IItemsFeature：
                存储每个请求应用程序状态的 Items 集合。
            IQueryFeature：
                分析并缓存查询字符串。
            IRequestBodyPipeFeature：
                将请求正文表示为 PipeReader。
            IRequestCookiesFeature：
                分析并缓存请求 Cookie 标头值。
            IResponseCookiesFeature：
                控制如何将响应 Cookie 应用到 Set-Cookie 标头。
            IServerVariablesFeature：
                此功能可用于访问请求服务器变量，如 IIS 提供的变量。
            IServiceProvidersFeature：
                提供对具有限定范围的请求服务的 IServiceProvider 的访问。
            ISessionFeature：
                为支持用户会话定义 ISessionFactory 和 ISession 抽象。 ISessionFeature 由 SessionMiddleware 实现（参阅 ASP.NET Core 中的会话）。
            ITlsConnectionFeature：
                定义用于检索客户端证书的 API。
            ITlsTokenBindingFeature：
                定义使用 TLS 令牌绑定参数的方法。
            ITrackingConsentFeature：
                用于查询、授予和撤消有关存储与站点活动和功能相关的用户信息的用户同意。
    11、HttpContext并非线程安全型。

---