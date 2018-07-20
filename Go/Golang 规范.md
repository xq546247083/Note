Golang规范
---------------------------------
# 命名与数据处理规范
1. 如果在函数内部出现错误，需记录该错误，然后抛出错误，直至回退到函数最外层进行处理。(对于项目初始化的函数，还需调用panic结束协程）

2. 对于包内逻辑独立完整的类型，才需建立子包单独存放;对于其他情况,请在同一级包内进行处理。(注意:包与文件夹概念不同，轻易建立子包会造成数据与接口的暴露)

3. 对于变量，一律以小写开头；如果该变量需要对包外提供，提供Get,Set接口进行数据访问。

4. 对于常量，如果该常量仅包内可见，前缀小写（con_）；如果包外可见，前缀大写（Con_）。

5. 对于自定义类型，如果仅包内可见，小写开头；如果包外可见，大写开头。类型内部字段名默认小写开头，需要序列化的字段大写。

6. 对于通道（chan）,如果仅包内可见,小写开头；如果包外可见，大写开头，此处不提供接口访问。

7. 在函数参数中出现的变量若与包内数据同名，统一以_开头加以区分。

8. 对于需要向包外提供的数据，如果不需要修改，统一返回副本，如果需要在包外修改，请返回指针。

9. 当有多个返回值时，每个返回值均需要取带上名字，例如: `func Hello()(name string, exist bool)` 

# 注释规范
1. 包注释：由于一个包中可能包含许多文件，而对每一个文件都写上包注释没有意义，所以只需要对其中一个文件写包注释即可；但是到底应该对哪个文件写注释呢，建议在每个包下面建一个文件名为：doc.go，其中的内容仅仅为包的注释，如下所示：
~~~
   /*
     定义响应数据对象     
     服务器响应客户端的请求最终都是将一个ResponseObject对象进行JSON序列化，然后发送给客户端     
     而每一个ResponseObject对象必定包含一个ResultStatus对象的标识，以标识本次响应的状态     
     */
     
     package responseDataObject
~~~

2. 类型注释：为了便于理解，所以必须对type关键字定义的类型进行注释，如：
~~~
   // 定义客户端对象，以实现对客户端连接的封装
    type Client struct {
    	// 公共属性
    	// 唯一标识
    	id *net.Conn
    
    	// 客户端连接对象
    	conn net.Conn
    
    	// 私有属性，内部使用
    	// 接收到的消息内容
    	content []byte
    
    	// 上次活跃时间
    	activeTime time.Time
    }
~~~

3. 方法注释：对外公开的方法（也就是首字母大写的方法）必须要注释，而内部方法（也就是首字母小写的方法）可以不进行注释。注释的格式如下：
~~~
// 获取指定响应类型的响应对象
// responseObj：响应对象
// rs：响应类型对象
// 返回值：
// responseDataObject.ResponseObject:响应对象
func getResultStatusResponseObj(responseObj responseDataObject.ResponseObject, rs responseDataObject.ResultStatus) responseDataObject.ResponseObject {
	responseObj.Code = rs
	responseObj.Message = rs.String()

	return responseObj
}
~~~


# 包引用规范
1. 使用绝对路径来引用所有的包（无论是外部包，或者是内部包）
2. 当引用外部包时，先使用go get 包的url来下载包到本地


# 项目结构规范
1. 由于GO语言的项目管理是以GOPATH为基础的，所以每个开发人员必须先设置好自己的GOPATH路径；

2. 不推荐每个项目可以设置自己的GOPATH，而是只使用一个GOPATH。原因是：如果各个项目的组织结构类似，那么在import包的时候，会沿着GOPATH里面设定的项目从左往右查找，当找到一个即返回了；这样的后果是后面的项目永远没有机会被找到，从而寻到错误；

3. 在GOPATH之下，需要建立src目录，在之下就是项目目录了，推荐个人项目以**github.com/UserName** 为上级目录，而公司项目则以公司域名为上级目录，如：

个人项目：
~~~
GOPATH
--src
	 --github.com
	     --Jordanzuo
         --chatServer
         --chatClient
~~~
公司项目：
~~~
--src
	--moqikaka.com
       --chatServer
       --chatClient
~~~

项目结构建议按如下方式组织：
~~~
-- Project
    -- doc ----->存放项目相关文档
    -- src ----->具体项目代码
    -- main.go ----->程序启动相关逻辑代码
    -- config.xml ----->配置文件
~~~