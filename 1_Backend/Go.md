# Go

>## 一、Gin源码阅读

---

>### 1、获取框架

	go get github.com/gin-gonic/gin

>### 2、简单Demo

	func main() {
	    // 注册一个默认的路由器
	    router := gin.Default()
	    // 最基本的用法
	    router.GET("/hello", func(c *gin.Context) {
	        c.String(http.StatusOK, "hello")
	    })
	    // 绑定端口是8888
	    router.Run(":8888")
	}
	通过浏览器输入：http://localhost:8888/hello 即可访问

>### 3、基础使用

	1、gin支持所有的HTTP的方法例如: GET, POST, PUT, PATCH, DELETE 和 OPTIONS。通过【router.对应的http方法】注册。
	2、参数传递：
		2.1、Param:获取按照router.GET("/hello/:name/:passwd", func)方式注册的方法，且传入过来的参数。
		2.2、Query：解析URL参数方式传入的参数。
		2.3、PostForm：通过Body传过来的数据，数据形式有: application/x-www-form-urlencoded; multipart/form-data; application/json; text/xml。
		
	案例:
	func main() {
	    // 注册一个默认的路由器
	    router := gin.Default()
	    // 最基本的用法
	    router.GET("/hello/:name", func(c *gin.Context) {
	        name := c.Param("name")
	        words := c.Query("words")
	        c.String(http.StatusOK, fmt.Sprintf("hello %s,%s", name, words))
	    })
	    // 绑定端口是8888
	    router.Run(":8888")
	}
	通过浏览器输入：http://localhost:8888/hello/testName?words=good 即可访问

>### 4、解析框架

	1、处理接受请求
		// ServeHTTP conforms to the http.Handler interface.
		func (engine *Engine) ServeHTTP(w http.ResponseWriter, req *http.Request) {
		    // 从池子里面取一个上下文，如果没有，新建一个
		    c := engine.pool.Get().(*Context)
		    // 重置Response
		    c.writermem.reset(w)
		    c.Request = req
		    c.reset()
		    engine.handleHTTPRequest(c)
		    // 处理完成，重用上下文
		    engine.pool.Put(c)
		}
		
		调用上下文的Next()调用处理方法。
		func (c *Context) Next() {
		    // 循环处理方法链，挨个处理
		    c.index++
		    for s := int8(len(c.handlers)); c.index < s; c.index++ {
		        c.handlers[c.index](c)
		    }
		}
	2、路由解析
		参考：http://www.okyes.me/2016/05/08/httprouter.html
	3、中间件
		func (group *RouterGroup) handle(httpMethod, relativePath string, handlers HandlersChain) IRoutes {
		    absolutePath := group.calculateAbsolutePath(relativePath)
		    // 把中间件的处理方法添加到处理方法链中
		    handlers = group.combineHandlers(handlers)
		    // 添加路由
		    group.engine.addRoute(httpMethod, absolutePath, handlers)
		    return group.returnObj()
		}
		
---

>## 二、pprof

---

    程序的性能优化无非就是对程序占用资源的优化。对于服务器而言，最重要的两项资源莫过于 CPU 和内存。性能优化，就是在对于不影响程序数据处理能力的情况下，我们通常要求程序的 CPU 的内存占用尽量低。反过来说，也就是当程序 CPU 和内存占用不变的情况下，尽量地提高程序的数据处理能力或者说是吞吐量。
    Go 的原生工具链中提供了非常多丰富的工具供开发者使用，其中包括 pprof。


---

>## 三、引用对象

---

    map
    slice

---