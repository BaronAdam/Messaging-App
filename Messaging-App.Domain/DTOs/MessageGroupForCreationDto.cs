using System.ComponentModel.DataAnnotations;

namespace Messaging_App.Domain.DTOs
{
    public class MessageGroupForCreationDto
    {
        [Required]
        public string Name { get; set; }
        public bool IsGroup { get; set; }

        public MessageGroupForCreationDto()
        {
            IsGroup = true;
        }
    }
}