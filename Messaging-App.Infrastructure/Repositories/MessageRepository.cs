using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Helpers;
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

        public async Task<PagedList<Message>> GetMessagesForUser()
        {
            throw new System.NotImplementedException();
        }

        public async Task<IEnumerable<Message>> GetMessageThread(int userId, int groupId)
        {
            throw new System.NotImplementedException();
        }

        public async Task<MessageGroup> GetMessageGroup(int id)
        {
            return await _context.MessageGroups.FirstOrDefaultAsync(g => g.Id == id);
        }
    }
}