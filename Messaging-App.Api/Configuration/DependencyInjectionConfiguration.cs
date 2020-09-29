using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Repositories;
using Microsoft.Extensions.DependencyInjection;

namespace Messaging_App.Api.Configuration
{
    public static class DependencyInjectionConfiguration
    {
        public static void ConfigureDependencyInjection(this IServiceCollection services)
        {
            services.AddScoped<IAuthRepository, AuthRepository>();

            services.AddScoped<IAppRepository, AppRepository>();

            services.AddScoped<IUserRepository, UserRepository>();

            services.AddScoped<IMessageRepository, MessageRepository>();

            services.AddScoped<IMessageGroupRepository, MessageGroupRepository>();
        }
    }
}