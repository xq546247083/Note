# 常用函数

    parseInt("123", 10); 
    parseFloat()
    isNaN(NaN);  // is Not a Number
    "hello".charAt(0); // "h"
    "hello, world".replace("world", "mars"); // "hello, mars"
    "hello".toUpperCase(); // "HELLO"
    for (let currentValue of a) {// Do something with currentValue}
    for (let i in a) {// 操作 a[i]}

# 注意点

    1、false、0、空字符串（""）、NaN、null 和 undefined 被转换为 false,所有其他值被转换为 true.

    2、JavaScript 中的 null 表示一个空值（non-value），必须使用 null 关键字才能访问，undefined 是一个“undefined（未定义）”类型的对象，表示一个未初始化的值，也就是还没有被分配的值.

    3、相等的比较稍微复杂一些。由两个“=（等号）”组成的相等运算符有类型自适应的功能.
    如果在比较前不需要自动类型转换，应该使用由三个“=（等号）”组成的相等运算符.
    123 == "123" // true
    1 == true; // true
    1 === true; //false
    123 === "123"; // false

    4、函数实际上是访问了函数体中一个名为 arguments 的内部对象，这个对象就如同一个类似于数组的对象一样，包括了所有被传入的参数。
    function add() {
        var sum = 0;
        for (var i = 0, j = arguments.length; i < j; i++) {
            sum += arguments[i];
        }
        return sum;
    }
    add(2, 3, 4, 5); // 14

    5、可变参数
    function avg(...args) {
        var sum = 0;
        for (let value of args) {
            sum += value;
        }
        return sum / args.length;
    }
    avg(2, 3, 4, 5); // 3.5

    6、构建对象的3种方式
    第1种：
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
    第2种：我们引入了另外一个关键字：new，它和 this 密切相关。它的作用是创建一个崭新的空对象，然后使用指向那个对象的 this 调用特定的函数。注意，含有 this 的特定函数不会返回任何值，只会修改 this 对象本身。new 关键字将生成的 this 对象返回给调用方，而被 new 调用的函数称为构造函数。习惯的做法是将这些函数的首字母大写，这样用 new 调用他们的时候就容易识别了。
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
    第3种(这种是最优的，函数被复用)：
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

    7、Person.prototype 是一个可以被Person的所有实例共享的对象。它是一个名叫原型链（prototype chain）的查询链的一部分：当你试图访问 Person 某个实例（例如上个例子中的 s）一个没有定义的属性时，解释器会首先检查这个 Person.prototype 来判断是否存在这样一个属性。所以，任何分配给 Person.prototype 的东西对通过 this 对象构造的实例都是可用的。这个特性功能十分强大，JavaScript 允许你在程序中的任何时候修改原型（prototype）中的一些东西，也就是说你可以在运行时 (runtime) 给已存在的对象添加额外的方法：
    s = new Person("Simon", "Willison");
    s.firstNameCaps();  // TypeError on line 1: s.firstNameCaps is not a function
    Person.prototype.firstNameCaps = function() {
        return this.first.toUpperCase()
    }
    s.firstNameCaps(); // SIMON

    8、闭包
    function makeAdder(a) {
        return function(b) {
            return a + b;
        }
    }
    var add5 = makeAdder(5);// 返回了a+b这个函数，并传入5这个值到参数a
    var add20 = makeAdder(20);
    add5(6); // 调用了内部的a+b这个函数，并传入了6这个值到参数b，返回11
    add20(7); // 27
    当调用 makeAdder 时，解释器创建了一个作用域对象，它带有一个属性：a，这个属性被当作参数传入 makeAdder 函数。然后 makeAdder 返回一个新创建的函数（暂记为 adder）。通常，JavaScript 的垃圾回收器会在这时回收 makeAdder 创建的作用域对象（暂记为 b），但是，makeAdder 的返回值，新函数 adder，拥有一个指向作用域对象 b 的引用。最终，作用域对象 b 不会被垃圾回收器回收，直到没有任何引用指向新函数 adder。
    一个闭包，就是 一个函数 与其 被创建时所带有的作用域对象 的组合。闭包允许你保存状态——所以，它们可以用来代替对象。