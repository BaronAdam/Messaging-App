using System.ComponentModel.DataAnnotations;

namespace Messaging_App.Domain.DTOs
{
    public class MessageGroupForCreationDto
    {
        public MessageGroupForCreationDto()
        {
            IsGroup = true;
        }

        [Required] public string Name { get; set; }

        public bool IsGroup { get; set; }
    }
}