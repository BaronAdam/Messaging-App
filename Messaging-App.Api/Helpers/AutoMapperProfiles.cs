using AutoMapper;
using Messaging_App.Domain.DTOs;
using Messaging_App.Domain.Models;
using Message = Renci.SshNet.Messages.Message;

namespace Messaging_App.Api.Helpers
{
    public class AutoMapperProfiles : Profile
    {
        public AutoMapperProfiles()
        {
            CreateMap<User, UserForListDto>();
            CreateMap<User, UserForSingleDto>();
            CreateMap<MessageForCreationDto, Message>().ReverseMap();
        }
    }
}