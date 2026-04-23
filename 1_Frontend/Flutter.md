# 记录

StatelessWidget:静态页面（类似WPF的Xaml的作用）
StatefulWidget：动态页面（类似React带State）
ChangeNotifier:类的属性变更通知到页面（类似WPF的ViewModel的作用），可以配合StatelessWidget使用。
    ChangeNotifier是按照UI树定义的作用域，向上查找的第一个对象使用。
BuildContext：上下文，顺着树向上操作。ChangeNotifier应该就是它实现的。
FutureBuilder：
StreamBuilder：