import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {AlertifyService} from '../services/alertify.service';
import {AuthService} from './auth.service';
import {Constants} from '../constants';
import {User} from './interfaces/user';

@Injectable({
  providedIn: 'root'
})
export class UserService {
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

  async findUser(searchPhrase: string): Promise<User> {
    const apiUrl = `${Constants.SERVER_URL}api/users/find${searchPhrase}`;

    this.http.get(apiUrl, this.httpOptions).subscribe((responseData: User) => {
      return responseData;
    }, error => {
      this.alertUser(error);
    });

    return null;
  }

  async addFriend(friendId: number): Promise<boolean> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/friend/${friendId}`;

    this.http.post(apiUrl, this.httpOptions).subscribe(() => {
      return true;
    }, error => {
      this.alertUser(error);
    });
    return false;
  }

  async getFriends(): Promise<Array<User>> {
    const apiUrl = `${Constants.SERVER_URL}api/users/friends/${this.userId}`;

    this.http.get(apiUrl, this.httpOptions).subscribe((responseData: Array<User>) => {
      return responseData;
    }, error => {
      this.alertUser(error);
    });

    return null;
  }

  async getUser(userId): Promise<User> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${userId}`;

    this.http.get(apiUrl, this.httpOptions).subscribe((responseData: User) => {
      return responseData;
    }, error => {
      this.alertUser(error);
    });

    return null;
  }
}
