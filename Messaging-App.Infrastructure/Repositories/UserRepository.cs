using System.Linq;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Helpers;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Parameters;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Messaging_App.Infrastructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly AppDbContext _context;

        public UserRepository(AppDbContext context)
        {
            _context = context;
        }
        
        public async Task<PagedList<User>> GetUsers(UserParams userParams)
        {
            var users = _context.Users.AsQueryable();

            users = users.Where(u => u.Id != userParams.UserId);

            return await PagedList<User>.CreateAsync(users, userParams.PageNumber, userParams.PageSize);
        }

        public async Task<User> GetUser(int id)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == id);

            return user;
        }
    }
}