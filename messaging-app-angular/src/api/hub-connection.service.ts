import { Injectable } from '@angular/core';
import {Constants} from '../constants';
import {HubConnection, HubConnectionBuilder, IHttpConnectionOptions} from '@aspnet/signalr';
import {MatDialog} from '@angular/material/dialog';
import {AnswerCallDialogComponent} from '../app/messages/chat/answer-call-dialog/answer-call-dialog.component';
import {UserForCalls} from './interfaces/user-for-calls';

@Injectable({
  providedIn: 'root'
})
export class HubConnectionService {

  private hubConnection: HubConnection;
  private currentUser;

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
        console.log('Connection started');
        this.joinHub();
      })
      .catch(() => console.log('Error while starting connection'));
  }

  private joinHub(): void {
    this.hubConnection.invoke('Join', parseInt(this.currentUser.id, 10))
      .then(() => console.log('Joined the hub'))
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
}
