namespace Messaging_App.Infrastructure.WebRtcModels
{
    public class UserForCalls
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string ConnectionId { get; set; }
        public bool IsInCall { get; set; }
    }
}