namespace Messaging_App.Domain.Models
{
    public class Contact
    {
        public int UserId { get; set; }
        public int ContactId { get; set; }
        public User User { get; set; }
        public User Friend { get; set; }
    }
}