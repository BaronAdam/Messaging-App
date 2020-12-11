namespace Messaging_App.Infrastructure.WebRtcModels
{
    public class CallOffer
    {
        public UserForCalls Caller { get; set; }
        public UserForCalls Callee { get; set; }
    }
}