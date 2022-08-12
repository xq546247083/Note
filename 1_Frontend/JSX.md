# 概括

    JSX 是 JavaScript 的扩展语法，这种 <></> 标签的写法就是 JSX。JSX 编写的组件通过预处理器 babel 解析后，再交给 React 库渲染到指定父容器下，形成最终html页面，供浏览器解析和显示。

# 要点

    1、基本表达：
    // jsx声明变量
    const element = <h1>Hello, world!</h1>;

    // jsx中设置属性
    const element = <div tabIndex="0"></div>;
    const element = <img src={user.avatarUrl}></img>;
    const element = <img src={user.avatarUrl} />;

    // jsx中可以包含多个子元素
    const element = (
        <div>
            <h1>Hello!</h1>
            <h2>Good to see you here.</h2>
        </div>
    );

    // jsx作为表达式，用在return返回
    function getGreeting(user) {
        if (user) {
            return <h1>Hello, {formatName(user)}!</h1>;
        }
        return <h1>Hello, Stranger.</h1>;
    }

    2、用展开运算符 ...来传递整个 props 对象。以下两个组件是等价的：
    function App1() {
        return <Greeting firstName="Ben" lastName="Hector" />;
    }
    function App2() {
        const props = { firstName: 'Ben', lastName: 'Hector' };
        return <Greeting {...props} />;
    }
    // 用法2：导出需要修改属性kind，其他属性用...来表示
    const Button = props => {
        const { kind, ...other } = props;
        const className = kind === "primary" ? "PrimaryButton" : "SecondaryButton";
        return <button className={className} {...other} />;
    };
    const App = () => {
        return (
            <div>
                <Button kind="primary" onClick={() => console.log("clicked!")}>
                    Hello World!
                </Button>
            </div>
        );
    };