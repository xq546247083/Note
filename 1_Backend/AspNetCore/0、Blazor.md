# Blazor

>## ���

---

    1�������ʹ�ã�
        <div class="chat-message">
            <span class="author">@Msg</span>
        </div>
        @code {
            [Parameter]
            public string? Msg { get; set; }
        }

        <Info Msg="��ʾ��Ϣ"></Info>
    2��֧�ֲַ���
        public partial class CounterPartialClass
    3��֧�ֻ���
        @inherits BlazorRocksBase
    4���������������൱��wpf�еĿؼ����������Լ����wpf�еĸ������ԣ�������˫��󶨡���
        [Parameter]
        public string Title { get; set;} = "Set By Child";
    5��RenderFragment
        1���򵥵�ʹ�ã�
            // ʹ��UI
            @RenderWelcomeInfo

            // ����UI
            private RenderFragment RenderWelcomeInfo = @<p>Welcome to your new app!</p>;
        2��ֱ��ʹ�ã�
            <div class="chat">
                @foreach (var message in messages)
                {
                    @ChatMessageDisplay(message)
                }
            </div>
            @code {
                private RenderFragment<ChatMessage> ChatMessageDisplay = message =>
                    @<div class="chat-message">
                        <span class="author">@message.Author</span>
                        <span class="text">@message.Text</span>
                    </div>;
            }
        3��Լ��ChildContentΪ�ؼ�������ݡ�
            <div class="card w-25" style="margin-bottom:15px">
                <div class="card-header font-weight-bold">Child content</div>
                <div class="card-body">@ChildContent</div>
            </div>
            @code {
                [Parameter]
                public RenderFragment? ChildContent { get; set; }
            }

            <RenderFragmentChild>
                Content of the child component is supplied
                by the parent component.
            </RenderFragmentChild>
    6��������ã��������֮��ķ����໥���ã�
        // �����
        <p>
            <code>value</code>: @value
        </p>
        @code {
            private int value;
            public void ChildMethod(int value)
            {
                this.value = value;
                StateHasChanged();
            }
        }

        // �����
        @page "/reference-parent"
        <div>
            <button @onclick="CallChildMethod">
                Call <code>ReferenceChild.ChildMethod</code> (second instance) 
                with an argument of 5
            </button>
            <ReferenceChild @ref="childComponent2" />
        </div>
        @code {
            private ReferenceChild? childComponent2;
            private void CallChildMethod() => childComponent2!.ChildMethod(5);
        }
    7��MarkupString
        ��Ҫ����ԭʼ HTML���뽫 HTML ���ݰ�װ�� MarkupString ֵ�С� ����ֵ����Ϊ HTML �� SVG�������뵽 DOM �С�
    8��֧�ַ���
        @typeparam TEntity where TEntity : IEntity
    9����������������ⲿ�¼������ʱ��������֪ͨ�����и��£���ʹ�� InvokeAsync ��������������ִ�е��ȵ� Blazor ��ͬ�������ġ�
        protected override void OnInitialized()
        {
            AutoIncrementCount();
            base.OnInitialized();
        }
        private  void AutoIncrementCount() 
        {
            Task.Run(async () => 
            {
                while (true) 
                {
                    await this.InvokeAsync(() =>
                    {
                        currentCount++;
                        StateHasChanged();
                    });
                    await Task.Delay(1000);
                }
            });
        }
    10��@key
        �Ż���Ԫ�ء��б�ȵı��֣�foreach�ȡ�
    11����̨�����ǰ�������������ԡ����ǳ����ã�
        <input id="useAttributesDict"
            @attributes="InputAttributes" />
        @code {
            [Parameter(CaptureUnmatchedValues = true)]
            private Dictionary<string, object> InputAttributes { get; set; } =
                new()
                {
                    { "maxlength", "10" },
                    { "size", "50" }
                };
        }
    12���������
        1����������������̳�LayoutComponentBase��ʹ��@Body��Ⱦҳ�档
            @inherits LayoutComponentBase
            @Body
        2��ҳ��ʹ�ò������
            @layout DoctorWhoLayout

---