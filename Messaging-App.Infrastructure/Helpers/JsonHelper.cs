using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Messaging_App.Infrastructure.Helpers
{
    public static class JsonHelper
    {
        public static string Serialize<T>(this T obj, bool isUpperCamelCase)
        {
            var settings = new JsonSerializerSettings
            {
                ContractResolver = new CamelCasePropertyNamesContractResolver()
            };

            return isUpperCamelCase ? JsonConvert.SerializeObject(obj) : JsonConvert.SerializeObject(obj, settings);
        }
    }
}