# React 学习笔记

# 一、核心心法：React 到底是如何工作的？

## 1、声明式与组件化
- 页面由一个个独立的**函数组件（Function Component）**像积木一样拼装而成。
- 视图由状态驱动：`UI = fn(State)`，你只管描述数据在某种状态下长什么样，React 负责自动对比 Virtual DOM 并高效更新真实 DOM。

## 2、Props vs State（核心界限）
| 概念 | 归属与控制权 | 可变性 | 用途 |
| :-- | :-- | :-- | :-- |
| **Props** | 外部传入（父组件传给子组件） | **只读不可变**（组件决不能修改自己的 props） | 组件通信、配置传递、插槽（children） |
| **State** | 组件内部私有状态 | 通过 Setter 函数修改 | 控制组件自身随交互变化的数据 |

## 3、不可变数据原则（Immutable）与内存指针
- **为什么不能直接修改 State？（底层原理）**：
  - 在 JavaScript 中，对象和数组是引用类型（指针）；
  - React 检查状态是否变化时，为了极致性能，做的是**浅比较（`Object.is(oldState, newState)`，仅比对内存指针地址）**；
  - 如果直接写 `user.name = "Tom"` 或 `list.push(item)`，虽然内部属性变了，但内存指针地址没有改变，React 认为数据未变，从而跳过重新渲染；
  - 因此必须使用解构展开生成**具有新内存地址的全新副本**：
```jsx
setUser({ ...user, name: "Tom" }); // 更新对象（创建新对象指针）
setList([...list, newItem]);       // 更新数组（创建新数组指针）
```

## 4、组件重新渲染（Re-render）的 3 个触发时机
1. **自身的 State 发生改变**；
2. **父组件重新渲染了**（子组件默认也会被动跟着重新渲染，除非用 `React.memo` 进行浅比较阻断）；
3. **消费的 Context / 全局 Store 发生了变化**。

---

# 二、组件通信全景（4 大方式）

## 1、父传子（Props & 插槽）
```jsx
// 1、普通属性传递
<UserCard name="Tom" age={18} />

// 2、children 插槽（内容分发，组件内部通过 props.children 渲染）
function Card({ title, children }) {
    return (
        <div className="card">
            <h3>{title}</h3>
            <div className="card-body">{children}</div>
        </div>
    );
}

// 父组件使用：像 HTML 标签一样自由嵌套内容
function App() {
    return (
        <Card title="用户信息">
            <p>用户名：Tom</p>
            <button>编辑</button>
        </Card>
    );
}
```

## 2、子传父（回调函数 Callback）
- **原理**：父组件把一个函数通过 Props 传给子组件，子组件在触发事件时调用该函数回传数据：
```jsx
// 子组件：SearchInput
function SearchInput({ onSearch }) {
    const [keyword, setKeyword] = useState("");
    return (
        <div>
            <input value={keyword} onChange={(e) => setKeyword(e.target.value)} />
            <button onClick={() => onSearch(keyword)}>搜索</button>
        </div>
    );
}

// 父组件：接收子组件回传的 keyword
function UserListPage() {
    const handleSearch = (searchKey) => {
        console.log("父组件收到子组件传递的关键词:", searchKey);
    };
    return <SearchInput onSearch={handleSearch} />;
}
```

## 3、兄弟组件间通信（状态提升 State Lifting）
- **原理**：当两个兄弟组件需要共享数据时，**把该 State 提升到它们共同的最近父组件中维护**，父组件再分别通过 Props 分发给两个子组件：
```jsx
function Parent() {
    const [activeId, setActiveId] = useState(null); // 提升到父组件的共享状态

    return (
        <>
            <BrotherA onSelect={(id) => setActiveId(id)} />
            <BrotherB currentId={activeId} />
        </>
    );
}
```

## 4、跨层级与全局通信（Context 或 Zustand 全局状态）
- 简单场景使用 `createContext` + `useContext`；
- 企业级复杂业务状态（用户信息、权限、全局设置）统一使用 **Zustand**：
  - 任意组件 A：`useUserStore.getState().setUser(...)`（更新状态）；
  - 任意组件 B：`const user = useUserStore(s => s.user)`（自动同步接收最新数据并刷新）。

---

# 三、React 19 核心 Hooks（底层原理解析）

## 1、useState（定义组件状态与函数式更新）
- **底层运行原理**：
  - React 在组件外部的 Fiber 节点上维护了一条状态链表（`memoizedState`），每次调用 `useState` 都会按声明顺序在链表中分配一个槽位；
  - 每次组件重新渲染时，React 依次从对应的链表槽位中取出最新的状态值；
  - 调用 `setCount(新值)` 时，React 将更新任务推入更新队列，调度重新执行该组件函数并生成新 Virtual DOM。
- **函数式更新（防并发/异步覆盖）**：
  - 如果新状态依赖于上一次状态，必须传入回调函数：
```jsx
const [count, setCount] = useState(0);

// 错误写法（在并发/批量更新中可能只加了 1）
setCount(count + 1);

// 正确写法（基于最新前置状态计算，队列串行计算）
setCount(prev => prev + 1);
```

## 2、useEffect（副作用调度与生命周期合一）
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

## 3、useRef（DOM 引用与跨渲染常驻变量）
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

## 4、useContext（跨层级发布-订阅数据消费）
- **底层运行原理**：
  - 基于**“发布-订阅（Pub/Sub）”**模式；
  - `<MyContext.Provider value={data}>` 作为数据的发布者；
  - 任何调用 `useContext(MyContext)` 的子孙组件，都会在 React 内部将自身注册为该 Context 的“消费者”；
  - 当 Provider 的 `value` 发生变化时，React 会精准定向通知所有注册的消费者组件触发重新渲染，中间层未消费该 Context 的父组件不受影响。
```jsx
const { theme } = useContext(ThemeContext);
```

## 5、自定义 Hook（Custom Hook - 复用业务逻辑的终极武器）
- **底层运行原理**：
  - 自定义 Hook **不是在组件之间共享 State 数据本身**，而是 **复用包含状态与副作用的代码逻辑片段**；
  - 凡是以 `use` 开头的函数都可以组合调用原生 Hook。每次在不同组件里调用自定义 Hook，都会在该组件自身的 Fiber 链表上独立创建专属于自己的 state 和 effect，彼此互不干扰：
```jsx
// 封装一个窗口宽度监听的自定义 Hook
function useWindowWidth() {
    const [width, setWidth] = useState(window.innerWidth);
    useEffect(() => {
        const handleResize = () => setWidth(window.innerWidth);
        window.addEventListener('resize', handleResize);
        return () => window.removeEventListener('resize', handleResize);
    }, []);
    return width;
}

// 在任何组件里直接复用
function MyComponent() {
    const width = useWindowWidth();
    return <div>当前窗口宽度: {width}</div>;
}
```

---

# 四、表单处理（受控组件 vs 非受控组件）

## 1、受控组件（Controlled Component - 推荐标准模式）
- 表单输入框的值完全由 React State 控制，所有变动通过 `onChange` 同步回 State（Ant Design `Form` 的底层思想）：
```jsx
const [name, setName] = useState("");
<input value={name} onChange={(e) => setName(e.target.value)} />
```

## 2、非受控组件（Uncontrolled Component）
- 表单值由 DOM 自身维护，需要时通过 `useRef` 读取值。

---

# 五、列表、事件与条件渲染技巧

## 1、事件处理（Event Handling）
- 必须传递函数引用，传参需用箭头函数包裹：
```jsx
<button onClick={handleClick}>无参直接传引用</button>
<button onClick={(e) => handleDelete(id, e)}>有参箭头函数包裹</button>
```

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

# 六、性能优化与 React 19 新特性

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

# 七、错误边界与路由懒加载（Suspense）

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

# 八、应用启动根挂载（React 19 标准入口）

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