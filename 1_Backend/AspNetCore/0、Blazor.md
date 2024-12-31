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
    13�����ҳ��֮�乲�����ݡ�CascadingValue�������Ҫ�����Ǽ������֮������ݴ��ݡ�
        // ע��
        builder.Services.AddCascadingValue(sp => new Dalek { Units = 123 });
        builder.Services.AddCascadingValue("AlphaGroup", sp => new Dalek { Units = 456 });

        // ʹ��
        <ul>
            <li>Dalek Units: @Dalek?.Units</li>
            <li>Alpha Group Dalek Units: @AlphaGroupDalek?.Units</li>
        </ul>
        @code {
            [CascadingParameter]
            public Dalek? Dalek { get; set; }

            [CascadingParameter(Name = "AlphaGroup")]
            public Dalek? AlphaGroupDalek { get; set; }
        }
    14���󶨹���
        1��@bind:ָ��Ҫ�󶨡����ĵ�ֵ��
        2��@bind:get��ָ��Ҫ�󶨵�ֵ��
        3��@bind:set��ָ��ֵ����ʱ�Ļص���
        4�������������,���������ǽ�������е����԰󶨵��丸����е����ԡ�
            <p>
                <label>
                    Decimal value (��0.000 format):<input @bind="DecimalValue" />
                </label>
            </p>
            @code {
                private decimal decimalValue = 1.1M;
                private NumberStyles style = NumberStyles.AllowDecimalPoint | NumberStyles.AllowLeadingSign;
                private CultureInfo culture = CultureInfo.CreateSpecificCulture("en-US");

                private string DecimalValue
                {
                    get => decimalValue.ToString("0.000", culture);
                    set
                    {
                        if (Decimal.TryParse(value, style, culture, out var number))
                        {
                            decimalValue = Math.Round(number, 3);
                        }
                    }
                }
            }
    15�����⻯�б�
        <div style="height:500px;overflow-y:scroll">
            <Virtualize Items="allFlights" Context="flight">
                <FlightSummary @key="flight.FlightId" Details="@flight.Summary" />
            </Virtualize>
        </div>
    16����̬�������������Ƕ�̬�ģ�ͨ��Typeָ����
        <DynamicComponent Type="componentType" Parameters="parameters" />
        @code {
            private Type componentType = ...;
            private IDictionary<string, object> parameters = ...;
        }
    17��QuickGrid
        ���ݱ��

---

>## ģ�����

---

    1������ģ�����
    TemplatedNavBar.razor:
    @typeparam TItem

    <nav class="navbar navbar-expand navbar-light bg-light">
        <div class="container justify-content-start">
            @StartContent
            <div class="navbar-nav">
                @foreach (var item in Items)
                {
                     <tr @key="@item">@ItemTemplate(item)</tr>
                }
            </div>
        </div>
    </nav>

    @code {
        [Parameter]
        public RenderFragment? StartContent { get; set; }

        [Parameter, EditorRequired]
        public RenderFragment<TItem> ItemTemplate { get; set; } = default!;

        [Parameter, EditorRequired]
        public IReadOnlyList<TItem> Items { get; set; } = default!;
    }

    2��ʹ��ģ�����
    Pets.razor:
    @page "/pets-1"

    <PageTitle>Pets 1</PageTitle>

    <h1>Pets Example 1</h1>

    <TemplatedNavBar Items="pets" Context="pet">
        <StartContent>
            <a href="/" class="navbar-brand">PetsApp</a>
        </StartContent>
        <ItemTemplate>
            <NavLink href="@($"/pet-detail/{pet.PetId}?ReturnUrl=%2Fpets-1")" class="nav-link">
                @pet.Name
            </NavLink>
        </ItemTemplate>
    </TemplatedNavBar>

    @code {
        private List<Pet> pets = new()
        {
            new Pet { PetId = 1, Name = "Mr. Bigglesworth" },
            new Pet { PetId = 2, Name = "Salem Saberhagen" },
            new Pet { PetId = 3, Name = "K-9" }
        };

        private class Pet
        {
            public int PetId { get; set; }
            public string? Name { get; set; }
        }
    }

---