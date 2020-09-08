using Messaging_App.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace Messaging_App.Infrastructure.Persistence
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) {}

        public DbSet<User> Users { get; set; }
        
        public DbSet<Contact> Contacts { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
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
        }
    }
}