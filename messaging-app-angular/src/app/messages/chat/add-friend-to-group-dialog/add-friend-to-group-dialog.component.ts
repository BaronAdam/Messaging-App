import {Component, Inject, OnInit} from '@angular/core';
import {GroupService} from '../../../../api/group.service';
import {User} from '../../../../api/interfaces/user';
import {UserService} from '../../../../api/user.service';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {DialogData} from '../dialog-data';

@Component({
  selector: 'app-add-friend-to-group-dialog',
  templateUrl: './add-friend-to-group-dialog.component.html',
  styleUrls: ['./add-friend-to-group-dialog.component.css']
})
export class AddFriendToGroupDialogComponent implements OnInit {
  friends: Array<User> = undefined;
  members: Array<number> = undefined;

  constructor(private groupService: GroupService, private userService: UserService,
              @Inject(MAT_DIALOG_DATA) public data: DialogData, public dialogRef: MatDialogRef<AddFriendToGroupDialogComponent>) { }

  ngOnInit(): void {
    this.getFriends();
  }

  getFriends(): void {
    this.userService.getFriends()
      .subscribe((responseData: Array<User>) => {
        this.friends = responseData;
        this.getMembers();
      });
  }

  getMembers(): void {
    this.groupService.getMembersForGroup(this.data.id)
      .subscribe((responseData: Array<number>) => {
        this.members = responseData;
      }, error => {
        this.groupService.alertUser(error);
        this.dialogRef.close();
      });
  }

  addToGroup(friendId: number): void {
    this.groupService.addMembersToGroup(this.data.id, [friendId])
      .subscribe(() => {
        this.getFriends();
    }, error => {
      this.groupService.alertUser(error);
    });
  }
}
