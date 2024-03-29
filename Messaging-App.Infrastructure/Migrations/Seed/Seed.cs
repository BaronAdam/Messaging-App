﻿using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Persistence;

namespace Messaging_App.Infrastructure.Migrations.Seed
{
    public class Seed
    {
        public static void SeedUsers(AppDbContext context)
        {
            if (!context.Users.Any())
            {
                var userData = File
                    .ReadAllText("../Messaging-App.Infrastructure/Migrations/Seed/UserData.json");
                var users = JsonSerializer.Deserialize<List<User>>(userData);
                foreach (var user in users)
                {
                    CreatePasswordHash("password", out var passwordHash, out var passwordSalt);

                    user.PasswordHash = passwordHash;
                    user.PasswordSalt = passwordSalt;
                    context.Users.Add(user);
                }

                context.SaveChanges();
            }
        }

        private static void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
        {
            using (var hmac = new HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(Encoding.UTF8.GetBytes(password));
            }
        }
    }
}