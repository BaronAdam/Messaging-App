using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Helpers;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface IMessageRepository
    {
        Task<Message> GetMessage(int id);
        Task<PagedList<Message>> GetMessagesForUser();
        Task<IEnumerable<Message>> GetMessageThread(int userId, int groupId);
        Task<MessageGroup> GetMessageGroup(int id);
    }
}