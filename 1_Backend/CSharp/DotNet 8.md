# DotNet 8

>## ���б�̵����ݽṹ

---

	System.Collections.Concurrent.BlockingCollection<T>
        ʵ�� System.Collections.Concurrent.IProducerConsumerCollection<T> ���̰߳�ȫ�����ṩ���������ƹ��ܡ� 
        1�����û�вۿ��û������������ֹ�������̡߳� 
        2���������Ϊ�գ���ֹʹ�����̡߳� 
        3�������ͻ�֧��ʹ���ߺ�������ִ�з���ֹ���ʡ�
        4�����Խ� BlockingCollection<T> ���������󱸴洢���Ա�Ϊ֧�� IEnumerable<T> ���κλ������ṩ��ֹ�Ͱ󶨡�
    System.Collections.Concurrent.ConcurrentBag<T>
        �ṩ�����ŵ���Ӻͻ�ȡ�������̰߳�ȫ��ʵ�֡�
    System.Collections.Concurrent.ConcurrentDictionary<TKey,TValue>
        �����ŵĲ����ֵ����͡�
    System.Collections.Concurrent.ConcurrentQueue<T>
        �����ŵĲ��� FIFO ���С�
    System.Collections.Concurrent.ConcurrentStack<T>
        �����ŵĲ��� LIFO ��ջ��
    System.Lazy<T>
        �ṩ�̰߳�ȫ�����ͳٻ���ʼ����
    System.AggregateException
    ���Ϳ����ڲ���Ը����̲߳����׳��Ķ���쳣������������Ϊһ���쳣���ظ������̡߳� Ϊ�ˣ�System.Threading.Tasks.Task �� System.Threading.Tasks.Parallel �����Լ� PLINQ ����ʹ�� AggregateException��
        
---

>## PLINQ����Parallel.ForEach���ơ�

---

	AsParallel	PLINQ ����ڵ㡣 ָ��������ܣ�Ӧ���л���ѯ�����ಿ�֡�
    AsSequential	ָ����ѯ�����ಿ��Ӧ��ǲ��е� LINQ ��ѯһ����˳�����С�
    AsOrdered	ָ�� PLINQ ӦΪ��ѯ�����ಿ�ֱ���Դ���е����򣬻�ֱ������ͨ��ʹ�� orderby���� Visual Basic ��Ϊ Order By���Ӿ��������Ϊֹ��
    AsUnordered	ָ������Դ���е�������Ҫ��ѯ���ಿ�ֵ� PLINQ��
    WithCancellation	ָ�� PLINQ Ӧ���ڼ�������ȡ��ʱ���ṩ��ȡ����ǵ�״̬�Լ�ȡ��ִ�С�
    WithDegreeOfParallelism	ָ�� PLINQ Ӧ���ڲ��л���ѯ�Ĵ����������������
    WithMergeOptions	�ṩ�й� PLINQ Ӧ��Σ�������ܣ������н���ϲ���ʹ���߳��ϵ�һ�����е���ʾ��
    WithExecutionMode	ָ�� PLINQ Ӧ��β��л���ѯ����ʹ�ǵ�Ĭ����Ϊ�ǰ�˳�����в�ѯʱ����
    ForAll	һ�ֶ��߳�ö�ٷ�������ѭ�����ʲ�ѯ�����ͬ���������ڲ����Ⱥϲ���ʹ�����̵߳�����²��д�������
    Aggregate ����	���� PLINQ Ψһ�����أ������ö��̱߳��ط������м�ۺ��Լ�һ�����ںϲ����з�����������վۺϺ�����
	
---

>## PLINQ��TPL���Զ����������

---

	AsParallel	PLINQ ����ڵ㡣 ָ��������ܣ�Ӧ���л���ѯ�����ಿ�֡�
    AsSequential	ָ����ѯ�����ಿ��Ӧ��ǲ��е� LINQ ��ѯһ����˳�����С�
    AsOrdered	ָ�� PLINQ ӦΪ��ѯ�����ಿ�ֱ���Դ���е����򣬻�ֱ������ͨ��ʹ�� orderby���� Visual Basic ��Ϊ Order By���Ӿ��������Ϊֹ��
    AsUnordered	ָ������Դ���е�������Ҫ��ѯ���ಿ�ֵ� PLINQ��
    WithCancellation	ָ�� PLINQ Ӧ���ڼ�������ȡ��ʱ���ṩ��ȡ����ǵ�״̬�Լ�ȡ��ִ�С�
    WithDegreeOfParallelism	ָ�� PLINQ Ӧ���ڲ��л���ѯ�Ĵ����������������
    WithMergeOptions	�ṩ�й� PLINQ Ӧ��Σ�������ܣ������н���ϲ���ʹ���߳��ϵ�һ�����е���ʾ��
    WithExecutionMode	ָ�� PLINQ Ӧ��β��л���ѯ����ʹ�ǵ�Ĭ����Ϊ�ǰ�˳�����в�ѯʱ����
    ForAll	һ�ֶ��߳�ö�ٷ�������ѭ�����ʲ�ѯ�����ͬ���������ڲ����Ⱥϲ���ʹ�����̵߳�����²��д�������
    Aggregate ����	���� PLINQ Ψһ�����أ������ö��̱߳��ط������м�ۺ��Լ�һ�����ںϲ����з�����������վۺϺ�����
	
---


