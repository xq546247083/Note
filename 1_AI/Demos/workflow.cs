// Copyright (c) Microsoft. All rights reserved.

using Microsoft.Agents.AI.Workflows;

public static class Program
{
    private static async Task Main()
    {
        // 创建一个把字符串转换为大写的方法，通过BindAsExecutor绑定为一个叫UppercaseExecutor的执行器
        Func<string, string> uppercaseFunc = s => s.ToUpperInvariant();
        var uppercase = uppercaseFunc.BindAsExecutor("UppercaseExecutor");

        // 新建有个反转字符串的执行器
        var reverse = new ReverseTextExecutor();

        // 初始化一个起点为uppercase的工作流构建者
        WorkflowBuilder builder = new(uppercase);
        // 把2个执行器连接起来，以reverse为总点
        builder.AddEdge(uppercase, reverse).WithOutputFrom(reverse);
        // 创建工作流
        var workflow = builder.Build();

        // 执行工作流并输出
        await using Run run = await InProcessExecution.RunAsync(workflow, "Hello, World!");
        foreach (WorkflowEvent evt in run.NewEvents)
        {
            if (evt is ExecutorCompletedEvent executorComplete)
            {
                Console.WriteLine($"{executorComplete.ExecutorId}: {executorComplete.Data}");
            }
        }
    }
}

internal sealed class ReverseTextExecutor() : Executor<string, string>("ReverseTextExecutor")
{
    public override ValueTask<string> HandleAsync(string message, IWorkflowContext context, CancellationToken cancellationToken = default)
    {
        return ValueTask.FromResult(string.Concat(message.Reverse()));
    }
}
