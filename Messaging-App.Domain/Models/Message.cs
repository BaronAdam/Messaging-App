using System;

namespace Messaging_App.Domain.Models
{
    public class Message
    {
        public int Id { get; set; }
        public int SenderId { get; set; }
        public User Sender { get; set; }
        public int GroupId { get; set; }
        public MessageGroup Group { get; set; }
        public string Content { get; set; }
        public DateTime DateSent { get; set; }
        public bool IsRead { get; set; }
        public DateTime? DateRead { get; set; }
    }
}