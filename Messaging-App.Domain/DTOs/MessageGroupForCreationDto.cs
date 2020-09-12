namespace Messaging_App.Domain.DTOs
{
    public class MessageGroupForCreationDto
    {
        public string Name { get; set; }
        public bool IsGroup { get; set; }

        public MessageGroupForCreationDto()
        {
            IsGroup = true;
        }
    }
}