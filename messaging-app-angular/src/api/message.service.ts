import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {AlertifyService} from '../services/alertify.service';
import {AuthService} from './auth.service';
import {MessageGroup} from './interfaces/message-group';
import {Constants} from '../constants';
import {Message} from './interfaces/message';
import {map} from 'rxjs/operators';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  userId: number;
  httpOptions: object;

  constructor(private http: HttpClient, private alertify: AlertifyService) {}

  private setUserIdAndToken(): void {
    this.userId = JSON.parse(localStorage.getItem('currentUser')).id;
    this.httpOptions = {
      headers: new HttpHeaders({
        Authorization: `Bearer ${AuthService.getToken()}`
      })
    };
  }

  alertUser(error): void {
    if (error.status === 500) {
      this.alertify.error('There was an server error while processing your request');
    }
    else {
      this.alertify.error('There was an error while processing your request');
    }
  }

  getChats(): Observable<Array<MessageGroup>> {
    this.setUserIdAndToken();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/messages`;

    return this.http.get(apiUrl, this.httpOptions)
      .pipe(map((responseData: Array<MessageGroup>) => {
        return responseData;
      }));
  }

  getMessagesForGroup(groupId: number): Observable<Array<Message>> {
    this.setUserIdAndToken();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/messages/thread/${groupId}`;

    return this.http.get(apiUrl, this.httpOptions)
      .pipe(map((responseData: Array<Message>) => {
        return responseData;
        })
      );
  }

  sendTextMessage(groupId: number, message: string): Observable<void> {
    this.setUserIdAndToken();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/messages`;

    return this.http.post(apiUrl, {groupId, content: message, isPhoto: false}, this.httpOptions)
      .pipe(map(() => {}));
  }
}
