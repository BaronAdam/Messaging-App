using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Messaging_App.Domain;
using Messaging_App.Infrastructure.Helpers;
using Messaging_App.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Messaging_App.Infrastructure.Persistence
{
    public class AppRepository : IAppRepository
    {
        private readonly AppDbContext _context;

        public AppRepository(AppDbContext context)
        {
            _context = context;
        }

        public void Add<T>(T entity) where T : class
        {
            _context.Add(entity);
        }

        public void Delete<T>(T entity) where T : class
        {
            _context.Remove(entity);
        }

        public async Task<bool> SaveAll()
        {
            return await _context.SaveChangesAsync() > 0;
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

        public async Task<Contact> GetContact(int userId, int friendId)
        {
            return await _context.Contacts.FirstOrDefaultAsync(u => u.UserId == userId && u.ContactId == friendId);
        }
    }
}