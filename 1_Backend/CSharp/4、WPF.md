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

># 控件区分

---

    1.子类：
    　　ContentControl是Control的子类，专门用于显示内容的，如常用的Label就是ContentControl的子类
    2.属性：
    ? ? ?Template 是Control类的一个属性；
    ? ? ?ContentTemplate是ContentControl的一个属性；
    3.类型：
    ? ? ?Control的Template属性是ControlTemplate类型的；
    ? ? ?ContentControl的ContentTemplate属性是DataTemplate类型的；
    4.用途：
    ? ? ControlTemplate，顾名思义，是控制控件外观和结构的，一般对于某个控件的类型，如一个Button长什么样子，Buttton里有一个列表，列表左侧显示图片等；
    ? ? DataTemplate，则是控制一个控件它的数据要如何呈现的，一般对于的是某种数据的类型，(一般是用来修饰其Content属性的)，所以要求为该类型的属性赋值，
? ? ? ? 如：
? ? ? ? ? ?Label的Content属性赋值后，可以设置Label的ContentTemplate；
? ? ? ? ? ?ItemsControl的ItemsSource属性赋值后，可以设置其的ItemTemplate；
? ? ? ? ? ?HeaderItemsControl的Header属性赋值后，可以设置其的HeaderTemplate；
    5.WPF模板类的继承关系
    ? ? 1、FrameworkTemplate?派生出：ControlTemplate(决定控件外观)、ItemsPanelTemplate(决定集合的容器)、DataTemplate(决定数据的呈现方式)
        2、DateTemplate又派生出?HierarchicalDataTemplate(层次数据模板，一般用于TreeView和Menu)

---

># Style

---
    
    1、创建样式的最常见方法是在 XAML 文件的 Resources 部分中声明为资源。 由于样式是一种资源，因此它们同样遵从适用于所有资源的范围规则。 简而言之，声明样式的位置会影响样式的应用范围。 例如，如果在应用定义 XAML 文件的根元素中声明样式，则该样式可以在应用中的任何位置使用。可以将 Style 视为一种将一组属性值应用到一个或多个元素的便利方法。 

---

># ControlTemplate

---
    
    1、创建ControlTemplate 的最常见方法是在 XAML 文件的 Resources 部分中声明为资源。 模板是资源，因此它们遵从适用于所有资源的相同范围规则。 简言之，声明模板的位置会影响模板的应用范围。 例如，如果在应用程序定义 XAML 文件的根元素中声明模板，则该模板可以在应用程序中的任何位置使用。 如果在窗口中定义模板，则仅该窗口中的控件可以使用该模板。
    2、TemplateBinding
        创建新的 ControlTemplate 时，可能仍然想要使用公共属性更改控件外观。 TemplateBinding 标记扩展将 ControlTemplate 中元素的属性绑定到由控件定义的公共属性。 
    3、ContentPresenter
    4、触发器
        <ControlTemplate x:Key="roundbutton" TargetType="Button">
            <Grid>
                <Ellipse Fill="{TemplateBinding Background}" Stroke="{TemplateBinding Foreground}" />
                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
            </Grid>
            <ControlTemplate.Triggers>
                <Trigger Property="IsMouseOver" Value="true">
                    <Setter Property="Fill" TargetName="backgroundElement" Value="AliceBlue"/>
                </Trigger>
            </ControlTemplate.Triggers>
        </ControlTemplate>
    5、VisualState
        Normal	CommonStates	默认状态。
        MouseOver	CommonStates	鼠标指针悬停在控件上方。
        Pressed	CommonStates	已按下控件。
        Disabled	CommonStates	已禁用控件。
        Focused	FocusStates	控件有焦点。
        Unfocused	FocusStates	控件没有焦点
        <ControlTemplate x:Key="roundbutton" TargetType="Button">
            <Grid>
                <VisualStateManager.VisualStateGroups>
                    <VisualStateGroup Name="CommonStates">
                        <VisualState Name="Normal">
                            <Storyboard>
                                <ColorAnimation Storyboard.TargetName="backgroundElement" 
                                    Storyboard.TargetProperty="(Shape.Fill).(SolidColorBrush.Color)"
                                    To="{TemplateBinding Background}"
                                    Duration="0:0:0.3"/>
                            </Storyboard>
                        </VisualState>
                        <VisualState Name="MouseOver">
                            <Storyboard>
                                <ColorAnimation Storyboard.TargetName="backgroundElement" 
                                    Storyboard.TargetProperty="(Shape.Fill).(SolidColorBrush.Color)" 
                                    To="Yellow" 
                                    Duration="0:0:0.3"/>
                            </Storyboard>
                        </VisualState>
                    </VisualStateGroup>
                </VisualStateManager.VisualStateGroups>
                <Ellipse Name="backgroundElement" Fill="{TemplateBinding Background}" Stroke="{TemplateBinding Foreground}" />
                <ContentPresenter x:Name="contentPresenter" HorizontalAlignment="Center" VerticalAlignment="Center" />
            </Grid>
        </ControlTemplate>
        
---

># 数据绑定

---
    1、使用 Binding 对象建立绑定，且每个绑定通常具有四个组件：绑定目标、目标属性、绑定源以及指向要使用的源值的路径。 
    1、Binding.Mode 绑定方式，单向或者双向之类的
    2、UpdateSourceTrigger
        PropertyChanged
        LostFocus
        Explicit 应用调用UpdateSource时
    3、绑定源
        1、Binding.Source
            Source={StaticResource myDataSource}
        2、Binding.ElementName 
        3、Binding.RelativeSource 
    4、数据转换
        [ValueConversion(typeof(Color), typeof(SolidColorBrush))]
        public class ColorBrushConverter : IValueConverter
        {
            public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
            {
                Color color = (Color)value;
                return new SolidColorBrush(color);
            }

            public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
            {
                return null;
            }
        }
    5、集合ObservableCollection<T> 
    6、枚举快速下拉框
        <Window.Resources>
            <ObjectDataProvider x:Key="EnumDataSource"
                                ObjectType="{x:Type sys:Enum}"
                                MethodName="GetValues">
                <ObjectDataProvider.MethodParameters>
                    <x:Type TypeName="HorizontalAlignment" />
                </ObjectDataProvider.MethodParameters>
            </ObjectDataProvider>
        </Window.Resources>
        <StackPanel Width="300" Margin="10">
            <ListBox Name="myComboBox" SelectedIndex="0"
                    ItemsSource="{Binding Source={StaticResource EnumDataSource}}"/>
        </StackPanel>
    </Window>

---

># 其他

---
    
    1、Style
        创建样式的最常见方法是在 XAML 文件的 Resources 部分中声明为资源。 由于样式是一种资源，因此它们同样遵从适用于所有资源的范围规则。 简而言之，声明样式的位置会影响样式的应用范围。 例如，如果在应用定义 XAML 文件的根元素中声明样式，则该样式可以在应用中的任何位置使用。可以将 Style 视为一种将一组属性值应用到一个或多个元素的便利方法。
    2、附加事件
        路由事件和 CLR 事件之间的一个主要区别是，路由事件遍历元素树来查找处理程序，而 CLR 事件不遍历元素树，处理程序只能附加到引发事件的源对象。 因此，路由事件 sender 可以是元素树中的任何已遍历的元素。
        附加事件可用于在非元素类中定义新的路由事件，并在树中的任何元素上引发该事件。 为此，必须将附加事件注册为路由事件，并提供支持附加事件功能的特定支持代码。 由于附加事件注册为路由事件，因此在元素上引发时，它们会通过元素树传播。
        public class CustomButton : Button
        {
            // Register a custom routed event using the Bubble routing strategy.
            public static readonly RoutedEvent ConditionalClickEvent = EventManager.RegisterRoutedEvent(
                name: "ConditionalClick",
                routingStrategy: RoutingStrategy.Bubble,
                handlerType: typeof(RoutedEventHandler),
                ownerType: typeof(CustomButton));

            // Provide CLR accessors for assigning an event handler.
            public event RoutedEventHandler ConditionalClick
            {
                add { AddHandler(ConditionalClickEvent, value); }
                remove { RemoveHandler(ConditionalClickEvent, value); }
            }

            void RaiseCustomRoutedEvent()
            {
                // Create a RoutedEventArgs instance.
                RoutedEventArgs routedEventArgs = new(routedEvent: ConditionalClickEvent);

                // Raise the event, which will bubble up through the element tree.
                RaiseEvent(routedEventArgs);
            }

            // For demo purposes, we use the Click event as a trigger.
            protected override void OnClick()
            {
                // Some condition combined with the Click event will trigger the ConditionalClick event.
                if (DateTime.Now > new DateTime())
                    RaiseCustomRoutedEvent();

                // Call the base class OnClick() method so Click event subscribers are notified.
                base.OnClick();
            }
        }
        <StackPanel Name="StackPanel1" custom:CustomButton.ConditionalClick="Handler_ConditionalClick">
            <custom:CustomButton
                Name="customButton"
                ConditionalClick="Handler_ConditionalClick"
                Content="Click to trigger a custom routed event"
                Background="LightGray">
            </custom:CustomButton>
        </StackPanel>
        private void Handler_ConditionalClick(object sender, RoutedEventArgs e)
        {
            string senderName = ((FrameworkElement)sender).Name;
            string sourceName = ((FrameworkElement)e.Source).Name;

            Debug.WriteLine($"Routed event handler attached to {senderName}, " +
                $"triggered by the ConditionalClick routed event raised on {sourceName}.");
        }
    3、依赖属性 附加属性
        附加属性和定义一般的依赖属性一样没什么区别，只是用RegisterAttached方法代替了Register方法罢了。

---