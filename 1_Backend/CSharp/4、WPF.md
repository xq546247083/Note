# WPF

>## WPF

---

    1�����ֿؼ�
        Canvas��
            �ӿؼ��ṩ���Լ��Ĳ��֡�
        DockPanel��
            �ӿؼ������ı�Ե���롣
        Grid��
            �ӿؼ����к��ж�λ��
        StackPanel��
            �ӿؼ���ֱ��ˮƽ�ѵ���
        VirtualizingStackPanel��
            �ӿؼ���ˮƽ��ֱ���������⻯�����С�
        WrapPanel��
            �ӿؼ��������ҵ�˳����ã��ڵ�ǰ���ϵĿռ䲻��ʱ���е���һ�С�
    2������ģ��
        ���磬TextBox �������Ƿ���� Text ���Ե�һ���ַ���ֵ�����ǣ������ؼ����԰�����ͬ�������͵Ķ���Button �����ݣ��� Content ����ָ�������԰���������������ֿؼ����ı���ͼ�����״��
    3���ؼ�ģ��
        ControlTemplate ���Ŀؼ����û��������ۣ��������������ݺ���Ϊ��
    4������ģ��
        ʹ�ÿؼ�ģ�����ָ���ؼ�����ۣ���ʹ������ģ�������ָ���ؼ����ݵ���ۡ� ����ģ�徭�����ڸĽ������ݵ���ʾ��ʽ�� Ĭ���������� ListBox�������� ���ǣ�ÿ�������Ĭ����۽������������ơ� ��Ҫ��ʾ�������ơ����������ȼ�������ʹ�� ListBox ���� DataTemplate�ؼ����б����Ĭ����ۡ�ListBox �ᱣ������Ϊ��������ۣ�ֻ���б������ʾ���ݵ���۷����仯��
    5���Զ���ؼ�
        �û��ؼ�ģ��
            ������ UserControl ����һ�����������ؼ���ɡ�
        �ؼ�ģ��
            ������ Control������������ʹ��ģ�彫����Ϊ������۷ָ�������ʵ�֣��ǳ����ƴ���� WPF �ؼ��� ������ Control ʹ������Ը����ɵش����Զ����û����棨����û��ؼ���������������Ҫ���Ѹ��ྫ����
        ���Ԫ��ģ�͡�
            ����������Զ�������߼���������ģ�壩����ʱ���Զ���ؼ������� FrameworkElement ��

---

>## ���õ�WPF�ؼ�

---

    ��ť��
        Button �� RepeatButton��
    ������ʾ��
        DataGrid��ListView �� TreeView��
    ������ʾ��ѡ�
        Calendar �� DatePicker��
    �Ի���
        OpenFileDialog�� PrintDialog�� SaveFileDialog��
    ����ī����
        InkCanvas �� InkPresenter��
    �ĵ���
        DocumentViewer�� FlowDocumentPageViewer�� FlowDocumentReader�� FlowDocumentScrollViewer�� StickyNoteControl��
    ���룺
        TextBox�� RichTextBox�� PasswordBox��
    ���֣�
        Border�� BulletDecorator�� Canvas�� DockPanel�� Expander�� Grid�� GridView�� GridSplitter�� GroupBox�� Panel�� ResizeGrip�� Separator�� ScrollBar�� ScrollViewer�� StackPanel�� Thumb�� Viewbox�� VirtualizingStackPanel�� Window�� WrapPanel��
    ý�壺
        Image�� MediaElement�� SoundPlayerAction��
    �˵���
        ContextMenu�� Menu�� ToolBar��
    ������
        Frame�� Hyperlink�� Page�� NavigationWindow�� TabControl��
    ѡ�
        CheckBox�� ComboBox�� ListBox�� RadioButton�� Slider��
    �û���Ϣ��
        AccessText�� Label�� Popup�� ProgressBar�� StatusBar�� TextBlock�� ToolTip��

---

># �ؼ�����

---

    1.���ࣺ
    ����ContentControl��Control�����࣬ר��������ʾ���ݵģ��糣�õ�Label����ContentControl������
    2.���ԣ�
    ? ? ?Template ��Control���һ�����ԣ�
    ? ? ?ContentTemplate��ContentControl��һ�����ԣ�
    3.���ͣ�
    ? ? ?Control��Template������ControlTemplate���͵ģ�
    ? ? ?ContentControl��ContentTemplate������DataTemplate���͵ģ�
    4.��;��
    ? ? ControlTemplate������˼�壬�ǿ��ƿؼ���ۺͽṹ�ģ�һ�����ĳ���ؼ������ͣ���һ��Button��ʲô���ӣ�Buttton����һ���б��б������ʾͼƬ�ȣ�
    ? ? DataTemplate�����ǿ���һ���ؼ���������Ҫ��γ��ֵģ�һ����ڵ���ĳ�����ݵ����ͣ�(һ��������������Content���Ե�)������Ҫ��Ϊ�����͵����Ը�ֵ��
? ? ? ? �磺
? ? ? ? ? ?Label��Content���Ը�ֵ�󣬿�������Label��ContentTemplate��
? ? ? ? ? ?ItemsControl��ItemsSource���Ը�ֵ�󣬿����������ItemTemplate��
? ? ? ? ? ?HeaderItemsControl��Header���Ը�ֵ�󣬿����������HeaderTemplate��
    5.WPFģ����ļ̳й�ϵ
    ? ? 1��FrameworkTemplate?��������ControlTemplate(�����ؼ����)��ItemsPanelTemplate(�������ϵ�����)��DataTemplate(�������ݵĳ��ַ�ʽ)
        2��DateTemplate��������?HierarchicalDataTemplate(�������ģ�壬һ������TreeView��Menu)

---

># Style

---
    
    1��������ʽ������������� XAML �ļ��� Resources ����������Ϊ��Դ�� ������ʽ��һ����Դ���������ͬ�����������������Դ�ķ�Χ���� �����֮��������ʽ��λ�û�Ӱ����ʽ��Ӧ�÷�Χ�� ���磬�����Ӧ�ö��� XAML �ļ��ĸ�Ԫ����������ʽ�������ʽ������Ӧ���е��κ�λ��ʹ�á����Խ� Style ��Ϊһ�ֽ�һ������ֵӦ�õ�һ������Ԫ�صı��������� 

---

># ControlTemplate

---
    
    1������ControlTemplate ������������� XAML �ļ��� Resources ����������Ϊ��Դ�� ģ������Դ������������������������Դ����ͬ��Χ���� ����֮������ģ���λ�û�Ӱ��ģ���Ӧ�÷�Χ�� ���磬�����Ӧ�ó����� XAML �ļ��ĸ�Ԫ��������ģ�壬���ģ�������Ӧ�ó����е��κ�λ��ʹ�á� ����ڴ����ж���ģ�壬����ô����еĿؼ�����ʹ�ø�ģ�塣
    2��TemplateBinding
        �����µ� ControlTemplate ʱ��������Ȼ��Ҫʹ�ù������Ը��Ŀؼ���ۡ� TemplateBinding �����չ�� ControlTemplate ��Ԫ�ص����԰󶨵��ɿؼ�����Ĺ������ԡ� 
    3��ContentPresenter
    4��������
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
    5��VisualState
        Normal	CommonStates	Ĭ��״̬��
        MouseOver	CommonStates	���ָ����ͣ�ڿؼ��Ϸ���
        Pressed	CommonStates	�Ѱ��¿ؼ���
        Disabled	CommonStates	�ѽ��ÿؼ���
        Focused	FocusStates	�ؼ��н��㡣
        Unfocused	FocusStates	�ؼ�û�н���
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

># ���ݰ�

---
    1��ʹ�� Binding �������󶨣���ÿ����ͨ�������ĸ��������Ŀ�ꡢĿ�����ԡ���Դ�Լ�ָ��Ҫʹ�õ�Դֵ��·���� 
    1��Binding.Mode �󶨷�ʽ���������˫��֮���
    2��UpdateSourceTrigger
        PropertyChanged
        LostFocus
        Explicit Ӧ�õ���UpdateSourceʱ
    3����Դ
        1��Binding.Source
            Source={StaticResource myDataSource}
        2��Binding.ElementName 
        3��Binding.RelativeSource 
    4������ת��
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
    5������ObservableCollection<T> 
    6��ö�ٿ���������
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

># ����

---
    
    1��Style
        ������ʽ������������� XAML �ļ��� Resources ����������Ϊ��Դ�� ������ʽ��һ����Դ���������ͬ�����������������Դ�ķ�Χ���� �����֮��������ʽ��λ�û�Ӱ����ʽ��Ӧ�÷�Χ�� ���磬�����Ӧ�ö��� XAML �ļ��ĸ�Ԫ����������ʽ�������ʽ������Ӧ���е��κ�λ��ʹ�á����Խ� Style ��Ϊһ�ֽ�һ������ֵӦ�õ�һ������Ԫ�صı���������
    2�������¼�
        ·���¼��� CLR �¼�֮���һ����Ҫ�����ǣ�·���¼�����Ԫ���������Ҵ�����򣬶� CLR �¼�������Ԫ�������������ֻ�ܸ��ӵ������¼���Դ���� ��ˣ�·���¼� sender ������Ԫ�����е��κ��ѱ�����Ԫ�ء�
        �����¼��������ڷ�Ԫ�����ж����µ�·���¼����������е��κ�Ԫ�����������¼��� Ϊ�ˣ����뽫�����¼�ע��Ϊ·���¼������ṩ֧�ָ����¼����ܵ��ض�֧�ִ��롣 ���ڸ����¼�ע��Ϊ·���¼��������Ԫ��������ʱ�����ǻ�ͨ��Ԫ����������
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
    3���������� ��������
        �������ԺͶ���һ�����������һ��ûʲô����ֻ����RegisterAttached����������Register�������ˡ�

---