using System.Collections.Generic;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using Messaging_App.Api.Helpers;
using Messaging_App.Domain.DTOs;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Parameters;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Messaging_App.Api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IAppRepository _appRepository;
        private readonly IMapper _mapper;
        private readonly IUserRepository _userRepository;

        public UsersController(IUserRepository userRepository, IMapper mapper, IAppRepository appRepository)
        {
            _userRepository = userRepository;
            _mapper = mapper;
            _appRepository = appRepository;
        }
        
        [HttpGet]
        [ProducesResponseType(typeof(UserForListDto), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetUsers([FromQuery] UserParams userParams)
        {
            var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value);

            userParams.UserId = currentUserId;
            
            var users = await _userRepository.GetUsers(userParams);

            var usersToReturn = _mapper.Map<IEnumerable<UserForListDto>>(users);

            Response.AddPagination(users.CurrentPage, users.PageSize, users.TotalCount, users.TotalPages);

            return Ok(usersToReturn);
        }
        
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(UserForSingleDto), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetUser(int id)
        {
            var user = await _userRepository.GetUser(id);

            var userToReturn = _mapper.Map<UserForSingleDto>(user);

            return Ok(userToReturn);
        }

        [HttpPost("{id}/friend/{friendId}")]
        [ProducesResponseType((int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.NotFound)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> AddFriend(int id, int friendId)
        {
            if (id != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();
            
            var friend = await _appRepository.GetContact(id, friendId);

            if (friend != null) return BadRequest("This user is already in your friend list");

            if (await _userRepository.GetUser(friendId) == null) return NotFound();

            friend = new Contact
            {
                UserId = id,
                ContactId = friendId
            };
            
            _appRepository.Add(friend);

            if (await _appRepository.SaveAll()) return Ok();

            return BadRequest("Failed to add new friend");
        }
    }
}