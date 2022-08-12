# ����

    JSX �� JavaScript ����չ�﷨������ <></> ��ǩ��д������ JSX��JSX ��д�����ͨ��Ԥ������ babel �������ٽ��� React ����Ⱦ��ָ���������£��γ�����htmlҳ�棬���������������ʾ��

# Ҫ��

    1��������
    // jsx��������
    const element = <h1>Hello, world!</h1>;

    // jsx����������
    const element = <div tabIndex="0"></div>;
    const element = <img src={user.avatarUrl}></img>;
    const element = <img src={user.avatarUrl} />;

    // jsx�п��԰��������Ԫ��
    const element = (
        <div>
            <h1>Hello!</h1>
            <h2>Good to see you here.</h2>
        </div>
    );

    // jsx��Ϊ���ʽ������return����
    function getGreeting(user) {
        if (user) {
            return <h1>Hello, {formatName(user)}!</h1>;
        }
        return <h1>Hello, Stranger.</h1>;
    }

    2����չ������� ...���������� props ����������������ǵȼ۵ģ�
    function App1() {
        return <Greeting firstName="Ben" lastName="Hector" />;
    }
    function App2() {
        const props = { firstName: 'Ben', lastName: 'Hector' };
        return <Greeting {...props} />;
    }
    // �÷�2��������Ҫ�޸�����kind������������...����ʾ
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