import { Injectable } from '@angular/core';
import {Constants} from '../constants';
import {HubConnection, HubConnectionBuilder, IHttpConnectionOptions} from '@aspnet/signalr';
import {MatDialog} from '@angular/material/dialog';
import {AnswerCallDialogComponent} from '../app/messages/chat/answer-call-dialog/answer-call-dialog.component';
import {UserForCalls} from './interfaces/user-for-calls';

@Injectable({
  providedIn: 'root'
})
export class WebrtcHubService {

  private hubConnection: HubConnection;
  private currentUser;
  private peerConnectionConfig = {iceServers: [{urls: 'stun:stun.l.google.com:19302'}]};
  private webrtcConstraints = { audio: true, video: false };
  private localStream: MediaStream;
  private partnerAudioStream: MediaStream;
  private connections: RTCPeerConnection[] = [];

  constructor(private dialog: MatDialog) {

  }

  private getCurrentUser(): void {
    try {
      this.currentUser = JSON.parse(localStorage.getItem('currentUser'));
    }
    catch (e) {
      this.currentUser = null;
    }
  }

  public startConnection(): void {
    this.getCurrentUser();

    const options: IHttpConnectionOptions = {
      accessTokenFactory: () => this.currentUser.token
    };

    this.hubConnection = new HubConnectionBuilder()
      .withUrl(`${Constants.SERVER_URL}Caller`, options)
      .build();

    this.hubConnection.on('incomingCall', (callingUser: UserForCalls) => {
      this.dialog.open(AnswerCallDialogComponent, {
        data: {id: callingUser.id, name: callingUser.name},
        disableClose: true,
        panelClass: 'call-dialog-container' });
    });

    this.hubConnection.start()
      .then(() => {
        this.joinHub();
      })
      .catch(() => console.log('Error while starting connection'));

    navigator.mediaDevices.getUserMedia(this.webrtcConstraints)
      .then((stream) => this.localStream = stream)
      .catch((error) => console.log(`Error while getting media stream: ${error}`)
      );
  }

  private joinHub(): void {
    this.hubConnection.invoke('Join', parseInt(this.currentUser.id, 10))
      .catch(() => console.log('Error while joining hub'));
  }

  public close(): void {
    try {
      this.hubConnection.off('incomingCall');
    } catch (e) {
      console.log(e);
    }
    this.deleteMethods();

    this.hubConnection.stop()
      .catch(() => console.log('Error while closing connection'));
  }

  public declineCall(id: number): void {
    this.hubConnection.invoke('AnswerCall', false, id)
      .catch((err) => console.log(err));
  }

  public acceptCall(id: number): void {
    this.hubConnection.invoke('AnswerCall', true, id)
      .catch((err) => console.log(err));
  }

  public getHubReference(): HubConnection {
    return this.hubConnection;
  }

  public deleteMethods(): void {
    try {
      this.hubConnection.off('callAccepted');
      this.hubConnection.off('callDeclined');
      this.hubConnection.off('receiveSignal');
      this.hubConnection.off('callEnded');
    } catch (e) {
      console.log(e);
    }
  }

  public callUser(id: number): Promise<boolean> {
    return this.hubConnection.invoke('callUser', id)
      .then(() => true)
      .catch(() => false);
  }

  public endCall(): void {
    this.hubConnection.invoke('hangUp')
      .catch(() => console.log('Error while ending call.'));
  }

  private sendHubSignal(candidate: string, partnerClientId: string): void {
    this.hubConnection.invoke('sendSignal', candidate, partnerClientId)
      .catch((err) => console.log(`Error while sending signal: ${err}`));
  }

  private getConnection(partnerClientId: string): RTCPeerConnection {
    if (this.connections[partnerClientId]) {
      return this.connections[partnerClientId];
    } else {
      return this.initializeConnection(partnerClientId);
    }
  }

  private initializeConnection(partnerClientId: string): RTCPeerConnection {
    const connection = new RTCPeerConnection(this.peerConnectionConfig);

    connection.onicecandidate = (evt) => {
      if (evt.candidate) {
        this.sendHubSignal(JSON.stringify(evt.candidate), partnerClientId);
      }
      else {
        this.sendHubSignal(JSON.stringify({ candidate: null }), partnerClientId);
      }
    };

    connection.ontrack = (evt) => {
      this.partnerAudioStream = evt.streams[0];
    };

    this.connections[partnerClientId] = connection;

    return connection;
  }

  public newSignal(partnerClientId: string, data: string): void {
    const connection = this.getConnection(partnerClientId);
    const signal = JSON.parse(data);

    if (signal.sdp) {
      this.receivedSdpSignal(connection, partnerClientId, signal.sdp);
    } else if (signal.candidate) {
      const candidate: RTCIceCandidateInit = {
        candidate: signal.candidate,
        sdpMid: signal.sdpMid,
        sdpMLineIndex: signal.sdpMLineIndex
      };

      this.receivedCandidateSignal(connection, candidate);
    } else {
      connection.addIceCandidate(null)
        .catch((err) => console.log(`Error while adding null candidate: ${err}`));
    }
  }

  private receivedSdpSignal(connection: RTCPeerConnection, partnerClientId: string, sdp): void {
    connection.setRemoteDescription(sdp)
      .then(() => {
        if (connection.remoteDescription.type === 'offer') {
          this.localStream.getTracks().forEach((track) => {
            connection.addTrack(track, this.localStream);
          });
          connection.createAnswer()
            .then((desc) => {
              connection.setLocalDescription(desc)
                .then(() => {
                  this.sendHubSignal(JSON.stringify({sdp: connection.localDescription}), partnerClientId);
                })
                .catch((err) => console.log(`Error while sending signal: ${err}`));
            })
            .catch((err) => `Error while creating answer ${err}`);
        } else if (connection.remoteDescription.type === 'answer') {

        }
      })
      .catch((err) => `Error while setting remote descriptor ${err}`);
  }

  private receivedCandidateSignal(connection: RTCPeerConnection, candidate: RTCIceCandidateInit): void {
    connection.addIceCandidate(new RTCIceCandidate(candidate))
      .catch((err) => console.log(`Error while adding candidate: ${err}`));
  }

  public closeConnection(partnerClientId: string): void {
    const connection = this.connections[partnerClientId];

    if (connection) {
      connection.close();
      delete this.connections[partnerClientId];
    }
  }

  public initializeCall(partnerClientId: string): Promise<void> {
    const connection = this.getConnection(partnerClientId);

    this.localStream.getTracks().forEach((track) => {
      connection.addTrack(track, this.localStream);
    });

    return connection.createOffer()
      .then((offer) => {
        connection.setLocalDescription(offer)
          .then(() => {
              this.sendHubSignal(JSON.stringify({ sdp: connection.localDescription }), partnerClientId);
          })
          .catch((err) => console.log(`Error while setting descriptor: ${err}`));
      });
  }

  public getStream(): MediaStream {
    return this.partnerAudioStream;
  }
}
