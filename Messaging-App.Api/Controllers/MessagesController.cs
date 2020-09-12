using System;
using System.Collections.Generic;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using Messaging_App.Domain.DTOs;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.Parameters;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Messaging_App.Api.Controllers
{
    [Authorize]
    [Route("api/users/{userId}/[controller]")]
    [ApiController]
    public class MessagesController : ControllerBase
    {
        private readonly IMessageRepository _messageRepository;
        private readonly IMessageGroupRepository _groupRepository;
        private readonly IAppRepository _appRepository;
        private readonly IMapper _mapper;

        public MessagesController(IMessageRepository messageRepository, IMapper mapper, IAppRepository appRepository,
            IMessageGroupRepository groupRepository)
        {
            _messageRepository = messageRepository;
            _mapper = mapper;
            _appRepository = appRepository;
            _groupRepository = groupRepository;
        }
        
        [HttpGet("{id}", Name = "GetMessage")]
        [ProducesResponseType(typeof(Message), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.NotFound)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetMessage(int userId, int id)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();

            var message = await _messageRepository.GetMessage(id);

            if (message == null) return NotFound();

            return Ok(message);
        }

        [HttpGet("thread/{groupId}")]
        [ProducesResponseType(typeof(IEnumerable<MessageToReturnDto>), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetMessageThread(int userId, int groupId, 
            [FromQuery] MessageParameters messageParameters)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();

            if (await _groupRepository.GetUserMessageGroup(userId, groupId) == null) return Unauthorized();

            var messages = await _messageRepository.GetMessageThread(userId, groupId, messageParameters);

            var messageThread = _mapper.Map<IEnumerable<MessageToReturnDto>>(messages);

            return Ok(messageThread);
        }

        [HttpPost]
        [ProducesResponseType(typeof(MessageToReturnDto), (int) HttpStatusCode.Created)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> CreateMessage(int userId, MessageForCreationDto messageForCreationDto)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();

            messageForCreationDto.SenderId = userId;

            var group = await _groupRepository.GetMessageGroup(messageForCreationDto.GroupId);

            if (group == null) return BadRequest("Could not find user/group");

            var message = _mapper.Map<Message>(messageForCreationDto);
            
            _appRepository.Add(message);

            if (!await _appRepository.SaveAll()) return StatusCode((int) HttpStatusCode.InternalServerError);
            
            var messageToReturn = _mapper.Map<MessageToReturnDto>(message);
            return CreatedAtRoute("GetMessage", new {userId, id = message.Id}, messageToReturn);
        }
        
        [HttpGet]
        [ProducesResponseType(typeof(List<MessageGroupToReturnDto>), (int) HttpStatusCode.OK)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetAllMessageGroupsForUser(int userId)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();

            var messageGroups = await _groupRepository.GetAllMessageGroupsForUser(userId);

            var groups = new List<MessageGroupToReturnDto>();
            
            foreach (var messageGroup in messageGroups)
            {
                var message = await _messageRepository.GetLastMessage(messageGroup.Id) ?? new Message
                {
                    Content = string.Empty,
                    Sender = new User
                    {
                        Name = string.Empty
                    }
                };

                var content = message.Content;

                if (content.Length > 60)
                {
                    content = content.Substring(0, 57) + "...";
                }

                var group = new MessageGroupToReturnDto
                {
                    Id = messageGroup.Id,
                    Name = messageGroup.Name,
                    LastMessage = content,
                    LastSender = message.Sender.Name
                };

                groups.Add(group);
            }

            return Ok(groups);
        }
    }
}