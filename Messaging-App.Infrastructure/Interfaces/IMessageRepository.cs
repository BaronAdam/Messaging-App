using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface IMessageRepository
    {
        Task<Message> GetMessage(int id);
        Task<IEnumerable<Message>> GetMessageThread(int userId, int groupId);
        Task<Message> GetLastMessage(int groupId);
    }
}