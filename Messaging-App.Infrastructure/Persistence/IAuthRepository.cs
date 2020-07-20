using System.Threading.Tasks;
using Messaging_App.Domain;

namespace Messaging_App.Infrastructure.Persistence
{
    public interface IAuthRepository
    {
        Task<User> Register(User user, string password);
        Task<User> Login(string username, string email, string password);
        Task<bool> UserExists(string username);
        Task<bool> EmailExists(string email);
    }
}