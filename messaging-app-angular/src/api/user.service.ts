import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {AlertifyService} from '../services/alertify.service';
import {AuthService} from './auth.service';
import {Constants} from '../constants';
import {User} from './interfaces/user';
import {Observable} from 'rxjs';
import {map} from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  userId: number;
  httpOptions: object;

  constructor(private http: HttpClient, private alertify: AlertifyService) {}

  setVariables(): void {
    this.userId = JSON.parse(localStorage.getItem('currentUser')).id;
    this.httpOptions = {
      headers: new HttpHeaders({
        Authorization: `Bearer ${AuthService.getToken()}`
      })
    };
  }

  public alertUser(error): void {
    if (error.status === 500) {
      this.alertify.error('There was an server error while processing your request');
    }
    else {
      this.alertify.error('There was an error while processing your request');
    }
  }

  findUser(searchPhrase: string): Observable<User> {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/find/${searchPhrase}`;

    return this.http.get(apiUrl, this.httpOptions)
      .pipe(map((responseData: User) => {
        return responseData;
      }));
  }

  addFriend(friendId: number): Observable<any> {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/friend/${friendId}`;

    return this.http.post(apiUrl, {}, this.httpOptions);
  }

  getFriends(): Observable<Array<User>> {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/friends/${this.userId}`;

    return this.http.get(apiUrl, this.httpOptions)
      .pipe(map((responseData: Array<User>) => {
      return responseData;
    }));
  }

  getUser(userId): Observable<User> {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${userId}`;

    return this.http.get(apiUrl, this.httpOptions)
      .pipe(map((responseData: User) => {
        return responseData;
      }));
  }
}
