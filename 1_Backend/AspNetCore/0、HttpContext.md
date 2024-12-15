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
    11��HttpContext�����̰߳�ȫ�͡�


---
