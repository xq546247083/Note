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
        
---