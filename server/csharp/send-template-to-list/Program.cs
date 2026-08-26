using System;
using System.IO;
using TryCourier;
using TryCourier.Models;
using TryCourier.Models.Send;
using DotNetEnv;

var envPath = System.IO.Path.Combine(System.IO.Directory.GetParent(System.IO.Directory.GetParent(System.IO.Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID");
var templateId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID");

var client = new CourierClient { ApiKey = apiKey! };

var parameters = new SendMessageParams
{
    Message = new Message
    {
        To = new UserRecipient { ListID = listId },
        Template = templateId
    }
};

var response = await client.Send.Message(parameters);

Console.WriteLine(response);

