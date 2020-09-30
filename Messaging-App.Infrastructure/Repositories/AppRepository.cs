using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Messaging_App.Infrastructure.Repositories
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

        public async Task<Contact> GetContact(int userId, int friendId)
        {
            return await _context.Contacts.FirstOrDefaultAsync(u => u.UserId == userId && u.ContactId == friendId);
        }

        public async Task<int> CreateMessagingGroup(bool isGroup, string name)
        {
            var group = new MessageGroup
            {
                IsGroup = isGroup,
                Name = name
            };

            var result = await _context.MessageGroups.AddAsync(group);
            await _context.SaveChangesAsync();

            return result.Entity.Id;
        }
    }
}