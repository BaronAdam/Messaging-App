using System.Collections.Generic;

namespace Messaging_App.Domain
{
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Name { get; set; }
        public byte[] PasswordHash { get; set; }
        public byte[] PasswordSalt { get; set; }
        
        public virtual ICollection<Contact> Contacts1 { get; set; }
        public virtual ICollection<Contact> Contacts2 { get; set; }
    }
}