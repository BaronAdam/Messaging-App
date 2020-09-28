using System;
using Microsoft.AspNetCore.Http;

namespace Messaging_App.Domain.DTOs
{
    public class MessageForCreationDto
    {
        public int SenderId { get; set; }
        public int GroupId { get; set; }
        public DateTime MessageSent { get; set; }
        public string Content { get; set; }
        public bool IsPhoto { get; set; }
        public string Url { get; set; }
        public IFormFile File { get; set; }
        public string PublicId { get; set; }
    }
}