using System;

namespace Messaging_App.Domain.DTOs
{
    public class MessageToReturnDto
    {
        public int Id { get; set; }
        public int SenderId { get; set; }
        public string SenderName { get; set; }
        public int GroupId { get; set; }
        public string GroupName { get; set; }
        public string Content { get; set; }
        public DateTime DateSent { get; set; }
        public bool IsPhoto { get; set; }
        public string Url { get; set; }
        public string PublicId { get; set; }
    }
}