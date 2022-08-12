# ���ú���

    parseInt("123", 10); 
    parseFloat()
    isNaN(NaN);  // is Not a Number
    "hello".charAt(0); // "h"
    "hello, world".replace("world", "mars"); // "hello, mars"
    "hello".toUpperCase(); // "HELLO"
    for (let currentValue of a) {// Do something with currentValue}
    for (let i in a) {// ���� a[i]}

# ע���

    1��false��0�����ַ�����""����NaN��null �� undefined ��ת��Ϊ false,��������ֵ��ת��Ϊ true.

    2��JavaScript �е� null ��ʾһ����ֵ��non-value��������ʹ�� null �ؼ��ֲ��ܷ��ʣ�undefined ��һ����undefined��δ���壩�����͵Ķ��󣬱�ʾһ��δ��ʼ����ֵ��Ҳ���ǻ�û�б������ֵ.

    3����ȵıȽ���΢����һЩ����������=���Ⱥţ�����ɵ�������������������Ӧ�Ĺ���.
    ����ڱȽ�ǰ����Ҫ�Զ�����ת����Ӧ��ʹ����������=���Ⱥţ�����ɵ���������.
    123 == "123" // true
    1 == true; // true
    1 === true; //false
    123 === "123"; // false

    4������ʵ�����Ƿ����˺�������һ����Ϊ arguments ���ڲ���������������ͬһ������������Ķ���һ�������������б�����Ĳ�����
    function add() {
        var sum = 0;
        for (var i = 0, j = arguments.length; i < j; i++) {
            sum += arguments[i];
        }
        return sum;
    }
    add(2, 3, 4, 5); // 14

    5���ɱ����
    function avg(...args) {
        var sum = 0;
        for (let value of args) {
            sum += value;
        }
        return sum / args.length;
    }
    avg(2, 3, 4, 5); // 3.5

    6�����������3�ַ�ʽ
    ��1�֣�
    function makePerson(first, last) {
        return {
            first: first,
            last: last,
            fullName: function() {
                return this.first + ' ' + this.last;
            },
            fullNameReversed: function() {
                return this.last + ', ' + this.first;
            }
        }
    }
    s = makePerson("Simon", "Willison");
    s.fullName(); // "Simon Willison"
    s.fullNameReversed(); // Willison, Simon
    ��2�֣���������������һ���ؼ��֣�new������ this ������ء����������Ǵ���һ��ո�µĿն���Ȼ��ʹ��ָ���Ǹ������ this �����ض��ĺ�����ע�⣬���� this ���ض��������᷵���κ�ֵ��ֻ���޸� this ������new �ؼ��ֽ����ɵ� this ���󷵻ظ����÷������� new ���õĺ�����Ϊ���캯����ϰ�ߵ������ǽ���Щ����������ĸ��д�������� new �������ǵ�ʱ�������ʶ���ˡ�
    function Person(first, last) {
        this.first = first;
        this.last = last;
        this.fullName = function() {
            return this.first + ' ' + this.last;
        }
        this.fullNameReversed = function() {
            return this.last + ', ' + this.first;
        }
    }
    var s = new Person("Simon", "Willison");
    ��3��(���������ŵģ�����������)��
    function Person(first, last) {
        this.first = first;
        this.last = last;
    }
    Person.prototype.fullName = function() {
        return this.first + ' ' + this.last;
    }
    Person.prototype.fullNameReversed = function() {
        return this.last + ', ' + this.first;
    }

    7��Person.prototype ��һ�����Ա�Person������ʵ������Ķ�������һ������ԭ������prototype chain���Ĳ�ѯ����һ���֣�������ͼ���� Person ĳ��ʵ���������ϸ������е� s��һ��û�ж��������ʱ�������������ȼ����� Person.prototype ���ж��Ƿ��������һ�����ԡ����ԣ��κη���� Person.prototype �Ķ�����ͨ�� this �������ʵ�����ǿ��õġ�������Թ���ʮ��ǿ��JavaScript �������ڳ����е��κ�ʱ���޸�ԭ�ͣ�prototype���е�һЩ������Ҳ����˵�����������ʱ (runtime) ���Ѵ��ڵĶ�����Ӷ���ķ�����
    s = new Person("Simon", "Willison");
    s.firstNameCaps();  // TypeError on line 1: s.firstNameCaps is not a function
    Person.prototype.firstNameCaps = function() {
        return this.first.toUpperCase()
    }
    s.firstNameCaps(); // SIMON

    8���հ�
    function makeAdder(a) {
        return function(b) {
            return a + b;
        }
    }
    var add5 = makeAdder(5);// ������a+b���������������5���ֵ������a
    var add20 = makeAdder(20);
    add5(6); // �������ڲ���a+b�����������������6���ֵ������b������11
    add20(7); // 27
    ������ makeAdder ʱ��������������һ�����������������һ�����ԣ�a��������Ա������������� makeAdder ������Ȼ�� makeAdder ����һ���´����ĺ������ݼ�Ϊ adder����ͨ����JavaScript ������������������ʱ���� makeAdder ����������������ݼ�Ϊ b�������ǣ�makeAdder �ķ���ֵ���º��� adder��ӵ��һ��ָ����������� b �����á����գ���������� b ���ᱻ�������������գ�ֱ��û���κ�����ָ���º��� adder��
    һ���հ������� һ������ ���� ������ʱ�����е���������� ����ϡ��հ������㱣��״̬�������ԣ����ǿ��������������