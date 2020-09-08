using System.Threading.Tasks;
using Messaging_App.Domain.Models;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface IAuthRepository
    {
        Task<User> Register(User user, string password);
        Task<User> Login(string username, string password);
        Task<bool> UserExists(string username);
        Task<bool> EmailExists(string email);
    }
}