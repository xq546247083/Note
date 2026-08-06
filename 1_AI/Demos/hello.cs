// Copyright (c) Microsoft. All rights reserved.

// This sample shows how to create and use a simple AI agent with DeepSeek as the backend.

using System.ClientModel;
using OpenAI;
using OpenAI.Chat;

var apiKey = "sk-4f17ba55c9124e80aa9d9a4b19aea80e";
var endpoint = "https://api.deepseek.com";
var model = "deepseek-chat";

// Create an OpenAI client configured for the DeepSeek API endpoint.
var clientOptions = new OpenAIClientOptions { Endpoint = new Uri(endpoint) };
var client = new OpenAIClient(new ApiKeyCredential(apiKey), clientOptions);

var agent = client
    .GetChatClient(model)
    .AsAIAgent(instructions: "你是一个幽默的助手，擅长讲笑话。", name: "Joker");

Console.OutputEncoding = System.Text.Encoding.UTF8;

Console.Clear();
Console.WriteLine("=============================================");
Console.WriteLine("        DeepSeek AI 幽默助手 (Joker)         ");
Console.WriteLine("=============================================");
Console.WriteLine();

while (true)
{
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine("按 [Enter] 键生成笑话:");
    Console.ResetColor();

    Console.ReadLine();
    Console.WriteLine();
    Console.ForegroundColor = ConsoleColor.Green;
    Console.WriteLine("【DeepSeek 回复】:");
    Console.ResetColor();

    Console.ForegroundColor = ConsoleColor.DarkYellow;
    await foreach (var update in agent.RunStreamingAsync("给我讲一个笑话。"))
    {
        Console.Write(update);
    }

    Console.WriteLine();
    Console.WriteLine();
    Console.WriteLine("---------------------------------------------");
    Console.WriteLine();
}