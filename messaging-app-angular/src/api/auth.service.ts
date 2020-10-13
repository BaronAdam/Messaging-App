import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {Constants} from '../constants';
import {AlertifyService} from '../services/alertify.service';
import {JwtHelperService} from '@auth0/angular-jwt';
import {TokenResponse} from './interfaces/token-response';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private http: HttpClient, private alertify: AlertifyService) {}
  jwtHelper = new JwtHelperService();

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  static getToken(): string {
    return JSON.parse(localStorage.getItem('currentUser')).token;
  }

  async login(body: {username: string, password: string}): Promise<void> {
    const apiUrl = `${Constants.SERVER_URL}api/auth/login`;
    this.http.post(apiUrl, body).subscribe((responseData: TokenResponse) => {
      const decoded = this.jwtHelper.decodeToken(responseData.token);
      localStorage.setItem('currentUser', JSON.stringify({ token: responseData.token, name: decoded.unique_name, id: decoded.nameid }));
    }, error => {
      if (error.status === 401) {
        this.alertify.error('Wrong username or password');
      }
      else if (error.status === 500) {
        this.alertify.error('There was an server error while processing your request');
      }
      else {
        this.alertify.error('There was an error while processing your request');
      }
    });
  }

  async register(body: {username: string, password: string, email: string; name: string}): Promise<string> {
    const apiUrl = `${Constants.SERVER_URL}api/auth/register`;
    this.http.post(apiUrl, body).subscribe(responseData => {
      return responseData;
    }, error => {
      if (error.status === 500) {
        this.alertify.error('There was an server error while processing your request');
      }
      else if (error.status === 400) {
        this.alertify.error(error.message);
      }
    });
    return null;
  }
}
