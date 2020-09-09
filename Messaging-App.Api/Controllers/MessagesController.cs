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
    public class MessagesController : ControllerBase
    {
        private readonly IMessageRepository _messageRepository;
        private IAppRepository _appRepository;
        private readonly IMapper _mapper;

        public MessagesController(IMessageRepository messageRepository, IMapper mapper, IAppRepository appRepository)
        {
            _messageRepository = messageRepository;
            _mapper = mapper;
            _appRepository = appRepository;
        }
        
        [HttpGet("{id}", Name = "GetMessage")]
        [ProducesResponseType((int) HttpStatusCode.OK)]
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

        [HttpPost]
        [ProducesResponseType((int) HttpStatusCode.Created)]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> CreateMessage(int userId, MessageForCreationDto messageForCreationDto)
        {
            if (userId != int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value)) return Unauthorized();

            messageForCreationDto.SenderId = userId;

            var group = await _messageRepository.GetMessageGroup(messageForCreationDto.GroupId);

            if (group == null) return BadRequest("Could not find user/group");

            var message = _mapper.Map<Message>(messageForCreationDto);
            
            _appRepository.Add(message);

            if (!await _appRepository.SaveAll()) return StatusCode((int) HttpStatusCode.InternalServerError);
            
            var messageToReturn = _mapper.Map<MessageForCreationDto>(message);
            return CreatedAtRoute("GetMessage", new {userId, id = message.Id}, messageToReturn);
        }
    }
}