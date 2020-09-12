using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using Messaging_App.Domain.DTOs;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Messaging_App.Api.Controllers
{
    [Authorize]
    [Route("api/users/{userId}/[controller]")]
    [ApiController]
    public class GroupController : ControllerBase
    {
        private readonly IMessageGroupRepository _groupRepository;
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;

        public GroupController(IMessageGroupRepository groupRepository, IMapper mapper, IUserRepository userRepository)
        {
            _groupRepository = groupRepository;
            _mapper = mapper;
            _userRepository = userRepository;
        }
        
        [HttpPost("add")]
        [ProducesResponseType(typeof(CreatedMessageGroupToReturnDto), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> AddGroup(int userId, MessageGroupForCreationDto messageGroupForCreationDto)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();

            var group = new MessageGroup
            {
                Name = messageGroupForCreationDto.Name,
                IsGroup = true
            };

            var created = await _groupRepository.Add(group);

            if (created == null) return BadRequest("There was an error while creating new group.");

            var toReturn =  _mapper.Map<CreatedMessageGroupToReturnDto>(created);

            if (await _groupRepository.CreateMessagingThread(new List<int> {userId}, created.Id, true)) return Ok(toReturn);

            return BadRequest("There was an error while creating new group.");
        }
        
        [HttpPost("add/{groupId}")]
        [ProducesResponseType((int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> AddUserToGroup(int userId, int groupId, AddingUsersToGroupDto newUsers)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();
        
            var userGroup = await _groupRepository.GetUserMessageGroup(userId, groupId);
        
            if (userGroup == null) return BadRequest("You cannot access this group.");
        
            if (!userGroup.IsAdmin) return Unauthorized();

            var contacts = await _userRepository.GetUserContacts(userId, false);
            var inContacts = await _userRepository.GetUserContacts(userId, true);

            newUsers.Ids = newUsers.Ids.Intersect(contacts).ToList();
            newUsers.Ids = newUsers.Ids.Intersect(inContacts).ToList();

            if (await _groupRepository.CreateMessagingThread(newUsers.Ids, groupId)) return Ok();

            return BadRequest("There was an error while adding users to group.");
        }

        [HttpPatch]
        [ProducesResponseType(typeof(MessageGroupForChangeNameDto), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> UpdateGroupName(int userId,
            MessageGroupForChangeNameDto messageGroupForChangeNameDto)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();
        
            var userGroup = await _groupRepository.GetUserMessageGroup(userId, messageGroupForChangeNameDto.Id);
        
            if (userGroup == null) return BadRequest("You cannot access this group.");
        
            if (!userGroup.IsAdmin) return Unauthorized();

            var group = _mapper.Map<MessageGroup>(messageGroupForChangeNameDto);

            var updated = await _groupRepository.Update(group);

            if (updated == null) return BadRequest("There was an error while changing group name.");

            return Ok(_mapper.Map<MessageGroupForChangeNameDto>(updated));
        }

        [HttpPatch("admin")]
        [ProducesResponseType((int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> ChangeAdminStatus(int userId, UserMessageGroupForAdminDto dto)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();
        
            var userGroup = await _groupRepository.GetUserMessageGroup(userId, dto.GroupId);
        
            if (userGroup == null) return BadRequest("You cannot access this group.");
        
            if (!userGroup.IsAdmin) return Unauthorized();

            var group = await _groupRepository.GetUserMessageGroup(dto.UserId, dto.GroupId);

            group.IsAdmin = !group.IsAdmin;

            if (await _groupRepository.UpdateAdmin(group)) return Ok();

            return BadRequest("Could not change user's admin permissions");
        }
    }
}