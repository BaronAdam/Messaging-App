import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {Constants} from '../constants';
import {AlertifyService} from '../services/alertify.service';
import {JwtHelperService} from '@auth0/angular-jwt';
import {TokenResponse} from './interfaces/token-response';
import {ErrorResponseRegister} from './interfaces/error-response-register';
import {Observable} from 'rxjs';
import {map} from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private http: HttpClient, private alertify: AlertifyService) {}
  private jwtHelper = new JwtHelperService();

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  static getToken(): string {
    let token;
    try {
      token = JSON.parse(localStorage.getItem('currentUser')).token;
      const helper = new JwtHelperService();
      if (helper.isTokenExpired(token)) {
        localStorage.clear();
        return null;
      }
    }
    catch (e) {
      token = null;
    }
    return token;
  }

  login(body: {username: string, password: string}): Observable<boolean> {
    const apiUrl = `${Constants.SERVER_URL}api/auth/login`;
    return this.http.post(apiUrl, body)
      .pipe(map((responseData: TokenResponse) => {
        if (responseData.hasOwnProperty('token')) {
          const decoded = this.jwtHelper.decodeToken(responseData.token);
          localStorage.clear();
          localStorage.setItem('currentUser', JSON.stringify({ token: responseData.token, name: decoded.unique_name, id: decoded.nameid }));
          return true;
        }
        return false;
      }));
  }

  handleErrorsLogin(error): void {
    if (error.status === 401) {
      this.alertify.error('Wrong username or password');
    }
    else if (error.status === 500) {
      this.alertify.error('There was an server error while processing your request');
    }
    else {
      this.alertify.error('There was an error while processing your request');
    }
  }

  private displayErrors(error): void {
    const errors: ErrorResponseRegister = error.error.errors;
    if (errors.Email != null) {
      for (const err of errors.Email) {
        this.alertify.error(err);
      }
    }
    if (errors.Password != null) {
      for (const err of errors.Password) {
        this.alertify.error(err);
      }
    }
    if (errors.Username != null) {
      for (const err of errors.Username) {
        this.alertify.error(err);
      }
    }
    if (errors.Name != null) {
      for (const err of errors.Name) {
        this.alertify.error(err);
      }
    }
  }

  register(body: {username: string, password: string, email: string; name: string}): void {
    const apiUrl = `${Constants.SERVER_URL}api/auth/register`;
    this.http
      .post(apiUrl, body)
      .subscribe(() => {}, error => {
        if (error.status === 500) {
          this.alertify.error('There was an server error while processing your request');
        }
        else if (error.status === 400) {
          this.displayErrors(error);
        }
        else {
          this.alertify.error('There was an error while processing your request');
        }
    });
  }
}
