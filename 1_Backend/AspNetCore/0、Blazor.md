# Blazor

>## 组件

---

    1、组件的使用：
        <div class="chat-message">
            <span class="author">@Msg</span>
        </div>
        @code {
            [Parameter]
            public string? Msg { get; set; }
        }

        <Info Msg="显示消息"></Info>
    2、支持分部类
        public partial class CounterPartialClass
    3、支持基类
        @inherits BlazorRocksBase
    4、组件参数（组件相当于wpf中的控件，组件参数约等于wpf中的附加属性，而且是双向绑定。）
        [Parameter]
        public string Title { get; set;} = "Set By Child";
    5、RenderFragment
        1、简单的使用：
            // 使用UI
            @RenderWelcomeInfo

            // 定义UI
            private RenderFragment RenderWelcomeInfo = @<p>Welcome to your new app!</p>;
        2、直接使用：
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
        3、约定ChildContent为控件里的内容。
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
    6、组件引用（用以组件之间的方法相互调用）
        // 子组件
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

        // 父组件
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
    7、MarkupString
        若要呈现原始 HTML，请将 HTML 内容包装在 MarkupString 值中。 将该值分析为 HTML 或 SVG，并插入到 DOM 中。
    8、支持泛型
        @typeparam TEntity where TEntity : IEntity
    9、如果组件必须根据外部事件（如计时器或其他通知）进行更新，请使用 InvokeAsync 方法，它将代码执行调度到 Blazor 的同步上下文。
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
    10、@key
        优化多元素、列表等的表现，foreach等。
    11、后台代码给前端设置任意属性。（非常有用）
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
    12、布局组件
        1、创建布局组件，继承LayoutComponentBase，使用@Body渲染页面。
            @inherits LayoutComponentBase
            @Body
        2、页面使用布局组件
            @layout DoctorWhoLayout

---