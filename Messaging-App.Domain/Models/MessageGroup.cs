using System.Collections.Generic;

namespace Messaging_App.Domain.Models
{
    public class MessageGroup
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsGroup { get; set; }

        public virtual ICollection<Message> Messages { get; set; }
    }
}