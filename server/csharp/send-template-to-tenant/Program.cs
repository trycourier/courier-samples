using System;
using System.IO;
using Courier;
using Courier.Models;
using Courier.Models.Send;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var tenantId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID");
var templateId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID");

var client = new CourierClient { APIKey = apiKey! };

var parameters = new SendMessageParams
{
    Message = new Message
    {
        To = new UserRecipient { TenantID = tenantId },
        Template = templateId
    }
};

var response = await client.Send.Message(parameters);

Console.WriteLine(response);

