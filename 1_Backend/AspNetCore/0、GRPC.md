# GRPC

>## GRPC简单实例：

---

    1、服务实现GRPC
    builder.Services.AddGrpc();
    app.MapGrpcService<GreeterService>();
    public class GreeterService : Greeter.GreeterBase
    {
        private readonly ILogger<GreeterService> _logger;

        public GreeterService(ILogger<GreeterService> logger)
        {
            _logger = logger;
        }
        public override Task<HelloReply> SayHello(HelloRequest request,
            ServerCallContext context)
        {
            _logger.LogInformation("Saying hello to {Name}", request.Name);
            return Task.FromResult(new HelloReply 
            {
                Message = "Hello " + request.Name
            });
        }
    }
    2、调用GRPC
    var channel = GrpcChannel.ForAddress("https://localhost:5001");
    var client = new Greeter.GreeterClient(channel);
    var response = await client.SayHelloAsync(new HelloRequest { Name = "World" });
    Console.WriteLine(response.Message);

---

>## GRPC

---

    1、gRPC 使用协定优先方法进行 API 开发。 默认情况下，协议缓冲区 (protobuf) 用作接口定义语言 (IDL)。
    .proto 文件包含：
        1、gRPC 服务的定义。
        2、在客户端与服务器之间发送的消息。
        案例如下：
        syntax = "proto3";
        option csharp_namespace = "GrpcGreeter";
        package greet;
        // The greeting service definition.
        service Greeter {
        // Sends a greeting
        rpc SayHello (HelloRequest) returns (HelloReply);
        }

        // The request message containing the user's name.
        message HelloRequest {
        string name = 1;
        }

        // The response message containing the greetings.
        message HelloReply {
        string message = 1;
        }
    2、双向流式处理
        1、服务器流式处理调用从客户端发送请求消息开始。
        2、客户端流式处理无需发送消息即可开始客户端流式处理调用
    3、进程内通信
        1、UnixSocket
            var socketPath = Path.Combine(Path.GetTempPath(), "socket.tmp");
            var builder = WebApplication.CreateBuilder(args);
            builder.WebHost.ConfigureKestrel(serverOptions =>
            {
                serverOptions.ListenUnixSocket(socketPath, listenOptions =>
                {
                    listenOptions.Protocols = HttpProtocols.Http2;
                });
            });
        2、NamedPipe
            var builder = WebApplication.CreateBuilder(args);
            builder.WebHost.ConfigureKestrel(serverOptions =>
            {
                serverOptions.ListenNamedPipe("MyPipeName", listenOptions =>
                {
                    listenOptions.Protocols = HttpProtocols.Http2;
                });
            });

---