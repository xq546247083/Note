golang 最佳实践
-----------------------
## 配置管理
在项目实际使用中建议采用xml作为配置文件。因为xml作为配置文件有以下几种优势:

1. 可以为所有节点添加注释。这些注释可以给程序部署人员提供详细的修改建议
2. xml文件结构有较强层次性，反序列化处理更加方便

[goutil](http://10.1.0.2/Moqikaka/goutil.git)里面已经包含了xml反序列化的工具包：goutil/configUtil。在项目里面使用时，建议如下：

1. 为配置建一个独立config包管理配置，并为每一类型建一个文件。如下所示:
~~~
-- Project
    -- src
        -- config
            -- init.go -----> 整个配置的初始化逻辑
            -- mysqlConfig.go ----->记录mysql相关配置数据
            -- redisConfig.go ----->记录redis相关配置数据
        -- 其他包
~~~

2. 配置信息初始化在[framework](http://10.1.0.2/Moqikaka/Framework.git)包中有对应的管理包:Framework/configMgr

3. **configUtil.XmlConfig.Unmarshal 第二个参数需要外部实例化对象。内部只是字段赋值**

## 分包建议
golang是以一个文件夹对外提供功能，和C#类比，一个包就是一个程序集（dll）。所以，包内子文件夹越多，越容易导致循环引用。所以建议建子文件夹需要慎重。

## 三方引用建议
默认情况下，三方包通过go get命令是安装在GOPATH/src/网站名/用户名/项目名。这导致项目引用存在很多不确定性，特别是不同项目需要引用相同三方包的不同的版本时，会特别无奈。而golang的**vendor**机制可以有效解决此问题，因此建议如下：

1. 公司内部构建了一个三方引用项目:[vendor](http://10.1.0.2/Moqikaka/vendor.git)。需要把此项目clone到**GOPATH/src/moqikaka**文件夹下，此时的文件夹结构如下:
~~~
-- GOPATH
  -- src
    -- moqikaka.com
      -- Priject1
      -- Prokect2
      -- verdor
        -- github.com
          -- go-sql-driver
          -- ......
        -- golang.org
          -- ......
~~~

2. 如需新增三方依赖包，请联系此项目的维护人员

3. 如果某个项目需要引用已存在的特殊版本三方包，则请在项目内部通过vendor引用

关于vendor的详细介绍请进-->[传送门](http://blog.csdn.net/hittata/article/details/52122071)

## golang陷阱及建议
### slice篇
slice详细介绍请进-->[传送门](http://blog.csdn.net/wangkai_123456/article/details/69676743)

1. 一般情况下，在make slice时，建议指定其cap参数值，也就是make([]类型,0,n)。因为默认情况下，当已分配的空间用完后，默认处理方式是直接创建len(slice)*2的空间，如果cap有指定，则按照cap进行增量分配。

2. 在已有的切面s1的基础上取出的切面s2仍然是指向s1的。有且仅在对s2或s1操作导致重新分配内存时，才会指向不同。

### map篇

1. map中的项是无序的，第一次for遍历的结果一般会和dier次for遍历的结果不同。（java和C#的遍历一般是固定顺序的）

### for篇

1. for遍历元素时不能对for的临时变量进行取地址操作。具体如下:
~~~
    func main() {
    	var s1 []*DType
    
    	dataMap := map[string]DType{
    		"1": DType{Name: "1"},
    		"2": DType{Name: "2"},
    		"3": DType{Name: "3"},
    		"4": DType{Name: "4"},
    		"5": DType{Name: "5"},
    		"6": DType{Name: "6"},
    		"7": DType{Name: "7"},
    	}
    
    	for _, val := range dataMap {
    		s1 = append(s1, &val)
    	}
    
    	for _, item := range s1 {
    		fmt.Println("Name:", item.Name)
    	}
    }
    type DType struct {
    	Name string
    }
    输出结果为:
        Name: 1
        Name: 1
        Name: 1
        Name: 1
        Name: 1
        Name: 1
        Name: 1
~~~

### defer篇
1. for里面不要defer，因为defer始终是在函数调用结束时才会被调用。如需defer，请使用匿名函数处理。例如:
~~~
	for _, val := range data {
		func() {
			val.LockObj.Lock()
			defer val.LockObj.Unlock() 

			val.Hello()
		}()
	}
~~~

2. 自己开的每一个协程均需要通过defer来recover异常，例如：
~~~
	go func() {
		defer func() {
			if err := recover(); err != nil {
				fmt.Println("异常了")
			}
		}()

		fmt.Println("Hello")
	}()
~~~
[FrameWork/goroutineMgr](http://10.1.0.2/Moqikaka/Framework.git)提供了协程管理函数。当某个协程异常退出时，会上报监控系统，使用示例:
~~~
		// 推送排行数据给游戏服务器
		go func() {
			// 处理goroutine数量
			registerName := "fairpvp.pushRankToGS"
			// goroutineMgr.Monitor(registerName) , 用于注册需要确保有且只有一个协程，如果没有协程，则会报警
			goroutineMgr.MonitorZero(registerName) //// 只是记录协程数量，不会进行报警
			defer goroutineMgr.ReleaseMonitor(registerName)

			pushRankToGS(redisMgr.Con_Hour_Rank)
		}()
~~~