using System.Collections.Generic;

namespace Messaging_App.Domain.Models
{
    public class UserMessageGroup
    {
        public int UserId { get; set; }
        public int GroupId { get; set; }
        public bool IsAdmin { get; set; }

        public virtual ICollection<User> Users { get; set; }
        public virtual ICollection<MessageGroup> MessageGroups { get; set; }
    }
}