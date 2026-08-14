# DSH学习笔记

    1、DSH提供了一个智能体框架/底座，这个架子是固定的，但是提供了很多接缝，给插件操作。
    2、在【添加自定义插件】中，apply中就可以操作接缝，注册能力，操作上下文
        1、ctx.on('session/created', (session) => {})
            注册事件回调
        2、ctx.effect
            关闭的时候调用返回的方法
        3、ctx.provide(name, impl) 
            自定义服务，给其他服务使用。下面是内置服务：
            1、ctx.tools.register(/* ... */)  
                注册工具
            2、ctx.llm.registerAdapter(names, adapter)
            3、ctx.sessions等等

# DSH的执行流程

    1、启动的时候，按照【注册插件】列表，执行apply
    2、对话的时候，根据apply注册的能力，和Agent模式，自主决策调用
    3、关闭的时候，按照【注册插件】列表，逆序执行effect

# 和ABP类比

    1、DSH和ABP都提供了一个底座。
    2、DSH的插件和ABP的模块类似
    
| DSH (DeepSeek Harness) | .NET ABP Framework | 说明 |
| :--- | :--- | :--- |
| **Plugin（插件）** | **AbpModule（模块）** | 系统的基本构建单元，整个系统由插件/模块组合而成 |
| `export const inject = [...]` | `[DependsOn(typeof(...))]` | 声明式模块依赖，由 IoC 容器自动拓扑排序并保证加载顺序 |
| `apply(ctx)` / `Service.start()` | `OnApplicationInitialization()` | 模块激活与初始化阶段 |
| `ctx.effect(() => disposer)` | `OnApplicationShutdown()` | 模块注销与资源反向释放 |
| `class extends Service` | `ISingletonDependency` | 发布单例服务供整个 Context 注入使用 |
| `ctx.waterfall`（瀑布流） | `Interceptor`（AOP 拦截器/中间件） | 洋葱模型拦截调用（鉴权、超时、过滤、重写） |
| **动态热插拔 (HMR)** | 编译期静态装配为主 | DSH 额外支持在运行时由模型或宿主动态增删插件 |

# 添加自定义插件

    1、定义一个插件，放在合适的位置,参考【Demos-chat-to-db】,要包括以下文件：
        1、package.json
            定义包的名字，入口，依赖等
        2、index.ts
            入口代码，其中apply方法，在启动的时候被调用。
            export function apply(ctx: Context, config: ChatToDbConfig): 
    2、C:\Users\Admin\.dsh\profiles\web\cordis.patch.yml中添加配置：

``` yml
- insert:
    - id: chat-to-db
      name: './plugins/chat-to-db' # 指向插件位置
      config:
        host: 127.0.0.1
        port: 3306
        user: root
        password: '123456'
        database: dsh_chat
```
    3、安装依赖
        npm install

## 自定义provide

    1、新增服务,有2种还是如下：

``` ts
// 方式1：插件 A：提供服务（apply 里装配一次）
export function apply(ctx) {
  ctx.provide('weather', {
    async query(city: string) { return await fetch(...) }
  }, () => /* check 可选：就绪谓词 */)
}
```

``` ts
// 方式2：插件 B：提供服务，提供record方法，通过插件的方式注入它
import { Service, type Context } from '@deepseek-ai/cordis'

declare module '@deepseek-ai/cordis' {
  interface Context {
    metrics: MetricsService
  }
}

export default class MetricsService extends Service {
  constructor(ctx: Context) {
    super(ctx, 'metrics')
  }

  record(event: string, value: number) { /* ... */ }
}

```

    2、使用插件

``` ts
// 插件 C：声明依赖 + 使用
export const inject =  ['weather', 'metrics']         // ← 声明依赖（≈ [DependsOn]）
export function apply(ctx) {
  // 依赖图保证：weather 提供后 B 才激活
  ctx.on('session/event', async (session, event) => {
    const w = await ctx.weather.query('北京')
    ctx.metrics.record('tool_call', 1)
  })
}
```