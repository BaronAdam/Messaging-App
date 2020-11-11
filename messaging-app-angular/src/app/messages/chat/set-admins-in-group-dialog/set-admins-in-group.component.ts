import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {GroupService} from '../../../../api/group.service';
import {DialogData} from '../dialog-data';
import {User} from '../../../../api/interfaces/user';
import {UserService} from '../../../../api/user.service';

@Component({
  selector: 'app-set-admins-in-group',
  templateUrl: './set-admins-in-group.component.html',
  styleUrls: ['./set-admins-in-group.component.css']
})
export class SetAdminsInGroupComponent implements OnInit {
  members: Array<User> = undefined;
  admins: Array<number> = undefined;
  memberIds: Array<number>;

  constructor(private groupService: GroupService,
              private userService: UserService,
              @Inject(MAT_DIALOG_DATA) public data: DialogData) { }

  ngOnInit(): void {
    this.getMemberIds();
  }

  getMemberIds(): void {
    this.groupService.getMembersForGroup(this.data.id)
      .subscribe((responseData: Array<number>) => {
        this.memberIds = responseData;
        this.getAdmins();
    }, error => {
      this.groupService.alertUser(error);
    });
  }

  getAdmins(): void {
    this.groupService.getAdminsForGroup(this.data.id)
      .subscribe((responseData: Array<number>) => {
        this.admins = responseData;
        this.getMembers();
      }, error => {
        this.groupService.alertUser(error);
      });
  }

  getMembers(): void {
    this.members = [];
    for (const id of this.memberIds) {
      this.userService.getUser(id)
        .subscribe((responseData: User) => {
          this.members.push(responseData);
          }, error => {
            this.userService.alertUser(error);
          });
    }
  }

  setAdmin(memberId: number): void {
    this.groupService.changeAdminStatus(memberId, this.data.id);
    setTimeout(() => this.getMemberIds(), 100);
  }
}
