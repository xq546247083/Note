# 要点

## 1、先了解JavaScript、JSX，区分他们

## 2、组件

    1、定义组件最简单的方式就是编写 JavaScript 函数：
    function Welcome(props) {
        return <h1>Hello, {props.name}</h1>;
    }
    2、同时还可以使用 ES6 的 class 来定义组件：
    class Welcome extends React.Component {
        render() {
            return <h1>Hello, {this.props.name}</h1>;
        }
    }
    3、之前，我们遇到的 React 元素都只是 DOM 标签，React 元素也可以是用户自定义的组件。当 React 元素为用户自定义组件时，它会将 JSX 所接收的属性（attributes）以及子组件（children）转换为单个对象传递给组件，这个对象被称之为 “props”。
    function Welcome(props) {
        return <h1>Hello, {props.name}</h1>;
    }
    const element = <Welcome name="Sara" />;
    ReactDOM.render(
        element,
        document.getElementById('root')
    );
    4、组件无论是使用函数声明还是通过 class 声明，都决不能修改自身的 props。
    5、State 与 props 类似，但是 state 是私有的，并且完全受控于当前组件。
    6、关于 setState() 你应该了解2件事：
        1、不要直接修改 State。例如，此代码不会重新渲染组件：this.state.comment = 'Hello'。而是应该使用：this.setState({comment: 'Hello'});
        2、State 的更新可能是异步的
            此代码可能会无法更新计数器：
            // Wrong
            this.setState({
                counter: this.state.counter + this.props.increment,
            });
            要解决这个问题，可以让 setState() 接收一个函数而不是一个对象。这个函数用上一个 state 作为第一个参数，将此次更新被应用时的 props 做为第二个参数。
            // Correct
            this.setState((state, props) => ({
                counter: state.counter + props.increment
            }));
    7、尽管 this.props 和 this.state 是 React 本身设置的，且都拥有特殊的含义，但是其实你可以向 class 中随意添加不参与数据流（比如计时器 ID）的额外字段。
        class Clock extends React.Component {
            constructor(props) {
            super(props);
            this.state = {date: new Date()};
        }
        componentDidMount() {
            this.timerID = setInterval(
                () => this.tick(),
                1000
            );
        }
        componentWillUnmount() {
            clearInterval(this.timerID);
        }
        tick() {
            this.setState({
                date: new Date()
            });
        }
        render() {
            return (
                <div>
                    <h1>Hello, world!</h1>
                    <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
                </div>
                );
            }
        }
        ReactDOM.render(
            <Clock />,
            document.getElementById('root')
        );

## 3、事件

    1、事件
    class LoggingButton extends React.Component {
        handleClick() {
            console.log('this is:', this);
        }
        render() {
            return (
            <button onClick={() => this.handleClick()}>
                Click me
            </button>
            );
        }
    }
    2、向事件处理程序传递参数
        <button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>

## 4、列表

    1、渲染多个组件
        使用 Javascript 中的 map() 方法来遍历 numbers 数组。将数组中的每个元素变成 <li> 标签，最后我们将得到的数组赋值给 listItems。把整个 listItems 插入到 <ul> 元素中，然后渲染进 DOM。
        const numbers = [1, 2, 3, 4, 5];
        const listItems = numbers.map((number) =>
            <li>{number}</li>
        );
        ReactDOM.render(
            <ul>{listItems}</ul>,
            document.getElementById('root')
        );
    2、基础列表组件
        function ListItem(props) {
            // 正确！这里不需要指定 key：
            return <li>{props.value}</li>;
        }
        function NumberList(props) {
            const numbers = props.numbers;
            const listItems = numbers.map((number) =>
                // 正确！key 应该在数组的上下文中被指定
                <ListItem key={number.toString()} value={number} />
        );
        return (
            <ul>
                {listItems}
            </ul>
            );
        }
        const numbers = [1, 2, 3, 4, 5];
        ReactDOM.render(
            <NumberList numbers={numbers} />,
            document.getElementById('root')
        );

## 5、todo 核心概念看完了，高级指引没看

## 其他：

    1、在 JavaScript 中，true && expression 总是会返回 expression, 而 false && expression 总是会返回 false。
    
