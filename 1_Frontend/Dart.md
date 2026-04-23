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
    Isolates:逻辑上的线程，对应底层的多个线程，变量都是隔离区的变量，隔离区之间通信，需要通过消息。
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