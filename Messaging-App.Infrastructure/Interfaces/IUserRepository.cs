using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Helpers;
using Messaging_App.Infrastructure.Parameters;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface IUserRepository
    {
        Task<PagedList<User>> GetUsers(UserParameters userParameters);
        Task<User> GetUser(int id);
        Task<IEnumerable<int>> GetUserContacts(int id, bool inContacts);
    }
}