using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using Messaging_App.Infrastructure.DTOs;
using Messaging_App.Infrastructure.Persistence;
using Microsoft.AspNetCore.Mvc;


namespace Messaging_App.Api.Controllers
{
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
        public async Task<IActionResult> GetUsers()
        {
            var users = await _repository.GetUsers();

            var usersToReturn = _mapper.Map<IEnumerable<UserForListDto>>(users);

            return Ok(usersToReturn);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetUser(int id)
        {
            var user = await _repository.GetUser(id);

            var userToReturn = _mapper.Map<UserForSingleDto>(user);

            return Ok(userToReturn);
        }
    }
}