using System.Collections.Generic;
using System.Threading.Tasks;
using Messaging_App.Infrastructure.WebRtcModels;

namespace Messaging_App.Infrastructure.Interfaces
{
    public interface ICallerHub
    {
        Task UpdateUserList(List<UserForCalls> users);
        Task CallAccepted(UserForCalls acceptingUser);
        Task CallDeclined(UserForCalls decliningUser, string reason);
        Task IncomingCall(UserForCalls callingUser);
        Task ReceiveSignal(UserForCalls signalingUser, string signal);
        Task CallEnded(UserForCalls signalingUser, string signal);
    }
}