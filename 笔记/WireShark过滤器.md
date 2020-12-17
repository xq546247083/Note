# WireShark常用过滤器

## 1、比较运算符

    eq, ==    Equal
    ne, !=    Not Equal
    gt, >     Greater Than
    lt, <     Less Than
    ge, >=    Greater than or Equal to
    le, <=    Less than or Equal to

## 2、搜索和匹配运算符

    contains     Does the protocol, field or slice contain a value
    matches, ~   Does the protocol or text string match the given
                 case-insensitive Perl-compatible regular expression

    案例：若要在捕获中搜索给定的 HTTP URL，可以使用以下筛选器：http contains "https://www.wireshark.org

## 3、函数

    upper(string-field) - converts a string field to uppercase
    lower(string-field) - converts a string field to lowercase
    len(field)          - returns the byte length of a string or bytes field
    count(field)        - returns the number of field occurrences in a frame
    string(field)       - converts a non-string field to string

## 4、切片运算符

    [i:j]    i = start_offset, j = length
    [i-j]    i = start_offset, j = end_offset, inclusive.
    [i]      i = start_offset, length = 1
    [:j]     start_offset = 0, length = j
    [i:]     start_offset = i, end_offset = end_of_field

    案例：frame[-4:4] == 0.1.2.3

## 5、成员运算符

    tcp.port in {80 443 8080}
    http.request.method in {"HEAD" "GET"}
    tcp.port in {443 4430..4434}
    ip.addr in {10.0.0.5 .. 10.0.0.9 192.168.1.1..192.168.1.9}
    
## 6、逻辑表达式

    and, &&   Logical AND
    or,  ||   Logical OR
    not, !    Logical NOT

## 7、过滤器字段

    所有过滤器字段，见https://www.wireshark.org/docs/dfref/
    ip.src==192.168.1.1 and tcp.srcport==80 and tcp.dstport=1000 and frame.len==66