using System.Collections.Generic;

namespace Messaging_App.Domain.DTOs
{
    public class AddingUsersToGroupDto
    {
        public IEnumerable<int> Ids { get; set; }
    }
}