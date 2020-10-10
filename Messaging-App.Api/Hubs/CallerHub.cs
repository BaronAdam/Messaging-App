using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Messaging_App.Infrastructure.Interfaces;
using Messaging_App.Infrastructure.WebRtcModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Messaging_App.Api.Hubs
{
    [Authorize]
    public class CallerHub : Hub<ICallerHub>
    {
        private readonly List<CallOffer> _callOffers;
        private readonly List<UserCall> _userCalls;
        private readonly IUserRepository _userRepository;
        private readonly List<UserForCalls> _users;

        public CallerHub(List<CallOffer> callOffers, List<UserCall> userCalls, List<UserForCalls> users,
            IUserRepository userRepository)
        {
            _callOffers = callOffers;
            _userCalls = userCalls;
            _users = users;
            _userRepository = userRepository;
        }

        public async Task Join(int id)
        {
            var previousSessions = _users.FindAll(u => u.Id == id);

            foreach (var session in previousSessions) _users.Remove(session);

            var name = await _userRepository.GetUser(id);

            _users.Add(new UserForCalls
            {
                ConnectionId = Context.ConnectionId,
                Id = id,
                Name = name.Name
            });
        }

        public async Task CallUser(int id)
        {
            var targetConnectionId = _users.SingleOrDefault(u => u.Id == id);

            if (targetConnectionId == null)
            {
                await Clients.Caller.CallDeclined(null, "The user you called has left.");
                return;
            }

            var callingUser = _users.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = _users.SingleOrDefault(u => u.ConnectionId == targetConnectionId.ConnectionId);

            if (targetUser == null)
            {
                await Clients.Caller.CallDeclined(targetConnectionId, "The user you called has left.");
                return;
            }

            if (GetUserCall(targetUser.ConnectionId) != null)
            {
                await Clients.Caller.CallDeclined(targetConnectionId, "User is already in a call.");
                return;
            }

            await Clients.Client(targetConnectionId.ConnectionId).IncomingCall(callingUser);

            _callOffers.Add(new CallOffer
            {
                Caller = callingUser,
                Callee = targetUser
            });
        }

        public async Task AnswerCall(bool acceptCall, int id)
        {
            var targetConnectionId = _users.SingleOrDefault(u => u.Id == id);

            if (targetConnectionId == null)
            {
                await Clients.Caller.CallDeclined(null, "The user you called has left.");
                return;
            }

            var callingUser = _users.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = _users.SingleOrDefault(u => u.ConnectionId == targetConnectionId.ConnectionId);

            if (callingUser == null) return;

            if (targetUser == null)
            {
                await Clients.Caller.CallEnded(targetConnectionId, "The other user in your call has left.");
                return;
            }

            if (acceptCall == false)
            {
                await Clients.Client(targetConnectionId.ConnectionId).CallDeclined(callingUser,
                    "User did not accept your call.");
                return;
            }

            var offerCount = _callOffers.RemoveAll(c => c.Callee.ConnectionId == callingUser.ConnectionId
                                                        && c.Caller.ConnectionId == targetUser.ConnectionId);
            if (offerCount < 1)
            {
                await Clients.Caller.CallEnded(targetConnectionId, "User has already hung up.");
                return;
            }

            if (GetUserCall(targetUser.ConnectionId) != null)
            {
                await Clients.Caller.CallDeclined(targetConnectionId,
                    "User chose to accept someone else's call instead of yours :(");
                return;
            }

            _callOffers.RemoveAll(c => c.Caller.ConnectionId == targetUser.ConnectionId);

            _userCalls.Add(new UserCall
            {
                Users = new List<UserForCalls> {callingUser, targetUser}
            });

            await Clients.Client(targetConnectionId.ConnectionId).CallAccepted(callingUser);
        }

        public override async Task OnDisconnectedAsync(Exception exception)
        {
            await HangUp();

            // Remove the user
            _users.RemoveAll(u => u.ConnectionId == Context.ConnectionId);

            await base.OnDisconnectedAsync(exception);
        }

        public async Task SendSignal(string signal, int id)
        {
            var targetConnectionId = _users.SingleOrDefault(u => u.Id == id)?.ConnectionId;

            if (targetConnectionId == null)
            {
                await Clients.Caller.CallDeclined(null, "The user you called has left.");
                return;
            }


            var callingUser = _users.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = _users.SingleOrDefault(u => u.ConnectionId == targetConnectionId);

            if (callingUser == null || targetUser == null) return;

            var userCall = GetUserCall(callingUser.ConnectionId);

            if (userCall != null && userCall.Users.Exists(u => u.ConnectionId == targetUser.ConnectionId))
                await Clients.Client(targetConnectionId).ReceiveSignal(callingUser, signal);
        }

        public async Task HangUp()
        {
            var callingUser = _users.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);

            if (callingUser == null) return;

            var currentCall = GetUserCall(callingUser.ConnectionId);

            if (currentCall != null)
            {
                foreach (var user in currentCall.Users.Where(u => u.ConnectionId != callingUser.ConnectionId))
                    await Clients.Client(user.ConnectionId).CallEnded(callingUser, "Caller has hung up.");

                currentCall.Users.RemoveAll(u => u.ConnectionId == callingUser.ConnectionId);
                if (currentCall.Users.Count < 2) _userCalls.Remove(currentCall);
            }

            _callOffers.RemoveAll(c => c.Caller.ConnectionId == callingUser.ConnectionId);
        }

        private UserCall GetUserCall(string id)
        {
            var matchingCall =
                _userCalls.SingleOrDefault(uc => uc.Users.SingleOrDefault(u => u.ConnectionId == id) != null);
            return matchingCall;
        }
    }
}