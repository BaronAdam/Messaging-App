using AutoMapper;
using Messaging_App.Domain;
using Messaging_App.Infrastructure.DTOs;

namespace Messaging_App.Api.Helpers
{
    public class AutoMapperProfiles : Profile
    {
        public AutoMapperProfiles()
        {
            CreateMap<User, UserForListDto>();
            CreateMap<User, UserForSingleDto>();
        }
    }
}