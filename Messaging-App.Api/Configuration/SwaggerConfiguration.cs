using System.Collections.Generic;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;

namespace Messaging_App.Api.Configuration
{
    public static class SwaggerConfiguration
    {
        public static void ConfigureSwagger(this IServiceCollection services)
        {
            services.AddSwaggerGen(options =>
            {
                options.SwaggerDoc("v1", new OpenApiInfo {Title = "MessagingApp", Version = "v1"});

                options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    Description = "Enter 'Bearer {token}'",
                    In = ParameterLocation.Header,
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer"
                });

                options.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            },
                            Scheme = "oauth2",
                            Name = "Bearer",
                            In = ParameterLocation.Header
                        },
                        new List<string>()
                    }
                });
            });
        }
    }
}