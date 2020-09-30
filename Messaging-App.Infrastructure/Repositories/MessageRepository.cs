using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Messaging_App.Infrastructure.Repositories
{
    public class MessageRepository : IMessageRepository
    {
        private readonly AppDbContext _context;

        public MessageRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Message> GetMessage(int id)
        {
            return await _context.Messages.FirstOrDefaultAsync(m => m.Id == id);
        }

        public async Task<IEnumerable<Message>> GetMessageThread(int userId, int groupId)
        {
            var messages = _context.Messages
                .Include(m => m.Sender)
                .Include(m => m.Group)
                .Where(m => m.GroupId == groupId && m.SenderId == userId)
                .OrderByDescending(m => m.DateSent)
                .AsQueryable();

            return await messages.ToListAsync();
        }

        public async Task<Message> GetLastMessage(int groupId)
        {
            return await _context.Messages
                .Where(m => m.GroupId == groupId)
                .Include(m => m.Sender)
                .OrderByDescending(m => m.DateSent)
                .FirstOrDefaultAsync();
        }
    }
}