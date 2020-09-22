using System.Collections.Generic;
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
        
        public async Task<PagedList<User>> GetUsers(UserParameters userParameters)
        {
            var users = _context.Users.AsQueryable();

            users = users.Where(u => u.Id != userParameters.UserId);

            if (userParameters.Contacts)
            {
                var userContacts = await GetUserContacts(userParameters.UserId, userParameters.InContacts);
                users = users.Where(u => userContacts.Contains(u.Id));
            }

            if (userParameters.InContacts)
            {
                var userInContacts = await GetUserContacts(userParameters.UserId, userParameters.InContacts);
                users = users.Where(u => userInContacts.Contains(u.Id));
            }

            return await PagedList<User>.CreateAsync(users, userParameters.PageNumber, userParameters.PageSize);
        }

        public async Task<IEnumerable<int>> GetUserContacts(int id, bool inContacts)
        {
            var user = await _context.Users.Include(x => x.Contacts1).Include(x => x.Contacts2)
                .FirstOrDefaultAsync(u => u.Id == id);

            return inContacts
                ? user.Contacts1.Where(u => u.ContactId == id).Select(i => i.UserId)
                : user.Contacts2.Where(u => u.UserId == id).Select(i => i.ContactId);
        }

        public async Task<User> GetUserByEmail(string email)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);

            return user;
        }

        public async Task<User> GetUserByUsername(string username)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);

            return user;
        }

        public async Task<User> GetUser(int id)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == id);

            return user;
        }
    }
}