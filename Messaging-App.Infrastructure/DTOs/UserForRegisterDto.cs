using System.ComponentModel.DataAnnotations;

namespace Messaging_App.Infrastructure.DTOs
{
    public class UserForRegisterDto
    {
        [Required]
        public string Username { get; set; }
        
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        
        [Required]
        [StringLength(40, MinimumLength = 8, ErrorMessage = "You must specify password between 8 and 40 characters")]
        public string Password { get; set; }
        
        [Required] 
        public string Name { get; set; }
    }
}