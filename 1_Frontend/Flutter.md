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