# React 学习笔记

# 一、核心心法：React 到底是如何工作的？

## 1、声明式与组件化
- 页面由一个个独立的**函数组件（Function Component）**像积木一样拼装而成。
- **命名铁律**：React 组件函数名**必须以大写字母开头**（如 `function UserCard() {}`），小写字母开头的标签（如 `<div>`、`<button>`）会被 React 视为原生 HTML 标签。
- 视图由状态驱动：`UI = fn(State)`，你只管描述数据在某种状态下长什么样，React 负责自动对比 Virtual DOM 并高效更新真实 DOM。

## 2、Props vs State（核心界限）
| 概念 | 归属与控制权 | 可变性 | 用途 |
| :-- | :-- | :-- | :-- |
| **Props** | 外部传入（父组件传给子组件） | **只读不可变**（组件决不能修改自己的 props） | 组件通信、配置传递、插槽（children） |
| **State** | 组件内部私有状态 | 通过 Setter 函数修改 | 控制组件自身随交互变化的数据 |

## 3、保持组件纯粹（Pure Components 戒律）
- **核心原则**：相同输入（Props/State）必须永远返回相同的 JSX。
- **铁律**：**严禁在渲染过程中修改任何外部已存在的变量或对象**（如严禁在组件函数体内写 `globalCount++` 产生渲染副作用）。
- **严格模式（StrictMode）为什么执行 2 次？**：在开发环境下，React 会特意将组件渲染 2 次、将 Effect 执行 2 次，目的是帮助你及早揪出“不纯的渲染副作用”和“忘记清理的 Effect 内存泄漏”。

## 4、不可变数据原则（Immutable）与内存指针
- **为什么不能直接修改 State？（底层原理）**：
  - 在 JavaScript 中，对象和数组是引用类型（指针）；
  - React 检查状态是否变化时，为了极致性能，做的是**浅比较（`Object.is(oldState, newState)`，仅比对内存指针地址）**；
  - 如果直接写 `user.name = "Tom"` 或 `list.push(item)`，虽然内部属性变了，但内存指针地址没有改变，React 认为数据未变，从而跳过重新渲染；
  - 因此必须使用解构展开生成**具有新内存地址的全新副本**：
```jsx
setUser({ ...user, name: "Tom" }); // 更新对象（创建新对象指针）
setList([...list, newItem]);       // 更新数组（创建新数组指针）
```

## 5、State 如同一张快照（Snapshot 机制）
- **核心原理**：在一个渲染周期内，State 的值是被固定的快照常量！
- **经典陷阱**：
```jsx
const [count, setCount] = useState(0);
const handleClick = () => {
    setCount(count + 1);
    console.log(count); // 打印出来的依然是旧值 0！
};
```
- **解释**：`setCount` 是通知 React 在**下一次渲染**中使用新值，当前事件执行作用域里的 `count` 依然是当次渲染生成的常量快照 0。

## 6、渲染与提交三阶段（Render & Commit）
1. **触发（Trigger）**：组件初次挂载，或调用了 `setState` 触发更新；
2. **渲染（Render）**：React 调用你的组件函数，计算出最新的 Virtual DOM 虚拟描述树；
3. **提交（Commit）**：React 把虚拟 DOM 的差异变更高效应用到真实的浏览器 DOM 树上（仅在真实 DOM 发生变动时操作）。

## 7、组件重新渲染（Re-render）的 3 个触发时机
1. **自身的 State 发生改变**；
2. **父组件重新渲染了**（子组件默认也会被动重新执行，除非使用 `React.memo` 进行浅比较阻断）；
3. **消费的 Context 或全局 Store 发生了变化**。

---

# 二、JSX 语法三大铁律与表达式规则

## 1、JSX 书写三大铁律
1. **只能返回一个根标签**：多个同级标签必须用空标签 `<>...</>`（Fragment 片段）包裹，避免多余的 DOM 节点嵌套。
2. **所有标签必须显式闭合**：如 `<img />`、`<input />`、`<br />`。
3. **属性名采用驼峰（camelCase）命名**：
   - 样式类名使用 `className`（避免与 JS 关键字 `class` 冲突）；
   - 表单 label 关联使用 `htmlFor`（代替 `for`）；
   - 事件使用 `onClick`、`onChange` 等。

## 2、大括号 `{}` 嵌入 JavaScript 表达式
```jsx
// 1、变量与计算
<h1>{user.name.toUpperCase()}</h1>

// 2、双大括号 style={{ ... }} 的真相
// 外层大括号是 JSX 表达式语法，内层大括号是一个普通的 JS 对象字面量
<div style={{ backgroundColor: 'red', fontSize: 16 }}>提示</div>
```

---

# 三、组件通信全景（4 大核心方式）

## 1、父组件 ➡️ 子组件（Props 传参与插槽）
1. **普通属性传参（支持默认值与展开语法）**：
```jsx
// 子组件：支持默认值
function Avatar({ size = 100, name }) { ... }

// 父组件：支持批量展开传参
function Profile(props) {
    return <Avatar {...props} />; // 将 props 里的所有字段一次性透传
}
```
2. **`children` 插槽传递（嵌套组合）**：
```jsx
function Card({ title, children }) {
    return (
        <div className="card">
            <h3>{title}</h3>
            <div className="card-body">{children}</div>
        </div>
    );
}

// 父组件使用：像 HTML 标签一样自由嵌套内容
<Card title="用户信息">
    <p>用户名：Tom</p>
    <button>编辑</button>
</Card>
```

## 2、子组件 ➡️ 父组件（回调函数 Callback）
- **原理**：父组件向子组件传递一个函数，子组件在内部事件触发时调用该函数，并把数据作为参数回传给父组件：
```jsx
function SearchInput({ onSearch }) {
    const [keyword, setKeyword] = useState("");
    return <button onClick={() => onSearch(keyword)}>搜索</button>;
}

function UserListPage() {
    const handleSearch = (searchKey) => console.log("收到子组件关键词:", searchKey);
    return <SearchInput onSearch={handleSearch} />;
}
```

## 3、兄弟组件间通信（状态提升 State Lifting）
- **原理**：当两个兄弟组件需要共享数据时，**把该 State 提升到它们共同的最近父组件中维护**，父组件再分别通过 Props 分发给两个子组件。

## 4、跨层级与全局通信（Context 或 Zustand 全局状态）
- 简单场景使用 `createContext` + `useContext`；
- 企业级复杂业务状态（用户信息、权限、全局设置）统一使用 **Zustand**。

---

# 四、React 19 核心 Hooks（底层原理解析）

## 1、useState（定义组件状态与批处理机制）
- **自动批处理（Automatic Batching）**：
  在同一个事件处理函数中，无论写了多少个 `setState`（即使在 `setTimeout` 或 `Promise` 异步回调中），React 都会**自动合并为一次重新渲染**，绝不会因多次修改而刷新多次。
- **函数式更新（防并发/异步覆盖）**：
  如果新状态依赖于上一次状态，必须传入回调函数：
```jsx
const [count, setCount] = useState(0);

// 正确写法（放入更新队列串行计算，避免闭包旧值覆盖）
setCount(prev => prev + 1);
```

## 2、useReducer（复杂状态集中规约器）
- **底层运行原理**：
  - `useReducer` 是 `useState` 的底层基石；
  - 核心公式：`新 State = Reducer(旧 State, Action)`；
  - 它将 **“发出什么动作指令（Dispatch Action）”** 与 **“状态如何具体计算变更（Reducer 纯函数）”** 彻底解耦，使所有改动规则集中收敛在一处，避免多处分散修改导致状态不同步。
- **实战代码**：
```jsx
import { useReducer } from 'react';

// 1、定义状态修改规则（记账员）
function counterReducer(state, action) {
    switch (action.type) {
        case 'increment':
            return { count: state.count + 1 };
        case 'decrement':
            return { count: state.count - 1 };
        case 'reset':
            return { count: 0 };
        default:
            return state;
    }
}

// 2、组件内使用
function Counter() {
    const [state, dispatch] = useReducer(counterReducer, { count: 0 });

    return (
        <div>
            <p>当前数值：{state.count}</p>
            <button onClick={() => dispatch({ type: 'increment' })}>+1</button>
            <button onClick={() => dispatch({ type: 'decrement' })}>-1</button>
            <button onClick={() => dispatch({ type: 'reset' })}>重置</button>
        </div>
    );
}
```
- **选型建议**：简单独立变量用 `useState`（90% 场景）；多字段联动/复杂状态转换用 `useReducer`；跨页面全局共享用 `Zustand`。

## 3、useEffect（副作用调度与生命周期合一）
- **底层运行原理**：
  - 函数组件的函数体只负责 UI 纯计算；发网络请求、操作 DOM、启动定时器等行为属于“副作用”；
  - `useEffect` 的回调**不会在渲染过程中同步阻塞执行**，而是在**浏览器完成真实 DOM 绘制并上屏（Paint）之后**才异步调度执行，因此绝不卡顿首屏渲染；
  - **依赖项比对机制**：React 每次渲染后使用 `Object.is` 逐个比对 `[dep1, dep2]` 数组。全相同则跳过；有任意一项不同（或未传依赖项）则执行；
  - **清理机制（Cleanup）**：在下一次 Effect 回调执行前（或组件销毁卸载时），React 会自动调用上一次返回的清理函数（`return () => ...`），及时释放资源防内存泄漏。
```jsx
useEffect(() => {
    // 挂载或依赖更新后异步执行（发网络请求、启动定时器、全局事件监听）
    const timer = setInterval(() => console.log("tick"), 1000);

    // 清理函数（下次更新前或卸载时执行）
    return () => clearInterval(timer);
}, [dep]); // 依赖项：[] 仅挂载执行一次；[dep] 仅在 dep 变化时执行
```

## 4、useRef（DOM 引用与跨渲染常驻变量）
- **底层运行原理**：
  - `useRef(initialValue)` 本质上是在组件对应的 Fiber 节点上创建并挂载了一个普通的纯 JS 对象：`{ current: initialValue }`；
  - 在组件的整个生命周期内，React 保证每次渲染返回的都是**同一个内存对象引用**；
  - **为什么修改它不触发重新渲染？**：因为修改 `ref.current = 123` 仅仅是修改了一个普通对象的属性，没有调用 React 的状态调度器，React 不会触发组件重新渲染（适合保存定时器 ID、上一次的旧值等）；
  - **DOM 挂载原理**：当在 JSX 标签上写 `ref={inputRef}` 时，React 在真实 DOM 节点创建挂载后，会自动将真实 DOM 原生对象的引用赋值给 `inputRef.current`。
```jsx
const inputRef = useRef(null);
const handleFocus = () => inputRef.current.focus(); // 直接操作原生 DOM
<input ref={inputRef} />
```

## 5、useContext（跨层级发布-订阅数据消费）
- **底层运行原理**：
  - 基于**“发布-订阅（Pub/Sub）”**模式；
  - `<MyContext.Provider value={data}>` 作为数据的发布者；
  - 任何调用 `useContext(MyContext)` 的子孙组件，都会在 React 内部将自身注册为该 Context 的“消费者”；
  - 当 Provider 的 `value` 发生变化时，React 会精准定向通知所有注册的消费者组件触发重新渲染，中间层未消费该 Context 的父组件不受影响。
```jsx
const { theme } = useContext(ThemeContext);
```

## 6、自定义 Hook（Custom Hook - 逻辑抽象复用）
- **底层运行原理**：
  - 自定义 Hook **不是在组件之间共享 State 数据本身**，而是 **复用包含状态与副作用的代码逻辑片段**；
  - 凡是以 `use` 开头的函数都可以组合调用原生 Hook。每次在不同组件里调用自定义 Hook，都会在该组件自身的 Fiber 链表上独立创建专属于自己的 state 和 effect，彼此互不干扰：
```jsx
// 封装复用的窗口尺寸监听逻辑
function useWindowWidth() {
    const [width, setWidth] = useState(window.innerWidth);
    useEffect(() => {
        const handleResize = () => setWidth(window.innerWidth);
        window.addEventListener('resize', handleResize);
        return () => window.removeEventListener('resize', handleResize);
    }, []);
    return width;
}
```

---

# 五、状态设计与更新最佳实践（官方精髓）

## 1、State 结构设计的黄金法则
1. **不要把“可计算出来的派生值”存入 State**：
   - ❌ 错误：定义了 `firstName`、`lastName`，又定义了 `fullName` state（需手动同步，易出 bug）；
   - ✔️ 正确：直接在组件内计算 `const fullName = firstName + ' ' + lastName;`。
2. **避免重复与矛盾的状态**：
   - 不要同时定义 `isSending` 和 `isSent` 两个 bool 变量，推荐定义状态机字符串：`status: 'typing' | 'sending' | 'sent'`。
3. **避免深层嵌套对象**：尽量将 state 结构扁平化，便于不可变更新。

## 2、不可变数组更新操作速查表
| 目标操作 | ❌ 严禁使用的变异方法 | ✔️ 必须使用的不可变方法 |
| :-- | :-- | :-- |
| **添加元素** | `push`、`unshift` | `[...list, newItem]` 或 `[newItem, ...list]` |
| **删除元素** | `splice`、`pop`、`shift` | `list.filter(item => item.id !== targetId)` |
| **替换/修改** | `list[index] = xxx` | `list.map(item => item.id === targetId ? { ...item, done: true } : item)` |
| **排序/反转** | `list.sort()`、`list.reverse()` | `[...list].sort()` 或现代 `list.toSorted()`（克隆后排序） |

## 3、状态的保留与重置机制（Key 的妙用）
- **默认规则**：相同位置渲染相同组件，React 会**保留其内部 State**。
- **强制重置技巧**：给组件传递不同的 **`key`**，React 会强制销毁旧组件实例并重新挂载新组件，从而**瞬间一键重置其所有内部 State**：
```jsx
// 切换 userId 时，Profile 组件内部的所有表单草稿和状态会被完全干净地重置！
<Profile key={userId} userId={userId} />
```

## 4、你可能不需要 Effect（官方高频避坑指南）
- ❌ **不要用 `useEffect` 监听 props 变动去更新另一个 state** ➡️ 直接在渲染期间同步计算；
- ❌ **不要用 `useEffect` 处理用户交互操作（如购买成功弹提示）** ➡️ 直接在按钮的 `onClick` 事件处理函数中执行。

---

# 六、表单处理（受控组件 vs 非受控组件）

1. **受控组件（Controlled - 推荐标准模式）**：
   - 表单输入框的值完全由 React State 单一数据源控制，所有变动通过 `onChange` 同步回 State（Ant Design `Form` 表单的底层核心）：
   ```jsx
   const [name, setName] = useState("");
   <input value={name} onChange={(e) => setName(e.target.value)} />
   ```
2. **非受控组件（Uncontrolled）**：
   - 表单值由 DOM 自身维护，需要时通过 `useRef` 一次性读取。

---

# 七、列表、事件与条件渲染技巧

## 1、事件处理与冒泡控制
- **传递函数引用**：无参直接传引用 `onClick={handleClick}`，传参需用箭头函数包裹 `onClick={(e) => handleDelete(id, e)}`。
- **阻止事件冒泡与默认行为**：
  - `e.stopPropagation()`：阻止事件向父级 DOM 节点冒泡传播；
  - `e.preventDefault()`：阻止浏览器原生默认行为（如阻止表单提交刷新、阻止 `<a>` 标签跳转）。

## 2、列表渲染与 Key 的底层 Diff 原理
- 使用原生 `map()` 渲染列表；
- **为什么必须提供稳定唯一的 `key`？（底层原理）**：
  - React 使用 Virtual DOM Diff 算法对比新旧列表；
  - 如果没有 key 或使用数组 index 作为 key，当数组在中间插入或删除元素时，React 会误以为是所有后续元素的内容发生了改变，导致所有子 DOM 节点被暴力销毁重建；
  - 提供了唯一的 `key`（如 `item.id`）后，React 能精准识别出“哪个节点只是移动了位置，哪个节点是新增的”，仅做最小化的真实 DOM 操作：
```jsx
<ul>
    {items.map(item => (
        <li key={item.id}>{item.name}</li>
    ))}
</ul>
```

## 3、条件渲染
```jsx
// 1、短路与 &&（注意：左侧必须是明确的布尔值，避免 0 && ... 把 0 渲染到屏幕上）
{isLoggedIn && <UserAvatar />}
{list.length > 0 && <DataTable />}

// 2、三元运算符
{isLoading ? <Spin /> : <Content />}
```

---

# 八、性能优化与 React 19 新特性

## 1、性能优化三剑客
1. **`React.memo(Component)`**：包裹子组件，组件会在渲染前对新旧 Props 进行浅比较；如果 Props 完全相同，直接跳过该子组件的渲染执行。
2. **`useMemo`**：在 Fiber 节点上缓存 `[计算结果, 依赖项]`，依赖项不变时直接返回缓存结果，跳过复杂的耗时计算：
```jsx
const expensiveList = useMemo(() => list.filter(item => item.score > 90), [list]);
```
3. **`useCallback`**：本质是 `useMemo(() => fn, deps)`，缓存 `[函数指针, 依赖项]`，依赖项不变时始终返回内存中同一个函数指针地址，配合 `React.memo` 防止子组件因为父组件重新生成函数引用而产生无谓的被动重渲染：
```jsx
const handleDelete = useCallback((id) => {
    deleteApi(id);
}, []);
```

## 2、React 19 重要新特性
1. **`ref` 作为普通 Prop**：函数组件直接接收 `ref` 属性，彻底废弃繁琐的 `forwardRef`。
2. **`use()` API（异步挂起机制）**：
   - 在组件内部直接同步读取 Promise 数据；
   - 若 Promise 处于 pending，React 主动在底层抛出该 Promise 并由 `<Suspense>` 捕获显示 loading；resolve 后自动恢复执行组件：
```jsx
import { use } from 'react';

function UserInfo({ userPromise }) {
    const user = use(userPromise);
    return <div>用户名：{user.name}</div>;
}
```
3. **`useActionState`**：原生管理表单异步提交的 pending 与错误状态。

---

# 九、错误边界与路由懒加载（Suspense）

## 1、路由与组件懒加载（性能优化必备）
- 配合 Webpack/Vite 拆分代码分包（Code Splitting），页面被访问时才异步加载对应的 JS 文件：
```jsx
import React, { lazy, Suspense } from 'react';
const UserPage = lazy(() => import('./pages/UserPage'));

function App() {
    return (
        <Suspense fallback={<div>页面加载中...</div>}>
            <UserPage />
        </Suspense>
    );
}
```

---

# 十、应用启动根挂载（React 19 标准入口）

- 彻底淘汰旧版 `ReactDOM.render`，统一使用 `createRoot`：
```jsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')).render(
    <React.StrictMode>
        <App />
    </React.StrictMode>
);
```
---

---

# 十二、Zustand 全景指南

## 1、为什么选择 Zustand？（核心优势）
1. **零 Provider 嵌套**：无需在顶层包 `<Provider>`，杜绝洋葱套娃。
2. **细粒度按需订阅（Selector）**：只有自己订阅的字段变化才重绘，性能极高。
3. **脱离 React 组件使用**：可在 `http.ts` 拦截器、工具函数中直接通过 `.getState()` / `.setState()` 读写。
4. **内置异步支持**：Action 函数内直接写 `async/await`，无需额外中间件。

---

## 2、全套核心 API 详解

### (1) `create((set, get, store) => ({ ... }))`
创建与 React 绑定的全局 Store Hook。
* **`set(partial, replace?)`**：修改状态。
  - **默认浅合并（`replace: false`）**：`set({ count: 5 })`（内部自动执行 `{ ...state, count: 5 }`，无需手写展开）；
  - **函数式更新**：`set(state => ({ count: state.count + 1 }))`（基于最新值计算）；
  - **全量覆盖替换（`replace: true`）**：`set(initialState, true)`（彻底用新对象替换整个 Store，常用于退出登录一键清空重置！）。
* **`get()`**：在 Action 内部读取当前 Store 的其他字段最新值：
  ```ts
  const token = get().token;
  ```

### (2) `store.getState()` 与 `store.setState(partial, replace?)`
脱离 React 组件，在纯 JS/TS 文件（如 Axios 拦截器、路由守卫）中直接调用：
```ts
// 1、读取当前状态（非响应式，不引发组件重绘）
const currentToken = useUserStore.getState().token;

// 2、直接外部修改状态
useUserStore.setState({ token: "new_token" });

// 3、外部全量重置
useUserStore.setState({ user: null, token: null });
```

### (3) `store.subscribe(listener)`（外部事件订阅）
在组件外部监听 Store 数据变动：
```ts
const unsubscribe = useUserStore.subscribe((state, prevState) => {
    console.log("状态从", prevState, "变为", state);
});

// 取消监听
unsubscribe();
```

---

## 3、组件内消费 Store 的四大姿势

### 1. 精准单字段订阅（Selector - 最推荐）
```tsx
function Header() {
    // 只有 user 变了当前组件才重绘；token 或 isLoading 改变 0 次多余刷新！
    const user = useUserStore(state => state.user);
    const logout = useUserStore(state => state.logout);

    return <div>欢迎：{user?.name} <button onClick={logout}>退出</button></div>;
}
```

### 2. 多字段浅比较解构（`useShallow`）
当需要同时解构多个字段时，使用 `useShallow` 避免对象引用不同引发多余重绘：
```tsx
import { useShallow } from 'zustand/react/shallow';

function UserProfile() {
    const { user, isLoading } = useUserStore(
        useShallow(state => ({ user: state.user, isLoading: state.isLoading }))
    );
    return <div>...</div>;
}
```

### 3. 只获取操作方法（永不重绘）
```tsx
function ActionButton() {
    // 组件只消费函数，无论 Store 数据怎么变，该组件永远不重绘！
    const increase = useStore(state => state.increase);
    return <button onClick={increase}>加 1</button>;
}
```

---

## 4、常用官方中间件（Middleware）

### (1) `persist`（自动本地持久化）
将状态自动同步保存到 `localStorage` 或 `sessionStorage`：
```ts
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';

export const useUserStore = create(
    persist<UserState>(
        (set) => ({
            token: null,
            user: null,
            setToken: (token) => set({ token }),
        }),
        {
            name: 'user-storage', // 存入 localStorage 的 key
            storage: createJSONStorage(() => localStorage), // 默认 localStorage
            partialize: (state) => ({ token: state.token }), // 【可选】过滤只持久化 token，不存临时变量
        }
    )
);
```

### (2) `devtools`（配合 Redux DevTools 浏览器插件调试）
```ts
import { devtools } from 'zustand/middleware';

export const useStore = create(
    devtools(
        (set) => ({
            count: 0,
            increase: () => set((state) => ({ count: state.count + 1 }), false, 'increase'), // 标记 Action 名
        }),
        { name: 'AppStore' }
    )
);
```

### (3) `immer`（简化深层嵌套对象修改）
无需写层层 `{ ...state, a: { ...state.a, b: 1 } }`，直接就地修改：
```ts
import { immer } from 'zustand/middleware/immer';

export const useStore = create(
    immer<State>((set) => ({
        nested: { count: 0 },
        inc: () => set((state) => {
            state.nested.count += 1; // 像普通可变对象一样直接修改！
        }),
    }))
);
```

---

## 5、标准模板

```ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface UserProfile {
    id: string;
    userName: string;
    roles: string[];
}

interface UserState {
    user: UserProfile | null;
    token: string | null;
    isLoading: boolean;
    // Actions
    setUser: (user: UserProfile) => void;
    fetchProfile: () => Promise<void>;
    logout: () => void;
}

const initialState = {
    user: null,
    token: null,
    isLoading: false,
};

export const useUserStore = create<UserState>()(
    persist(
        (set, get) => ({
            ...initialState,

            setUser: (user) => set({ user }),

            // 异步调接口
            fetchProfile: async () => {
                set({ isLoading: true });
                try {
                    const res = await getUserProfileApi();
                    set({ user: res, isLoading: false });
                } catch (err) {
                    set({ isLoading: false });
                    throw err;
                }
            },

            // 一键重置状态
            logout: () => set(initialState),
        }),
        {
            name: 'auth-storage',
            partialize: (state) => ({ token: state.token }), // 仅持久化 token
        }
    )
);
```

---

## 6、Zustand vs Flutter (Riverpod) 像素级对标速查表

| 功能操作 | Zustand (React) | Flutter (Riverpod) | 核心本质 |
| :--- | :--- | :--- | :--- |
| **定义数据与方法** | `create<State>((set, get) => ({ ... }))` | `class XxxNotifier extends AsyncNotifier<State>` | 声明全局数据仓库与操作员 |
| **组件订阅并重绘** | `const data = useStore(s => s.data)` | `final data = ref.watch(provider)` | 响应式订阅 |
| **精准按需订阅** | `const name = useStore(s => s.user.name)` | `ref.watch(provider.select(s => s.name))` | 细粒度更新，防无谓重绘 |
| **只调方法不重绘** | `const action = useStore(s => s.action)` | `ref.read(provider.notifier).action()` | 命令式发号施令 |
| **脱离组件读写** | `useStore.getState().xxx`<br>`useStore.setState({ ... })` | `container.read(provider)` | 拦截器/工具类中外部读写 |
| **全量重置 Store** | `set(initialState, true)` | `ref.invalidate(provider)` | 一键恢复初始状态 |