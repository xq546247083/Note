# TS 学习笔记

# 一、基础类型与类型系统

## 1、基本原始类型
TypeScript 在 JavaScript 基础上增加了静态类型定义，常见原始类型：
- boolean：布尔值（true / false）
- number：数字（包含整数、浮点数、NaN、Infinity）
- string：字符串
- symbol：符号值
- bigint：大整数
- null / undefined：空值与未定义

## 2、特殊类型
1、any
- 顶层类型，关闭该变量的所有类型检查。
- 可以赋予任何类型，也可以赋值给任何类型。
- 缺点：会污染其他变量，丢失类型安全，尽量少用。

2、unknown
- 类型安全的 any。
- 可以接受任何类型的值，但不能直接调用其属性或方法，也不能直接赋值给其他明确类型的变量。
- 必须先经过类型收窄（typeof / instanceof / 类型断言）后才能使用：
```ts
let value: unknown = "hello";
if (typeof value === "string") {
    console.log(value.toUpperCase()); // 正确
}
```

3、never
- 底层类型，表示永远不可能出现的值或不可能返回的分支。
- 常见场景：抛出异常的函数、无限死循环函数、联合类型穷尽性检查（Exhaustiveness check）。
```ts
function throwError(msg: string): never {
    throw new Error(msg);
}

// 穷尽分支检查
type Shape = "circle" | "square";
function getArea(s: Shape) {
    switch (s) {
        case "circle": return 1;
        case "square": return 2;
        default:
            const _exhaustiveCheck: never = s; // 若 Shape 新增类型未处理，此处编译报错
            return _exhaustiveCheck;
    }
}
```

4、void
- 表示没有任何返回值，通常用于没有 return 语句的函数。

## 3、联合类型与交叉类型
1、联合类型（|）
- 满足多个类型中的其中一种：
```ts
let id: number | string;
id = 1001;
id = "U1001";
```

2、交叉类型（&）
- 将多个类型合并为一个新类型，必须同时满足所有类型的属性：
```ts
type Person = { name: string };
type Employee = { employeeId: number };
type Staff = Person & Employee; // 必须同时拥有 name 和 employeeId
```

## 4、类型别名（type）
- 使用 type 关键字为已有类型定义别名：
```ts
type UserId = string | number;
type Callback = (data: string) => void;
```

---

# 二、数组与元组

## 1、数组（Array）
- 定义方式：
```ts
let list1: number[] = [1, 2, 3];
let list2: Array<string> = ["a", "b", "c"];
```
- 只读数组：
```ts
let roList: readonly number[] = [1, 2, 3];
let roList2: ReadonlyArray<number> = [1, 2, 3];
// roList.push(4); // 报错，只读数组不可修改
```

## 2、元组（Tuple）
- 明确元素数量和各位置类型的特殊数组：
```ts
let user: [number, string] = [1, "admin"];

// 可选成员
let point: [number, number, number?] = [10, 20];

// 只读元组
let point2: readonly [number, number] = [10, 20];
```

---

# 三、枚举（Enum）

## 1、数字枚举
- 默认从 0 开始自增，支持反向映射：
```ts
enum Direction {
    Up,    // 0
    Down,  // 1
    Left,  // 2
    Right  // 3
}
let dirName = Direction[0]; // "Up"（反向映射）
```

## 2、字符串枚举
- 必须显式为每个成员赋字符串值，不支持反向映射（最常用）：
```ts
enum Role {
    Admin = "ADMIN",
    User = "USER",
    Guest = "GUEST"
}
```

## 3、常量枚举（const enum）
- 编译后会被直接内联为具体值，不会在 JS 中生成额外的对象查找代码，性能最高：
```ts
const enum Status {
    Success = 200,
    NotFound = 404
}
let code = Status.Success; // 编译后直接产出: var code = 200;
```

---

# 四、函数（Function）

## 1、函数类型声明
```ts
// 命名函数
function add(x: number, y: number): number {
    return x + y;
}

// 箭头函数 / 变量形式
const multiply: (a: number, b: number) => number = (a, b) => a * b;
```

## 2、参数特性
1、可选参数（?）
- 必须排在所有必选参数之后：
```ts
function buildName(first: string, last?: string): string {
    return last ? `${first} ${last}` : first;
}
```

2、默认参数（=）
```ts
function greet(name: string = "Guest"): string {
    return `Hello, ${name}`;
}
```

3、剩余参数（...rest）
```ts
function sum(...numbers: number[]): number {
    return numbers.reduce((a, b) => a + b, 0);
}
```

## 3、函数重载（Overload）
- 针对不同参数类型返回不同结果时使用。包含多个重载签名和一个实现签名：
```ts
function padding(all: number): number;
function padding(topAndBottom: number, leftAndRight: number): [number, number];
function padding(a: number, b?: number): any {
    if (b === undefined) return a;
    return [a, b];
}
```

---

# 五、对象与接口（Interface）

## 1、对象类型
```ts
let user: {
    readonly id: number; // 只读属性
    name: string;
    age?: number;        // 可选属性
    [key: string]: any;  // 索引签名：允许其他任意额外属性
} = { id: 1, name: "Tom", extra: true };
```

## 2、接口定义与继承
```ts
interface IUser {
    id: number;
    name: string;
    sayHello(): void;
}

// 继承单个或多个接口
interface IAdmin extends IUser {
    roles: string[];
}
```

## 3、接口合并（Declaration Merging）
- 相同名字的 interface 会自动合并属性（常用于给第三方库扩展属性）：
```ts
interface Document {
    myCustomField?: string;
}
```

## 4、type 与 interface 的选择与区别
| 特性 | interface | type |
| :-- | :-- | :-- |
| 定义对象/结构 | 推荐使用 | 支持 |
| 定义基本类型/联合/元组 | 不支持 | 支持（如 type ID = string \| number） |
| 扩展语法 | extends 继承 | & 交叉合并 |
| 同名声明合并 | 支持（自动合并） | 不支持（同名报重复定义错） |
| 计算属性/条件类型 | 不支持 | 支持高级类型运算 |

- 选型原则：
  - 定义业务数据对象、DTO、类契约时优先使用 `interface`；
  - 定义联合类型、元组、复杂类型映射或工具类型时使用 `type`。

---

# 六、类（Class）

## 1、成员访问修饰符
- public：默认修饰符，任何地方均可访问。
- protected：受保护修饰符，仅当前类及其子类内部可访问。
- private：私有修饰符，仅当前类内部可访问（TS 编译阶段检查）。
- #privateField：ES 原生私有字段（运行时真实私有）。
- readonly：只读属性，仅可在声明时或构造函数中初始化。

## 2、构造函数简写属性
- 在 constructor 参数前直接加修饰符，会自动声明并赋值同名属性：
```ts
class User {
    constructor(
        public name: string,
        private age: number,
        readonly id: number
    ) {}
}
// 等价于显式声明属性并在 constructor 里 this.name = name;
```

## 3、抽象类与接口实现
```ts
interface IPrintable {
    print(): void;
}

abstract class Animal {
    abstract makeSound(): void; // 抽象方法，子类必须实现
    move(): void {
        console.log("moving...");
    }
}

class Dog extends Animal implements IPrintable {
    makeSound() { console.log("bark"); }
    print() { console.log("dog"); }
}
```

---

# 七、泛型（Generics）

- 核心思想：把“类型”作为参数传入，实现代码复用和类型保留。

## 1、基本用法
```ts
// 泛型函数
function identity<T>(arg: T): T {
    return arg;
}

// 泛型接口
interface ApiResponse<T> {
    code: number;
    message: string;
    data: T;
}

// 泛型类
class DataStore<T> {
    private items: T[] = [];
    add(item: T) { this.items.push(item); }
    get(index: number): T { return this.items[index]; }
}
```

## 2、泛型约束（extends）
- 限制泛型必须符合某种结构或条件：
```ts
// 约束 T 必须包含 length 属性
function getLength<T extends { length: number }>(arg: T): number {
    return arg.length;
}

// keyof 约束：约束 K 必须是 T 的某个属性名
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
    return obj[key];
}
```

## 3、泛型默认值
```ts
interface PageResult<T = any> {
    items: T[];
    total: number;
}
```

---

# 八、类型运算符

## 1、typeof
- 获取变量、函数或对象的 TypeScript 类型：
```ts
const user = { name: "Tom", age: 18 };
type UserType = typeof user; // { name: string; age: number }
```

## 2、keyof
- 获取对象类型所有属性键名组成的联合类型：
```ts
type User = { id: number; name: string };
type UserKeys = keyof User; // "id" | "name"
```

## 3、in
- 遍历联合类型的每一个成员（用于映射类型）：
```ts
type Keys = "name" | "age";
type UserMap = {
    [K in Keys]: string; // { name: string; age: string; }
};
```

## 4、索引访问（T[K]）
- 获取类型中指定属性的类型：
```ts
type User = { id: number; name: string };
type IdType = User["id"]; // number
```

## 5、条件类型与 infer
- 条件类型：`T extends U ? X : Y`
- infer 关键字：在条件判断中推断提取内部类型：
```ts
// 提取 Promise 返回值类型的底层原理
type UnpackPromise<T> = T extends Promise<infer R> ? R : T;
type Res = UnpackPromise<Promise<string>>; // string

// 提取数组元素类型
type ElementOf<T> = T extends (infer E)[] ? E : never;
type Item = ElementOf<number[]>; // number
```

---

# 九、内置实用类型工具（Utility Types）

日常开发最常用的 12 个内置类型：

| 类型工具 | 作用描述 | 示例 |
| :-- | :-- | :-- |
| Partial<T> | 将 T 中所有属性变为可选 | Partial<{ a: string; b: number }> ➡️ { a?: string; b?: number } |
| Required<T> | 将 T 中所有属性变为必填 | Required<{ a?: string }> ➡️ { a: string } |
| Readonly<T> | 将 T 中所有属性变为只读 | Readonly<{ a: string }> ➡️ { readonly a: string } |
| Record<K, T> | 构造一个键类型为 K、值类型为 T 的对象类型 | Record<string, number> ➡️ { [key: string]: number } |
| Pick<T, K> | 从 T 中挑出指定的若干属性 K | Pick<User, "id" \| "name"> |
| Omit<T, K> | 从 T 中剔除指定的若干属性 K | Omit<User, "password"> |
| Exclude<T, U> | 从联合类型 T 中排除 U | Exclude<"a" \| "b" \| "c", "a"> ➡️ "b" \| "c" |
| Extract<T, U> | 从联合类型 T 中提取可以赋值给 U 的类型 | Extract<string \| number, number> ➡️ number |
| NonNullable<T> | 从 T 中排除 null 和 undefined | NonNullable<string \| null \| undefined> ➡️ string |
| ReturnType<T> | 获取函数类型的返回值类型 | ReturnType<() => number> ➡️ number |
| Parameters<T> | 获取函数参数组成的元组类型 | Parameters<(a: string, b: number) => void> ➡️ [string, number] |
| Awaited<T> | 递归解包获取 Promise 最终 resolve 的数据类型 | Awaited<Promise<string>> ➡️ string |

---

# 十、类型断言与类型守卫

## 1、类型断言（as）
- 开发者明确知道变量的具体类型，告诉编译器跳过推断：
```ts
const someValue: unknown = "this is a string";
const strLength: number = (someValue as string).length;
```

## 2、非空断言（!）
- 明确排除 null 和 undefined：
```ts
const element = document.getElementById("root")!; // 断言一定能拿到 DOM
```

## 3、常量断言（as const）
- 将值收窄为最精确的字面量只读类型：
```ts
const routes = {
    home: "/home",
    login: "/login"
} as const;
// routes.home 类型变为只读字面量 "/home"，而非 string
```

## 4、类型守卫（Type Guards）
- 运行时缩小类型范围的方式：
```ts
// 1、typeof
if (typeof x === "string") { /* 此处 x 为 string */ }

// 2、instanceof
if (err instanceof Error) { console.log(err.message); }

// 3、in 运算符
if ("name" in obj) { /* 存在 name 属性 */ }

// 4、自定义类型谓词（is）
function isString(val: any): val is string {
    return typeof val === "string";
}
```

---

# 十一、环境声明与声明文件（declare & d.ts）

## 1、declare 关键字
- 用于为外部已存在的全局变量/JS 库补充类型声明，不产生编译代码：
```ts
// 声明全局变量
declare const __APP_VERSION__: string;

// 声明全局函数
declare function alert(message?: any): void;

// 声明第三方无类型的模块
declare module "lodash" {
    export function cloneDeep<T>(value: T): T;
}

// 声明静态资源文件（使得可以 import 图片/样式）
declare module "*.png" {
    const src: string;
    export default src;
}
```

## 2、注释指令
- `// @ts-ignore`：忽略下一行的 TypeScript 编译报错。
- `// @ts-expect-error`：预期下一行有报错（如果下一行没有报错反而会警告，更推荐使用）。

---

# 十二、tsconfig.json 核心常用配置速查

```json
{
  "compilerOptions": {
    /* 编译目标与模块系统 */
    "target": "ES2022",                       // 编译生成的 JS 版本 (ES5, ES6, ES2022, ESNext)
    "module": "ESNext",                       // 模块规范 (CommonJS, ESNext, NodeNext)
    "moduleResolution": "bundler",            // 模块解析策略 (bundler / node)
    "lib": ["ES2022", "DOM", "DOM.Iterable"], // 编译时包含的内置类型库

    /* 严格性检查 */
    "strict": true,                           // 开启所有严格模式类型检查
    "noImplicitAny": true,                    // 严禁隐式 any
    "strictNullChecks": true,                 // 严格空值检查（null/undefined 不可随意赋给其他类型）

    /* 路径与别名 */
    "baseUrl": ".",                           // 相对路径基准目录
    "paths": {
      "@/*": ["src/*"]                        // 模块路径别名映射
    },

    /* 构建与输出控制 */
    "noEmit": true,                           // 只做类型检查，不输出编译后的 js 文件（通常配合 Vite）
    "skipLibCheck": true,                     // 跳过第三方 .d.ts 声明文件的类型检查（大幅提升编译速度）
    "isolatedModules": true,                  // 确保每个文件都可以安全独立转译
    "jsx": "react-jsx"                        // React 17+ JSX 转译模式
  },
  "include": ["src/**/*"],                    // 包含的文件匹配规则
  "exclude": ["node_modules", "dist"]         // 排除的文件夹
}
```