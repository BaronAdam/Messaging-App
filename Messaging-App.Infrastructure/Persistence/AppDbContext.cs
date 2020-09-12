using System;
using Messaging_App.Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.DataEncryption;
using Microsoft.EntityFrameworkCore.DataEncryption.Providers;
using Microsoft.Extensions.Configuration;

namespace Messaging_App.Infrastructure.Persistence
{
    public class AppDbContext : DbContext
    {
        private readonly IEncryptionProvider _provider;

        public AppDbContext(DbContextOptions<AppDbContext> options, IConfiguration configuration) : base(options)
        {
            var encryptionKey = Convert.FromBase64String(configuration.GetSection("AppSettings:EncryptionKey").Value);
            var initializationVector =
                Convert.FromBase64String(configuration.GetSection("AppSettings:EncryptionIV").Value);
            _provider = new AesProvider(encryptionKey, initializationVector);
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Contact> Contacts { get; set; }
        public DbSet<MessageGroup> MessageGroups { get; set; }
        public DbSet<UserMessageGroup> UserMessageGroups { get; set; }
        public DbSet<Message> Messages { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.UseEncryption(_provider);
            
            modelBuilder.Entity<Contact>()
                .HasKey(k => new {k.UserId, k.ContactId});

            modelBuilder.Entity<Contact>()
                .HasOne(u => u.User)
                .WithMany(u => u.Contacts2)
                .HasForeignKey(u => u.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Contact>()
                .HasOne(u => u.Friend)
                .WithMany(u => u.Contacts1)
                .HasForeignKey(u => u.ContactId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<UserMessageGroup>()
                .HasKey(k => new {k.UserId, k.GroupId});
        }
    }
}