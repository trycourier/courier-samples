using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using TryCourier;
using TryCourier.Models;
using TryCourier.Models.Send;
using DotNetEnv;

var envPath = System.IO.Path.Combine(System.IO.Directory.GetParent(System.IO.Directory.GetParent(System.IO.Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var email = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL");
var templateId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID");

var client = new CourierClient { ApiKey = apiKey! };

var parameters = new SendMessageParams
{
    Message = new Message
    {
        To = new UserRecipient { Email = email },
        Template = templateId,
        Data = new Dictionary<string, JsonElement>
        {
            { "name", JsonSerializer.SerializeToElement("Your Name") }
        }
    }
};

var response = await client.Send.Message(parameters);

Console.WriteLine(response);

