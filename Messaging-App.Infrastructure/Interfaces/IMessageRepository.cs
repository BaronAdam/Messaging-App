using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Helpers;
using Messaging_App.Infrastructure.Parameters;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface IMessageRepository
    {
        Task<Message> GetMessage(int id);
        Task<PagedList<Message>> GetMessageThread(int userId, int groupId, MessageParameters messageParameters);
        Task<Message> GetLastMessage(int groupId);
    }
}