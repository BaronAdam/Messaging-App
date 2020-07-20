using Messaging_App.Domain;
using Microsoft.EntityFrameworkCore;

namespace Messaging_App.Infrastructure.Persistence
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) {}

        public DbSet<User> Users { get; set; }
    }
}