namespace Messaging_App.Domain.DTOs
{
    public class MessageGroupToReturnDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string LastSender { get; set; }
        public string LastMessage { get; set; }
    }
}