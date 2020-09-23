using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Messaging_App.Infrastructure.Repositories
{
    public class MessageGroupRepository : IMessageGroupRepository
    {
        private readonly AppDbContext _context;

        public MessageGroupRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<MessageGroup> GetMessageGroup(int id)
        {
            return await _context.MessageGroups.FirstOrDefaultAsync(g => g.Id == id);
        }
        
        public async Task<IEnumerable<MessageGroup>> GetAllMessageGroupsForUser(int userId)
        {
            var userMessageGroups = await _context.UserMessageGroups.Where(u => u.UserId == userId).ToListAsync();

            var groups = new List<MessageGroup>();
            
            foreach (var userMessageGroup in userMessageGroups)
            {
                groups.Add(await _context.MessageGroups.FirstOrDefaultAsync(g => g.Id == userMessageGroup.GroupId));
            }

            return groups;
        }
        
        public async Task<UserMessageGroup> GetUserMessageGroup(int userId, int groupId)
        {
            return await _context.UserMessageGroups.FirstOrDefaultAsync(g =>
                g.UserId == userId && g.GroupId == groupId);
        }
        
        public async Task<bool> CreateMessagingThread(IEnumerable<int> userIds, int groupId, bool makeAdmins = false)
        {
            if (await GetMessageGroup(groupId) == null) return false;

            foreach (var id in userIds)
            {
                var entity = new UserMessageGroup
                {
                    GroupId = groupId,
                    UserId = id,
                    IsAdmin = makeAdmins
                };
                
                if (await GetUserMessageGroup(id, groupId) != null) continue;

                await _context.UserMessageGroups.AddAsync(entity);
            }

            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<MessageGroup> Add(MessageGroup messageGroup)
        {
            var created = await _context.MessageGroups.AddAsync(messageGroup);
            await _context.SaveChangesAsync();

            return created.Entity;
        }

        public async Task<MessageGroup> Update(MessageGroup messageGroup)
        {
            var updated = _context.MessageGroups.Update(messageGroup);
            await _context.SaveChangesAsync();

            return updated.Entity;
        }

        public async Task<bool> UpdateAdmin(UserMessageGroup userMessageGroup)
        {
            _context.UserMessageGroups.Update(userMessageGroup);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<IEnumerable<int>> GetUserIdsForGroup(int groupId)
        {
            var groups = await _context.UserMessageGroups.Where(g => g.GroupId == groupId).ToListAsync();

            IEnumerable<int> ids = new List<int>();
            
            foreach (var group in groups)
            {
                ids = ids.Append(group.UserId);
            }

            return ids;
        }
    }
}