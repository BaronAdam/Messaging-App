using System;
using System.ComponentModel.DataAnnotations;

namespace Messaging_App.Domain.Models
{
    public class Message
    {
        public int Id { get; set; }
        public int SenderId { get; set; }
        public User Sender { get; set; }
        public int GroupId { get; set; }
        public MessageGroup Group { get; set; }
        [Encrypted]
        public string Content { get; set; }
        [Encrypted]
        public string Url { get; set; }
        public string PublicId { get; set; }
        public bool IsPhoto { get; set; }
        public DateTime DateSent { get; set; }
    }
}