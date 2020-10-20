import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {AlertifyService} from '../services/alertify.service';
import {AuthService} from './auth.service';
import {MessageGroup} from './interfaces/message-group';
import {Constants} from '../constants';
import {Message} from './interfaces/message';

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  userId: number;
  httpOptions: object;

  constructor(private http: HttpClient, private alertify: AlertifyService) {
    this.userId = JSON.parse(localStorage.getItem('currentUser')).id;
    this.httpOptions = {
      headers: new HttpHeaders({
        Authorization: `Bearer ${AuthService.getToken()}`
      })
    };
  }

  private alertUser(error): void {
    if (error.status === 500) {
      this.alertify.error('There was an server error while processing your request');
    }
    else {
      this.alertify.error('There was an error while processing your request');
    }
  }

  async getChats(): Promise<Array<MessageGroup>> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/messages`;

    this.http.get(apiUrl, this.httpOptions).subscribe((responseData: Array<MessageGroup>) => {
      return responseData;
    }, error => {
      this.alertUser(error);
    });

    return null;
  }

  async getMessagesForGroup(groupId: number): Promise<Array<Message>> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/messages/thread/${groupId}`;

    this.http.get(apiUrl, this.httpOptions).subscribe((responseData: Array<Message>) => {
      return responseData;
    }, error => {
      this.alertUser(error);
    });

    return null;
  }

  async sendTextMessage(groupId: number, message: string): Promise<boolean> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/messages`;

    this.http.post(apiUrl, {groupId, content: message, isPhoto: false}, this.httpOptions).subscribe(() => {
      return true;
    }, error => {
      this.alertUser(error);
    });
    return false;
  }
}
