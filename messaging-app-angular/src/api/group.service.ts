import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {AlertifyService} from '../services/alertify.service';
import {AuthService} from './auth.service';
import {Constants} from '../constants';
import {map} from 'rxjs/operators';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class GroupService {
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

  alertUser(error): void {
    if (error.status === 500) {
      this.alertify.error('There was an server error while processing your request');
    }
    else {
      this.alertify.error('There was an error while processing your request');
    }
  }

  addGroup(name: string): void {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/add`;

    this.http.post(apiUrl, {name}, this.httpOptions).subscribe(() => {
      return true;
    }, error => {
      this.alertUser(error);
    });
  }

  editGroupName(id: number, name: string): void {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group`;

    this.http.patch(apiUrl, {id, name}, this.httpOptions)
      .subscribe(() => {
    }, error => {
      this.alertUser(error);
    });
  }

  getMembersForGroup(groupId: number): Observable<Array<number>> {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/members/id/${groupId}`;

    return this.http.get(apiUrl, this.httpOptions)
      .pipe(map((responseData: Array<number>) => {
        return responseData;
      }));
  }

  addMembersToGroup(groupId: number, userIds: Array<number>): Observable<any> {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/add/${groupId}`;

    return this.http.post(apiUrl, {ids: userIds}, this.httpOptions);
  }

  getAdminsForGroup(groupId: number): Observable<Array<number>> {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/members/admins/${groupId}`;

    return this.http.get(apiUrl, this.httpOptions)
      .pipe(map((responseData: Array<number>) => {
        return responseData;
      }));
  }

  changeAdminStatus(memberId: number, groupId: number): void {
    this.setVariables();
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/admin`;

    this.http.patch(apiUrl, {userId: memberId, groupId}, this.httpOptions)
      .subscribe(() => {}, error => {
      this.alertUser(error);
    });
  }
}
