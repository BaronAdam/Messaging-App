using System.Threading.Tasks;
using Messaging_App.Domain;
using Messaging_App.Infrastructure.DTOs;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.AspNetCore.Mvc;

namespace Messaging_App.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthRepository _repository;

        public AuthController(IAuthRepository repository)
        {
            _repository = repository;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(UserForRegisterDto userForRegisterDto)
        {
            if (await _repository.UserExists(userForRegisterDto.Username))
            {
                return BadRequest("Username already exists");
            }

            if (await _repository.EmailExists(userForRegisterDto.Email))
            {
                return BadRequest("Email already registered");
            }

            var userToCreate = new User
            {
                Username = userForRegisterDto.Username,
                Email = userForRegisterDto.Email
            };

            var createdUser = await _repository.Register(userToCreate, userForRegisterDto.Password);

            return StatusCode(201);
        }
    }
}