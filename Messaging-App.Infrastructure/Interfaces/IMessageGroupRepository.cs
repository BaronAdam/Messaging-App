using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface IMessageGroupRepository
    {
        Task<MessageGroup> GetMessageGroup(int id);
        Task<UserMessageGroup> GetUserMessageGroup(int userId, int groupId);
        Task<IEnumerable<MessageGroup>> GetAllMessageGroupsForUser(int userId);
        Task<bool> CreateMessagingThread(IEnumerable<int> userIds, int groupId, bool makeAdmins = false);
        Task<MessageGroup> Add(MessageGroup messageGroup);
        Task<MessageGroup> Update(MessageGroup messageGroup);
        Task<bool> UpdateAdmin(UserMessageGroup userMessageGroup);
        Task<IEnumerable<int>> GetUserIdsForGroup(int groupId);
        Task<IEnumerable<int>> GetAdminsForGroup(int groupId);
        Task<int> CreateMessagingGroup(bool isGroup, string name);
    }
}