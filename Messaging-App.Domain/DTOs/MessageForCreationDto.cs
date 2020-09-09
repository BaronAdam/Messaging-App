using System;

namespace Messaging_App.Domain.DTOs
{
    public class MessageForCreationDto
    {
        public int SenderId { get; set; }
        public int GroupId { get; set; }
        public DateTime MessageSent { get; set; }
        public string Content { get; set; }

        public MessageForCreationDto()
        {
            MessageSent = DateTime.Now;
        }
    }
}