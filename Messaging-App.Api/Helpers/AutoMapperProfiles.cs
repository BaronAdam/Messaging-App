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
        }
    }
}