import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {AlertifyService} from '../services/alertify.service';
import {AuthService} from './auth.service';
import {Constants} from '../constants';

@Injectable({
  providedIn: 'root'
})
export class GroupService {
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

  async addGroup(name: string): Promise<boolean> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/add`;

    this.http.post(apiUrl, {name}, this.httpOptions).subscribe(() => {
      return true;
    }, error => {
      this.alertUser(error);
    });

    return false;
  }

  async editGroupName(id: number, name: string): Promise<boolean> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group`;

    this.http.post(apiUrl, {id, name}, this.httpOptions).subscribe(() => {
      return true;
    }, error => {
      this.alertUser(error);
    });

    return false;
  }

  async getMembersForGroup(groupId: number): Promise<Array<number>> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/members/id/${groupId}`;

    this.http.get(apiUrl, this.httpOptions).subscribe((responseData: Array<number>) => {
      return responseData;
    }, error => {
      this.alertUser(error);
    });

    return null;
  }

  async addMembersToGroup(groupId: number, userIds: Array<number>): Promise<boolean> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/add/${groupId}`;

    this.http.post(apiUrl, {ids: userIds}, this.httpOptions).subscribe(() => {
      return true;
    }, error => {
      this.alertUser(error);
    });

    return false;
  }

  async getAdminsForGroup(groupId: number): Promise<Array<number>> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/members/admins/${groupId}`;

    this.http.get(apiUrl, this.httpOptions).subscribe((responseData: Array<number>) => {
      return responseData;
    }, error => {
      this.alertUser(error);
    });

    return null;
  }

  async changeAdminStatus(memberId: number, groupId: number): Promise<boolean> {
    const apiUrl = `${Constants.SERVER_URL}api/users/${this.userId}/group/admin`;

    this.http.post(apiUrl, {userId: memberId, groupId}, this.httpOptions).subscribe(() => {
      return true;
    }, error => {
      this.alertUser(error);
    });

    return false;
  }
}
