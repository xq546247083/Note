# HttpContext

>## ����

---

    1������������
        HttpContext.Request �ṩ�� HttpRequest �ķ��ʡ�
        HttpContext.Response �ṩ�� HttpResponse �ķ��ʡ�
    2����ȡRequest��Header�����ַ�ʽ��
        var userAgent = request.Headers.UserAgent;
        var customHeader = request.Headers["x-custom-header"];
    3����ȡRequest��Body������
        await HttpContext.Request.Body.CopyToAsync(writeStream);
    4����ζ�ȡRequest��Body������
        // �������������棬��Ȼ��ȡһ�κ󣬾��޷��ٴζ�ȡ��
        HttpContext.Request.EnableBuffering();
        await HttpContext.Request.Body.CopyToAsync(writeStream);
        HttpContext.Request.Body.Position = 0;
    5��д��Response��Header�����ַ�ʽ��
        response.Headers.CacheControl = "no-cache";
        response.Headers["x-custom-header"] = "Custom value";
    6��д��Response��Body������
        await fileStream.CopyToAsync(HttpContext.Response.Body);
    7���ͻ���ȡ������ʹ��HttpContext.RequestAborted����ΪCancellationToken������ȡ��token��
        var stream = await httpClient.GetStreamAsync("http://contoso/books/{bookId}.json", HttpContext.RequestAborted);
    8��ֹͣ�ͻ��˵�������ֹHTTP������������� HttpContext.RequestAborted ȡ�����ƣ�����ͻ��˷���֪ͨ��ָ����������ֹ������
        HttpContext.Abort();
    9��HttpContext.User�������ڻ�ȡ������������û���
    10��HttpContext.Features �����ṩ�Ե�ǰ����Ĺ��ܽӿڼ��ϵķ��ʡ�
        var feature = context.Features.Get<IHttpMinRequestBodyDataRateFeature>();
        var exceptionHandlerPathFeature = HttpContext.Features.Get<IExceptionHandlerPathFeature>();
        ����Microsoft.AspNetCore.Http.Features�Ĺ��ܽӿڣ�
            IHttpRequestFeature��
                ���� HTTP ����Ľṹ������Э�顢·������ѯ�ַ�������ͷ�����ġ� �˹����Ǵ�������������ġ�
            IHttpResponseFeature��
                ���� HTTP ��Ӧ�Ľṹ������״̬���롢��ͷ����Ӧ�����ġ� �˹����Ǵ�������������ġ�
            IHttpResponseBodyFeature��
                ����ʹ�� Stream��PipeWriter ���ļ�д����Ӧ���ĵĲ�ͬ��ʽ�� �˹����Ǵ�������������ġ� ����滻 IHttpResponseFeature.Body �� IHttpSendFileFeature��
            IHttpAuthenticationFeature��
                ���浱ǰ����������� ClaimsPrincipal��
            IFormFeature��
                ���ڷ����ͻ��洫��� HTTP �Ͷಿ�ֱ��ύ��
            IHttpBodyControlFeature��
                ���ڿ����������Ӧ�����Ƿ�����ͬ�� IO ������
            IHttpActivityFeature��
                ������������������ Activity ��Ϣ��
            IHttpConnectionFeature��
                Ϊ���� ID �Լ����غ�Զ�̵�ַ�Ͷ˿ڶ������ԡ�
            IHttpMaxRequestBodySizeFeature��
                ���Ƶ�ǰ�������������������Ĵ�С��
            IHttpRequestBodyDetectionFeature��
                ָʾ�����Ƿ���������ġ�
            IHttpRequestIdentifierFeature��
                ���һ������ʵ�ֵ�������Ψһ��ʶ����
            IHttpRequestLifetimeFeature��
                ����֧����ֹ���ӣ����߼���Ƿ�����ǰ��ֹ���������ڿͻ��˶Ͽ����ӣ���
            IHttpRequestTrailersFeature��
                �ṩ������β����ͷ������У��ķ���Ȩ�ޡ�
            IHttpResetFeature��
                ����Ϊ֧�����ǵ�Э�飨�� HTTP/2 �� HTTP/3������������Ϣ��
            IHttpResponseTrailersFeature��
                ����Ӧ�ó����ṩ��Ӧβ����ͷ����֧�֣���
            IHttpUpgradeFeature��
                ����� HTTP ������֧�֣�����ͻ���ָ���ڷ�������Ҫ�л�Э��ʱҪʹ�õ�����Э�顣
            IHttpWebSocketFeature��
                ����֧�� WebSocket �� API��
            IHttpsCompressionFeature��
                �����Ƿ�Ӧͨ�� HTTPS ����ʹ����Ӧѹ����
            IItemsFeature��
                �洢ÿ������Ӧ�ó���״̬�� Items ���ϡ�
            IQueryFeature��
                �����������ѯ�ַ�����
            IRequestBodyPipeFeature��
                ���������ı�ʾΪ PipeReader��
            IRequestCookiesFeature��
                �������������� Cookie ��ͷֵ��
            IResponseCookiesFeature��
                ������ν���Ӧ Cookie Ӧ�õ� Set-Cookie ��ͷ��
            IServerVariablesFeature��
                �˹��ܿ����ڷ�������������������� IIS �ṩ�ı�����
            IServiceProvidersFeature��
                �ṩ�Ծ����޶���Χ���������� IServiceProvider �ķ��ʡ�
            ISessionFeature��
                Ϊ֧���û��Ự���� ISessionFactory �� ISession ���� ISessionFeature �� SessionMiddleware ʵ�֣����� ASP.NET Core �еĻỰ����
            ITlsConnectionFeature��
                �������ڼ����ͻ���֤��� API��
            ITlsTokenBindingFeature��
                ����ʹ�� TLS ���ư󶨲����ķ�����
            ITrackingConsentFeature��
                ���ڲ�ѯ������ͳ����йش洢��վ���͹�����ص��û���Ϣ���û�ͬ�⡣
    11��HttpContext�����̰߳�ȫ�͡�

---