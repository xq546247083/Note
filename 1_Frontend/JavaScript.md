# JS 学习笔记（深度通俗完整版）

# 一、变量、类型与判断

## 1、变量声明（const / let / var）
- `const`：默认优先使用。声明必须初始化，值不可重新赋值（但对象内部属性可以修改）。
- `let`：仅在变量值需要被重新赋予新值时使用（如循环计数器、累加值）。
- `var`：彻底淘汰（因为没有块级作用域且存在变量提升，容易造成全局污染和变量覆盖 Bug）。

## 2、数据类型与底层本质
1、基本数据类型（栈内存存储，按值传递）
- `string`、`number`、`boolean`、`null`、`undefined`、`symbol`、`bigint`
- `null` 与 `undefined` 的通俗区别：
  - `null`：**“有意识地设置为空”**（如 `user = null` 表示当前没有用户）。
  - `undefined`：**“压根还没被定义/未赋值”**（如声明了变量未给值，或访问了对象不存在的属性）。

2、引用数据类型（堆内存存储，按指针引用传递）
- `Object`（包括 Array、Function、Date、Map、Set）

3、精准类型判断
```js
// 1、typeof：适合判断基础类型和函数
typeof "abc"        // "string"
typeof 123          // "number"
typeof (() => {})   // "function"
typeof null         // "object"（历史遗留缺陷）

// 2、Array.isArray()：专门判断数组
Array.isArray([1, 2]) // true

// 3、终极通用精准判断
Object.prototype.toString.call(val) // "[object Null]", "[object Array]", "[object Object]"
```

## 3、真假值（Falsy 值规则）
在 `if (...)` 条件判断中，**只有以下 6 种情况会被判定为 false**，其余所有值（包括 `{}`、`[]`、`"0"`）一律为 true：
- `false`、`0`、`""`（空字符串）、`null`、`undefined`、`NaN`

## 4、比较运算符（=== vs ==）
- `===`（严格相等）：同时比较类型和值，推荐 100% 场景使用。
- `==`（宽松相等）：会尝试自动进行类型隐式转换（如 `123 == "123"` 为 true，`1 == true` 为 true），极易产生不可预期的 Bug，禁止使用。

---

# 二、现代高频语法与运算符

## 1、解构赋值（Destructuring）
- 从对象或数组中快速提取属性到变量：
```js
// 对象解构（支持重命名和默认值）
const user = { name: "Tom", age: 18 };
const { name: userName, age, role = "user" } = user;

// 数组解构
const [first, second, ...rest] = [1, 2, 3, 4, 5];
```

## 2、展开与剩余运算符（...）
```js
// 1、对象与数组浅拷贝与合并
const newObj = { ...obj1, ...obj2, active: true };
const newList = [...list1, ...list2];

// 2、可变参数（替代废弃的 arguments 对象）
function sum(...args) {
    return args.reduce((acc, cur) => acc + cur, 0);
}
```

## 3、可选链与空值合并（超高频防御性语法）
```js
// 1、可选链 (?.)：安全深层取值，遇到 null/undefined 立即短路返回 undefined，绝不报错
const street = user?.address?.street;
const res = obj?.doSomething?.();

// 2、空值合并 (??)：只有左侧是 null 或 undefined 时才取默认值（区别于 ||，会正确保留 0 和 ""）
const timeout = config.timeout ?? 3000;
```

---

# 三、常用内置对象与高频方法

## 1、数组（Array）核心高频方法
```js
const list = [1, 2, 3, 4, 5];

// 1、转换与汇总
list.map(x => x * 2);             // [2, 4, 6, 8, 10]（映射新数组，不改原数组）
list.filter(x => x > 2);           // [3, 4, 5]（条件过滤）
list.reduce((acc, cur) => acc + cur, 0); // 15（累加/汇总计算）

// 2、查找与判断
list.find(x => x > 3);             // 4（返回第一个满足条件的元素）
list.findIndex(x => x > 3);        // 3（返回第一个满足条件的下标）
list.some(x => x > 4);             // true（是否存在一项满足）
list.every(x => x > 0);            // true（是否全部满足）
list.includes(3);                  // true（是否包含该值）

// 3、快速去重
const unique = [...new Set([1, 2, 2, 3, 1])]; // [1, 2, 3]
```

## 2、对象操作与原生深拷贝
```js
Object.keys(obj);                  // 获取所有键名数组 ["name", "age"]
Object.values(obj);                // 获取所有键值数组 ["Tom", 18]
Object.entries(obj);               // 获取键值对二维数组 [["name", "Tom"], ["age", 18]]

// 现代原生深拷贝（推荐，无需引入 lodash）
const copy = structuredClone(originalObj);
```

---

# 四、函数、This 指向与闭包（深度解析）

## 1、`this` 指向与绑定机制
`this` 的指向取决于 **函数是以何种方式被调用的**：
1. **默认绑定**：独立函数调用（如 `foo()`），非严格模式指向 `window`，严格模式指向 `undefined`。
2. **隐式绑定**：通过对象调用（如 `obj.foo()`），`this` 指向该对象 `obj`。
3. **显式绑定**：通过 `fn.call(context)`、`fn.apply(context)` 或 `fn.bind(context)` 强行指定 `this`。
4. **new 绑定**：`new Foo()` 时，`this` 指向新创建出来的空实例对象。
5. **箭头函数（最特殊）**：箭头函数**压根没有自己的 this**，它的 `this` 永远借用定义它时外层作用域的 `this`，且不可通过 `bind/call` 改变。

## 2、闭包（Closure）通俗原理与实战
1、什么是闭包？（通俗大白话）
- **比喻**：正常情况下，函数执行完后内部变量就会被垃圾回收器（GC）彻底清空（像打扫房间）；但如果函数返回了一个内部子函数，而子函数还惦记着外层函数的变量，子函数就像背着一个**“随身背包”**，把外层变量打包带走了。
- **底层原理**：由于返回的子函数内部持有着对外部作用域对象（Scope Object）的引用，导致该作用域无法被垃圾回收，状态得以一直驻留在内存中。

2、闭包有什么用？
- **数据私有化与状态持久保存**（React 的 `useState` 就是利用闭包在每次组件重新渲染时记住状态）。
- **实战：防抖（Debounce）与节流（Throttle）**：
```js
// 1、防抖：事件停止触发 n 毫秒后才执行（典型场景：输入框搜索联想）
function debounce(fn, delay = 300) {
    let timer = null; // 闭包常驻变量
    return function (...args) {
        if (timer) clearTimeout(timer);
        timer = setTimeout(() => fn.apply(this, args), delay);
    };
}

// 2、节流：高频触发时，每隔固定时间只执行一次（典型场景：页面滚动监听、窗口 resize）
function throttle(fn, interval = 300) {
    let lastTime = 0; // 闭包常驻变量
    return function (...args) {
        const now = Date.now();
        if (now - lastTime >= interval) {
            lastTime = now;
            fn.apply(this, args);
        }
    };
}
```

---

# 五、原型、原型链与类（面向对象）

## 1、原型链（Prototype Chain）通俗解析
1. **什么是原型？**
   - 每个构造函数都有一个 `prototype` 属性（公共仓库）；
   - 每个实例对象都有一个隐式属性 `__proto__`，直接指向构造函数的 `prototype` 公共仓库。
2. **什么是原型链？**
   - 当你访问 `obj.foo` 时：先在 `obj` 自身找 ➡️ 找不到就顺着 `__proto__` 去它的原型公共仓库找 ➡️ 还找不到就去原型的原型找 ➡️ 一直到顶端 `Object.prototype` 还是没有，才返回 `undefined`。
   - 这条由 `__proto__` 串起来的查找链路就叫**原型链**。

## 2、ES6 Class（原型的现代语法糖）
现代开发统一使用 `class` 语法，底层依然基于原型链运行：
```js
class Person {
    constructor(name) {
        this.name = name;
    }
    sayHello() {
        return `Hello, ${this.name}`; // 挂在 Person.prototype 上，所有实例共享
    }
}

class Student extends Person {
    constructor(name, grade) {
        super(name); // 必须先调用父类构造函数
        this.grade = grade;
    }
}
```

---

# 六、异步编程底层原理与事件循环（深度核心）

## 1、为什么单线程的 JS 能做异步？（幕后功臣）
1. **为什么 JS 必须是单线程？**
   - 因为如果两个线程同时操作 DOM（一个在删除 DOM，一个在修改 DOM），浏览器就会陷入死锁和混乱。所以 **JS 代码执行线程只有一个（主线程）**。
2. **单线程为什么发网络请求不会卡死界面？**
   - **幕后功臣是宿主环境（浏览器 / Node.js）的多线程协作**：
   - 当你发起一个网络请求（如 `fetch`）或定时器（`setTimeout`）时：
     1. JS 主线程只负责**“发号施令”**，把下载任务转交给浏览器的 **网络线程**，主线程立刻继续往下执行同步代码，绝不阻塞；
     2. 浏览器的网络线程在后台默默下载数据；
     3. 下载完成后，网络线程将对应的**回调函数（Callback）打包扔进“任务队列（Task Queue）”**；
     4. JS 主线程把手头的同步代码全部执行完毕、空闲下来后，才会去任务队列里把回调拿出来执行。

## 2、Promise 的底层状态机与链式调用原理
1. **Promise 本质是一个状态机**：
   - 内部维护三种不可逆状态：`pending`（进行中） ➡️ 只能单向变成 `fulfilled`（成功）或 `rejected`（失败）。
   - 内部维护两个回调数组：`onFulfilledCallbacks` 和 `onRejectedCallbacks`。
2. **为什么 `.then()` 可以无限链式调用？**
   - **核心原理**：每一个 `.then()` 方法执行后，**都会返回一个全新的 Promise 实例**，而不是返回原本的那个 Promise！
   - 如果上一个 `.then()` 返回了一个值，新 Promise 会立即以该值为参数 resolve；如果返回了一个新的 Promise，新 Promise 会等待该 Promise 决议后再触发下一步。

```js
// 常用 Promise 组合方法
Promise.all([p1, p2])        // 全部成功才算成功，只要有一个失败就立刻报失败
Promise.allSettled([p1, p2]) // 等待所有请求都结束（无论成功或失败），返回包含每个状态的结果数组（最稳妥）
Promise.race([p1, p2])       // 竞速，返回最先完成的一个（无论成败）
```

## 3、async / await 底层原理（Generator 协程语法糖）
`async / await` 并不是黑魔法，**它的底层本质是：Promise + Generator（生成器协程）+ 自动执行器**。

- **执行暂停与恢复机制**：
  1. 当函数执行到 `await promise` 时，JS 引擎会暂停（挂起）当前 async 函数的执行，并**让出主线程的执行权**去跑外面的其他代码；
  2. 当 `await` 后面的 Promise 完成（resolve）后，自动执行器会通过微任务将结果注入回当前断点，**唤醒并恢复该 async 函数继续往下跑**。
- 这就是为什么能用同步的书写方式表达异步流程：
```js
async function getUserInfo() {
    try {
        const res = await request.get("/api/user");
        return res.data;
    } catch (err) {
        console.error("请求失败:", err); // 统一使用 try...catch 捕获异常
    }
}
```

## 4、事件循环（Event Loop）微任务与宏任务时序铁律
在事件循环中，任务被分为两类优先级不同的队列：
- **微任务（Microtask - 高优先级）**：`Promise.then / catch / finally`、`queueMicrotask`、`process.nextTick (Node)`
- **宏任务（Macrotask - 低优先级）**：`script 整体代码`、`setTimeout`、`setInterval`、`I/O`、`UI 渲染`

### 执行流程时钟图：
```text
【当前调用栈执行同步代码】
         ⬇
【同步代码执行完毕，检查微任务队列】
         ⬇
【一次性清空当前微任务队列里的全部微任务】（若微任务中又产生微任务，继续清空）
         ⬇
【微任务彻底清空 ➡️ 浏览器执行 UI 渲染（如有）】
         ⬇
【从宏任务队列中取出 一个 宏任务执行】
         ⬇
【该宏任务执行完毕 ➡️ 回到上面，再次清空所有微任务……如此死循环】
```

> **核心口诀**：**“微任务插队，宏任务排队；微任务每次清空，宏任务每次取一。”**

---

# 七、DOM 操作与事件机制（网页交互核心）

## 1、事件流三阶段
一个事件被触发时的传播路径：**事件捕获（从最外层 html 往内传播） ➡️ 目标阶段（到达点击的元素） ➡️ 事件冒泡（从内往外向父级冒泡传播）**。

## 2、事件委托（Event Delegation，性能优化必备）
- **原理**：利用“事件冒泡”，不需要给 1000 个列表项每个都绑事件，只需要在它们的父容器上绑一个监听器，通过 `e.target` 识别具体点击了谁：
```js
document.getElementById("list").addEventListener("click", (e) => {
    if (e.target.tagName === "LI") {
        console.log("点击了列表项:", e.target.innerText);
    }
});
```

## 3、常用事件控制方法
- `e.preventDefault()`：阻止默认行为（如阻止 `<a>` 标签跳转、阻止表单默认 submit 刷新页面）。
- `e.stopPropagation()`：阻止事件向父级冒泡。

---

# 八、网络通信与流式响应（Fetch API & Stream）

## 1、现代原生 Fetch 请求
```js
async function postData(url = "", data = {}) {
    const response = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    });
    return response.json(); // 解析 JSON
}
```

## 2、流式响应（SSE / Stream - AI 打字机效果的核心）
大模型流式输出（如 ChatGPT / DeepSeek 逐字打印）的底层 JS 读取机制：
```js
const response = await fetch("/api/chat/stream");
const reader = response.body.getReader();
const decoder = new TextDecoder();

while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    const textChunk = decoder.decode(value);
    console.log("收到流式片段:", textChunk);
}
```

---

# 九、浏览器本地存储对比

| 存储方式 | 存储容量 | 生命周期 | 作用域 | 是否随 HTTP 自动发送 | 常见用途 |
| :-- | :-- | :-- | :-- | :-- | :-- |
| **localStorage** | ~5MB | 永久有效（除非手动清除） | 同源所有标签页共享 | 否 | 存储 Token、用户配置、主题 |
| **sessionStorage** | ~5MB | 当前标签页关闭即销毁 | 仅当前标签页有效 | 否 | 存储临时表单数据、单页面步骤 |
| **Cookie** | ~4KB | 可设过期时间 | 同源共享 | **是（每次请求自动携带）** | 身份认证 SessionId（配合 HttpOnly） |
| **IndexedDB** | 百 MB 以上 | 永久有效 | 同源共享 | 否 | 离线大文件、大型本地结构化数据 |

---

# 十、垃圾回收（GC）与常见内存泄漏排查

## 1、垃圾回收机制（标记清除法 Mark-and-Sweep）
- 引擎从“根对象（如 window、全局变量、当前调用栈）”开始遍历，凡是能够被引用的对象都被打上标记（存活）；
- 遍历结束后，所有无法从根对象访问到的“孤岛对象”会被回收清除。

## 2、日常开发三大常见内存泄漏元凶（必防）
1. **未清理的定时器**：组件销毁时没有调用 `clearTimeout` / `clearInterval`，导致定时器内部回调引用的变量无法释放。
2. **未解绑的全局事件监听**：在 `window` 或 `document` 上 `addEventListener`，页面销毁时忘记 `removeEventListener`。
3. **脱离 DOM 的引用**：JS 变量保留了对某个被页面移除的 DOM 元素的引用，导致整个 DOM 子树无法被 GC 回收。