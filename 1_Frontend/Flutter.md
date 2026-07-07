# 记录

StatelessWidget:静态页面，无状态（类似WPF的Xaml的作用）
StatefulWidget：动态页面，有状态（类似React带State）
Provider、ChangeNotifier:类的属性变更通知到页面（类似WPF的ViewModel的作用），可以配合StatelessWidget使用。
    ChangeNotifier是按照UI树定义的作用域，向上查找的第一个对象使用。
BuildContext：上下文，顺着树向上操作。ChangeNotifier应该就是它实现的。
FutureBuilder：适用于HTTP请求
StreamBuilder：适用于流请求


# UI

Scaffold:Flutter的页面脚手架，除了Body以外，还提供appBar顶部TitleBar、bottomNavigationBar底部导航栏等属性
Navigator：导航，Navigator.push
获取页面传参：var args = ModalRoute.of(context)?.settings.arguments;
widget:Text,Button,Container,Padding,Margin,Transform,Image
布局：Row、Column、Center、Align、Stack、Positioned、Flex、Expanded
动画：AnimatedOpacity、Animation、AnimationController、Tween、Curve
http请求：Dio

# 状态管理

    ChangeNotifier：官方的状态的“大喇叭”，变更后调用notifyListeners通知其他地方刷新。
    ListenableBuilder：用来包裹UI，通知UI刷新。
    Provider：是用来获取ChangeNotifier，同时在UI树上共享ChangeNotifier和自动释放。基于BuildContext。
    Riverpod：改善Provider的问题，完全重写的。以常量形式，解决了需要上下文的问题。主要还是为了简单获取NotifierProvider。
        ref.watch代替ListenableBuilder，用来监听变化获取State重建UI
        ref.read(Provider)用来获取State
        ref.read(Provider.notifier)用来获取Provider，可以调用Provider的方法

# 问题

    如果安装了VS2026，会导致无法定位VS2022的CMake，导致启动Windows报错，修改方案为：
    修改D:\Code\Git\OpenHarmony-SIG\flutter_flutter\packages\flutter_tools\lib\src\windows\visual_studio.dart中的代码为下面的代码：

```
String? get cmakeGenerator {
    // From https://cmake.org/cmake/help/v3.22/manual/cmake-generators.7.html#visual-studio-generators
    return switch (_majorVersion) {
        18 => 'Visual Studio 17 2022',
        17 => 'Visual Studio 17 2022',
        _ => 'Visual Studio 16 2019',
    };
}
```