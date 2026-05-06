# 概括

    Dart是一个强类型的，面向对象的语言，语法来自c家族，和C#高度重合。Dart主要是采用了隔离区概念，定义的变量都是隔离区变量。主要的技术包括：
        1、泛型
        2、异常try catch
        3、注解，对应C#的Attribute

# 记录

    Typedefs：给类型定义个别名
    Extension types：基于一个类型，定义一个新类型
    Extension methods：给类型扩展一个方法 extension NumberParsing on String
    top-level functions：导入该类，直接调用函数
    extends：继承
    with:扩展一个类，需要被扩展类为mixins
    Isolates:逻辑上的线程，对应底层的一个线程，变量都是隔离区的变量，隔离区之间通信，需要通过消息。
    null safety：空安全，所有不可为空的类型，肯定不为空。


```
Callable objects:把类型当做函数调用
class WannabeFunction {
  String call(String a, String b, String c) => '$a $b $c!';
}
var wf = WannabeFunction();
var out = wf('Hi', 'there,', 'gang');
void main() => print(out);
```

```
工厂模式
class Logger {
  static final Map<String, Logger> _cache = {};

  // 工厂构造函数：不一定非要创建新实例，可以从缓存返回
  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  Logger._internal(this.name); // 命名构造函数
  final String name;
}
```

```
和C#元组类似
var getUser() => ('Alice', 25);

void main() {
  var (name, age) = getUser(); // 解构赋值
}
```

```
// C# 写法
var p = new Person();
p.Name = "Alice";
p.Age = 25;
p.Save();

// Dart 写法
var p = Person()
  ..name = "Alice"
  ..age = 25
  ..save(); // 注意：级联操作返回的是对象本身
```

# Isolates

    https://dart.cn/language/concurrency
    概念：当启动程序的时候，会初始化一个主隔离区，这个是我们程序的主要部分，用来驱动UI等的。
    隔离区：
        1、独立的内存堆，定义的变量都是隔离区本地变量(C#的ThreadLocal)，所以可以无锁，同时独立GC。
        2、独立事件循环，每个 Isolate 内部都有一个永不停歇的循环。主要任务有：微任务队列，以及来自其它Isolate的消息，计时器，文件IO返回
        3、消息通信机制，ReceivePort，SendPort
    Isolate.spawn：手动创建 Isolate，需管理端口和生命周期。主要是长任务使用。
    Isolate.run：简化 API，自动处理消息传递和资源释放。

```
import 'dart:isolate';

void main() async {
  // 1. 创建主隔离区的接收端
  final mainReceivePort = ReceivePort();

  // 2. 启动子隔离区，把主隔离区的“投信口”传过去
  await Isolate.spawn(decodeWorker, mainReceivePort.sendPort);

  // 3. 监听消息
  SendPort? workerSendPort;

  mainReceivePort.listen((message) {
    if (message is SendPort) {
      // 握手成功：收到了子隔离区的“投信口”
      workerSendPort = message;
      print("主隔离区：连接成功，开始发送数据");
      
      // 开始发送数据测试
      workerSendPort?.send("RAW_DATA_1");
      workerSendPort?.send("RAW_DATA_2");
    } else {
      // 处理解码后的结果
      print("主隔离区：收到结果 -> $message");
    }
  });
}

// --- 以下运行在子隔离区 (Worker) ---

void decodeWorker(SendPort mainSendPort) {
  // A. 创建子隔离区自己的接收端
  final workerReceivePort = ReceivePort();

  // B. 握手第一步：把子隔离区的“投信口”发回给主隔离区
  mainSendPort.send(workerReceivePort.sendPort);

  // C. 监听主隔离区发来的原始数据
  workerReceivePort.listen((data) {
    print("子隔离区：正在解码 -> $data");
    
    // 模拟解码处理
    String result = "DECODED_$data";
    
    // 把结果发回给主隔离区
    mainSendPort.send(result);
  });
}
```