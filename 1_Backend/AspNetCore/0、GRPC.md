# GRPC

>## GRPC��ʵ����

---

    1������ʵ��GRPC
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
    2������GRPC
    var channel = GrpcChannel.ForAddress("https://localhost:5001");
    var client = new Greeter.GreeterClient(channel);
    var response = await client.SayHelloAsync(new HelloRequest { Name = "World" });
    Console.WriteLine(response.Message);

---

>## GRPC

---

    1��gRPC ʹ��Э�����ȷ������� API ������ Ĭ������£�Э�黺���� (protobuf) �����ӿڶ������� (IDL)��
    .proto �ļ�������
        1��gRPC ����Ķ��塣
        2���ڿͻ����������֮�䷢�͵���Ϣ��
        �������£�
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
    2��˫����ʽ����
        1����������ʽ������ôӿͻ��˷���������Ϣ��ʼ��
        2���ͻ�����ʽ�������跢����Ϣ���ɿ�ʼ�ͻ�����ʽ�������
    3��������ͨ��
        1��UnixSocket
            var socketPath = Path.Combine(Path.GetTempPath(), "socket.tmp");
            var builder = WebApplication.CreateBuilder(args);
            builder.WebHost.ConfigureKestrel(serverOptions =>
            {
                serverOptions.ListenUnixSocket(socketPath, listenOptions =>
                {
                    listenOptions.Protocols = HttpProtocols.Http2;
                });
            });
        2��NamedPipe
            var builder = WebApplication.CreateBuilder(args);
            builder.WebHost.ConfigureKestrel(serverOptions =>
            {
                serverOptions.ListenNamedPipe("MyPipeName", listenOptions =>
                {
                    listenOptions.Protocols = HttpProtocols.Http2;
                });
            });

---