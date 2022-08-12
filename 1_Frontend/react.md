# Ҫ��

## 1�����˽�JavaScript��JSX����������

## 2�����

    1�����������򵥵ķ�ʽ���Ǳ�д JavaScript ������
    function Welcome(props) {
        return <h1>Hello, {props.name}</h1>;
    }
    2��ͬʱ������ʹ�� ES6 �� class �����������
    class Welcome extends React.Component {
        render() {
            return <h1>Hello, {this.props.name}</h1>;
        }
    }
    3��֮ǰ������������ React Ԫ�ض�ֻ�� DOM ��ǩ��React Ԫ��Ҳ�������û��Զ����������� React Ԫ��Ϊ�û��Զ������ʱ�����Ὣ JSX �����յ����ԣ�attributes���Լ��������children��ת��Ϊ�������󴫵ݸ������������󱻳�֮Ϊ ��props����
    function Welcome(props) {
        return <h1>Hello, {props.name}</h1>;
    }
    const element = <Welcome name="Sara" />;
    ReactDOM.render(
        element,
        document.getElementById('root')
    );
    4�����������ʹ�ú�����������ͨ�� class ���������������޸������ props��
    5��State �� props ���ƣ����� state ��˽�еģ�������ȫ�ܿ��ڵ�ǰ�����
    6������ setState() ��Ӧ���˽�2���£�
        1����Ҫֱ���޸� State�����磬�˴��벻��������Ⱦ�����this.state.comment = 'Hello'������Ӧ��ʹ�ã�this.setState({comment: 'Hello'});
        2��State �ĸ��¿������첽��
            �˴�����ܻ��޷����¼�������
            // Wrong
            this.setState({
                counter: this.state.counter + this.props.increment,
            });
            Ҫ���������⣬������ setState() ����һ������������һ�����������������һ�� state ��Ϊ��һ�����������˴θ��±�Ӧ��ʱ�� props ��Ϊ�ڶ���������
            // Correct
            this.setState((state, props) => ({
                counter: state.counter + props.increment
            }));
    7������ this.props �� this.state �� React �������õģ��Ҷ�ӵ������ĺ��壬������ʵ������� class ��������Ӳ������������������ʱ�� ID���Ķ����ֶΡ�
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

## 3���¼�

    1���¼�
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
    2�����¼�������򴫵ݲ���
        <button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>

## 4���б�

    1����Ⱦ������
        ʹ�� Javascript �е� map() ���������� numbers ���顣�������е�ÿ��Ԫ�ر�� <li> ��ǩ��������ǽ��õ������鸳ֵ�� listItems�������� listItems ���뵽 <ul> Ԫ���У�Ȼ����Ⱦ�� DOM��
        const numbers = [1, 2, 3, 4, 5];
        const listItems = numbers.map((number) =>
            <li>{number}</li>
        );
        ReactDOM.render(
            <ul>{listItems}</ul>,
            document.getElementById('root')
        );
    2�������б����
        function ListItem(props) {
            // ��ȷ�����ﲻ��Ҫָ�� key��
            return <li>{props.value}</li>;
        }
        function NumberList(props) {
            const numbers = props.numbers;
            const listItems = numbers.map((number) =>
                // ��ȷ��key Ӧ����������������б�ָ��
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

## 5��todo ���ĸ�����ˣ��߼�ָ��û��

## ������

    1���� JavaScript �У�true && expression ���ǻ᷵�� expression, �� false && expression ���ǻ᷵�� false��
    
