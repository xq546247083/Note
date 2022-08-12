# MVVM模式在WPF中的使用规范

 1. MVVM是一种模式,一种思想,一种架构.目前主流的框架有:MVVMLight, Prism...
 2. MVVM的优势:
 2. 主流的UI框架:Telerik(目前主推),Mahapps(开源,我们公司也用了的)...
 2. 请不要在cs文件中写代码(双击button的那个文件). 
 > * 不符合mvvm使用习惯
 > * ViewModel中有代码,cs中有代码,只能通过抛事件交互,各种属性,各种方法,各种悲欢并不相通

 5. 如何避免在cs中写代码
 > * ICommand和依赖属性,比如,VM中一个bool值,绑定到界面,这个值是否被选中,中看VM中的bool
 > * 利用command可以传参,传入SelectedItems(有的SelectedItems不能双向绑定),传入window...
 > * 如果有多个参数,可以用converter
 > * 把路由事件变成Command,这里要用到框架的event to command 类
 > * 附加属性(behavior)
 > * 总之,不能在cs中写代码

 6. 多在xaml中写代码,少在VM中写代码
 > * 触发器控制
 > * DataTemplate Content
 > * DataTemplate中的数据源和我们正在使用的数据源不一样,所以要用到relativesource取找到我们现在用的数据源
 > * xaml中用converter改变值(比如bool变成枚举,有内置的,也可以自己写)
 > * 在头部写上designInstance,这样ctrl就可以跳过去了,注意这个只是设计用的,真正的数据源还是要自己绑定