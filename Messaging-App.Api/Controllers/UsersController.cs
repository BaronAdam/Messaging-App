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
        private readonly IMessageGroupRepository _groupRepository;

        public UsersController(IUserRepository userRepository, IMapper mapper, 
            IAppRepository appRepository, IMessageGroupRepository groupRepository)
        {
            _userRepository = userRepository;
            _mapper = mapper;
            _appRepository = appRepository;
            _groupRepository = groupRepository;
        }
        
        [HttpGet]
        [ProducesResponseType(typeof(UserForListDto), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetUsers([FromQuery] UserParameters userParameters)
        {
            var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value);

            userParameters.UserId = currentUserId;
            
            var users = await _userRepository.GetUsers(userParameters);

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

            return Ok(_mapper.Map<UserForSingleDto>(user));
        }
        
        [HttpGet("find/{searchPhrase}")]
        [ProducesResponseType(typeof(UserForSingleDto), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> FindUser (string searchPhrase)
        {
            var user = await _userRepository.GetUserByUsername(searchPhrase) ??
                       await _userRepository.GetUserByEmail(searchPhrase);

            if (user == null) return BadRequest("Could not find specified user");
            
            return Ok(_mapper.Map<UserForSingleDto>(user));
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

            if (friendId == id) return BadRequest("You cannot add yourself to your friend list");
            
            var contact = await _appRepository.GetContact(id, friendId);

            if (contact != null) return BadRequest("This user is already in your friend list");

            var friend = await _userRepository.GetUser(friendId);
            
            if (friend == null) return NotFound();

            contact = new Contact
            {
                UserId = id,
                ContactId = friendId
            };

            if (await _appRepository.GetContact(friendId, id) == null)
            {
                var user = await _userRepository.GetUser(id);
            
                var name = user.Name + " & " + friend.Name;

                var groupId = await _appRepository.CreateMessagingGroup(false, name);

                if (!await _groupRepository.CreateMessagingThread(new List<int> {id, friendId}, groupId, true))
                {
                    return BadRequest("There was an error while creating new group.");
                }
            }

            _appRepository.Add(contact);

            if (await _appRepository.SaveAll()) return Ok();

            return BadRequest("Failed to add new friend");
        }
    }
}