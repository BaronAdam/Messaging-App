using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using Messaging_App.Api.Helpers;
using Messaging_App.Domain.DTOs;
using Messaging_App.Domain.Models;
using Messaging_App.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace Messaging_App.Api.Controllers
{
    [Authorize]
    [Route("api/users/{userId}/[controller]")]
    [ApiController]
    public class MessagesController : ControllerBase
    {
        private readonly IAppRepository _appRepository;
        private readonly Cloudinary _cloudinary;
        private readonly IMessageGroupRepository _groupRepository;
        private readonly IMapper _mapper;
        private readonly IMessageRepository _messageRepository;
        private readonly IUserRepository _userRepository;

        public MessagesController(IMessageRepository messageRepository, IMapper mapper, IAppRepository appRepository,
            IMessageGroupRepository groupRepository, IUserRepository userRepository,
            IOptions<CloudinarySettings> cloudinaryOptions)
        {
            _messageRepository = messageRepository;
            _mapper = mapper;
            _appRepository = appRepository;
            _groupRepository = groupRepository;
            _userRepository = userRepository;

            var account = new Account(
                cloudinaryOptions.Value.ApiKey,
                cloudinaryOptions.Value.ApiKey,
                cloudinaryOptions.Value.ApiSecret);

            _cloudinary = new Cloudinary(account);
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
        public async Task<IActionResult> GetMessageThread(int userId, int groupId)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();

            if (await _groupRepository.GetUserMessageGroup(userId, groupId) == null) return Unauthorized();

            var messages = await _messageRepository.GetMessageThread(userId, groupId);

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
            messageForCreationDto.MessageSent = DateTime.Now;

            var group = await _groupRepository.GetMessageGroup(messageForCreationDto.GroupId);

            if (group == null) return BadRequest("Could not find user/group");

            var message = _mapper.Map<Message>(messageForCreationDto);

            if (messageForCreationDto.IsPhoto)
            {
                messageForCreationDto.Content = null;

                var file = messageForCreationDto.File;

                if (!(file.Length > 0)) return BadRequest("There was an error with the file");

                await using var stream = file.OpenReadStream();
                var uploadParameters = new ImageUploadParams
                {
                    File = new FileDescription(Guid.NewGuid().ToString(), stream),
                    Transformation = new Transformation().Quality(50)
                };
                var result = _cloudinary.Upload(uploadParameters);

                messageForCreationDto.Url = result.Url.ToString();
                messageForCreationDto.PublicId = result.PublicId;
            }

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

                string groupName;

                if (!messageGroup.IsGroup)
                {
                    var ids = await _groupRepository.GetUserIdsForGroup(messageGroup.Id);

                    var user = await _userRepository.GetUser(ids.First(i => i != userId));

                    groupName = user.Name;
                }
                else
                {
                    groupName = messageGroup.Name;
                }

                var content = message.Content;

                if (content.Length > 60) content = content.Substring(0, 27) + "...";

                var lastName = message.Sender.Id == userId ? "You" : message.Sender.Name;

                var group = new MessageGroupToReturnDto
                {
                    Id = messageGroup.Id,
                    Name = groupName,
                    LastMessage = content,
                    LastSender = lastName,
                    LastSent = message.DateSent
                };

                groups.Add(group);
            }

            var orderedGroups = groups.OrderByDescending(g => g.LastSent);

            return Ok(orderedGroups);
        }
    }
}