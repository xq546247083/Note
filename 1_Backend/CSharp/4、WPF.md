# WPF

>## WPF

---

    1、布局控件
        Canvas：
            子控件提供其自己的布局。
        DockPanel：
            子控件与面板的边缘对齐。
        Grid：
            子控件由行和列定位。
        StackPanel：
            子控件垂直或水平堆叠。
        VirtualizingStackPanel：
            子控件在水平或垂直的行上虚拟化并排列。
        WrapPanel：
            子控件按从左到右的顺序放置，在当前行上的空间不足时换行到下一行。
    2、内容模型
        例如，TextBox 的内容是分配给 Text 属性的一个字符串值。但是，其他控件可以包含不同内容类型的多个项；Button 的内容（由 Content 属性指定）可以包含各种项，包括布局控件、文本、图像和形状。
    3、控件模板
        ControlTemplate 更改控件的用户界面的外观，而不更改其内容和行为。
    4、数据模板
        使用控件模板可以指定控件的外观，而使用数据模板则可以指定控件内容的外观。 数据模板经常用于改进绑定数据的显示方式。 默认外观是你对 ListBox的期望。 但是，每个任务的默认外观仅包含任务名称。 若要显示任务名称、描述和优先级，必须使用 ListBox 更改 DataTemplate控件绑定列表项的默认外观。ListBox 会保留其行为和整体外观；只有列表框所显示内容的外观发生变化。
    5、自定义控件
        用户控件模型
            派生自 UserControl 并由一个或多个其他控件组成。
        控件模型
            派生自 Control，并用于生成使用模板将其行为与其外观分隔开来的实现，非常类似大多数 WPF 控件。 派生自 Control 使得你可以更自由地创建自定义用户界面（相较用户控件），但它可能需要花费更多精力。
        框架元素模型。
            当其外观由自定义呈现逻辑（而不是模板）定义时，自定义控件派生自 FrameworkElement 。

---

>## 内置的WPF控件

---

    按钮：
        Button 和 RepeatButton。
    数据显示：
        DataGrid、ListView 和 TreeView。
    日期显示和选项：
        Calendar 和 DatePicker。
    对话框：
        OpenFileDialog、 PrintDialog和 SaveFileDialog。
    数字墨迹：
        InkCanvas 和 InkPresenter。
    文档：
        DocumentViewer、 FlowDocumentPageViewer、 FlowDocumentReader、 FlowDocumentScrollViewer和 StickyNoteControl。
    输入：
        TextBox、 RichTextBox和 PasswordBox。
    布局：
        Border、 BulletDecorator、 Canvas、 DockPanel、 Expander、 Grid、 GridView、 GridSplitter、 GroupBox、 Panel、 ResizeGrip、 Separator、 ScrollBar、 ScrollViewer、 StackPanel、 Thumb、 Viewbox、 VirtualizingStackPanel、 Window和 WrapPanel。
    媒体：
        Image、 MediaElement和 SoundPlayerAction。
    菜单：
        ContextMenu、 Menu和 ToolBar。
    导航：
        Frame、 Hyperlink、 Page、 NavigationWindow和 TabControl。
    选项：
        CheckBox、 ComboBox、 ListBox、 RadioButton和 Slider。
    用户信息：
        AccessText、 Label、 Popup、 ProgressBar、 StatusBar、 TextBlock和 ToolTip。

---