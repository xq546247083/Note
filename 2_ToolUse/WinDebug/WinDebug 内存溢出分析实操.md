# �ڴ�����ķ���ʵ��

## ���س�ʼ����

    .logopen d:\log.txt
    .sympath srv*C:\symbols*https://msdl.microsoft.com/download/symbols
    !sym noisy
    .cordll -ve -u  -l
    .load SOS.dll
    .load clr.dll
    .load mscordacwks.dll
    .load mscordbi.dll
    .loadby clr sos
    .load wow64exts
    .symfix c:\symbols
    .reload

## �鿴���йܶ�й¶���Ƿ��йܶ�й¶

    !address -summary

    Usage Summary��ʹ����������մ�С����
        ͨ���ŵ�һ�Ĳ���Heap����<unkown>��Heap��C++�ķ��й��ڴ棬<unkown>��C#���й��ڴ档
    Type Summary���������������3�࣬�ֱ��ǣ�
        MEM_PRIVATE����ǰ���̶�ռ���ڴ档
        MEM_MAPPED��ӳ�䵽�ļ����ڴ棬��Щ�ļ������ڽ��̳���������Memory Mapping File��
        MEM_IMAGE��ӳ�䵽���̳�����ڴ棬���������ص�dll��

## ������������Ʋ��й¶�Ķѵ����ַ�ʽ

    1��ֱ�ӿ���С
        !heap -s
    2������һ��dump�ļ��Աȴ�С
        !heap -s
    3�����й©�Ķѿ�
        !heap -l

## ��ѯ�����

    1�������С��ͳ�ƶ���Ϣ
        !heap -stat -h 00430000
    2����ʾ�ѵ����п�
        !heap -h 00430000
    3�������ѵ��ڴ�������
        !heap -p -h 00430000
        
## ������ַ��Ϣ

    1���鿴��ջ
    2���鿴����
    3���鿴����