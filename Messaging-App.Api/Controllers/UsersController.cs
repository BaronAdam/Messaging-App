using System.Collections.Generic;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using Messaging_App.Domain;
using Messaging_App.Domain.DTOs;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;


namespace Messaging_App.Api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IAppRepository _repository;
        private readonly IMapper _mapper;

        public UsersController(IAppRepository repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }
        
        [HttpGet]
        [ProducesResponseType(typeof(UserForListDto), 200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _repository.GetUsers();

            var usersToReturn = _mapper.Map<IEnumerable<UserForListDto>>(users);

            return Ok(usersToReturn);
        }
        
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(UserForSingleDto), 200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetUser(int id)
        {
            var user = await _repository.GetUser(id);

            var userToReturn = _mapper.Map<UserForSingleDto>(user);

            return Ok(userToReturn);
        }

        [HttpPost("{id}/friend/{friendId}")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> AddFriend(int id, int friendId)
        {
            if (id != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();
            
            var friend = await _repository.GetContact(id, friendId);

            if (friend != null) return BadRequest("This user is already in your friend list");

            if (await _repository.GetUser(friendId) == null) return NotFound();

            friend = new Contact
            {
                UserId = id,
                ContactId = friendId
            };
            
            _repository.Add<Contact>(friend);

            if (await _repository.SaveAll()) return Ok();

            return BadRequest("Failed to add new friend");
        }
    }
}