using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Domain;
using Messaging_App.Infrastructure.Helpers;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface IAppRepository
    {
        void Add<T>(T entity) where T : class;
        void Delete<T>(T entity) where T : class;
        Task<bool> SaveAll();
        Task<PagedList<User>> GetUsers(UserParams userParams);
        Task<User> GetUser(int id);
        Task<Contact> GetContact(int userId, int friendId);
    }
}