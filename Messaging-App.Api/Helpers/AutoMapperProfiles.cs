using AutoMapper;
using Messaging_App.Domain.DTOs;
using Messaging_App.Domain.Models;

namespace Messaging_App.Api.Helpers
{
    public class AutoMapperProfiles : Profile
    {
        public AutoMapperProfiles()
        {
            CreateMap<User, UserForListDto>();
            CreateMap<User, UserForSingleDto>();
            CreateMap<MessageForCreationDto, Message>()
                .ForMember(d => d.DateSent, o => o.MapFrom(s => s.MessageSent));
            CreateMap<Message, MessageToReturnDto>()
                .ForMember(d => d.SenderName, o => o.MapFrom(s => s.Sender.Name))
                .ForMember(d => d.GroupName, o => o.MapFrom(s => s.Group.Name));
            CreateMap<MessageGroup, CreatedMessageGroupToReturnDto>();
            CreateMap<MessageGroupForChangeNameDto, MessageGroup>().ReverseMap();
        }
    }
}