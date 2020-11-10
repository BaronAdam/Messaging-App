import { Component, OnInit } from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {UserService} from '../../../../api/user.service';
import {User} from '../../../../api/interfaces/user';

@Component({
  selector: 'app-add-friend-dialog',
  templateUrl: './add-friend-dialog.component.html',
  styleUrls: ['./add-friend-dialog.component.css']
})
export class AddFriendDialogComponent implements OnInit {
  public searchString: string;
  public user: User = undefined;
  public isInFriends: boolean = undefined;

  constructor(public dialogRef: MatDialogRef<AddFriendDialogComponent>, private userService: UserService) { }

  ngOnInit(): void {
  }

  search(formData: {searchPhrase: string}): void {
    this.searchString = formData.searchPhrase;
    this.findUser();

  }

  findUser(): void {
    this.userService.findUser(this.searchString)
      .subscribe((responseData: User) => {
        this.user = responseData;
        this.getFriends();
      }, error => {
        this.user = null;
        this.userService.alertUser(error);
      });
  }

  getFriends(): void {
    this.userService.getFriends()
      .subscribe((responseData: Array<User>) => {
        if (responseData.length > 0) {
          for (const user of responseData) {
            if (user.id === this.user.id) {
              this.isInFriends = true;
              return;
            }
            this.isInFriends = false;
          }
        }
        else { this.isInFriends = false; }
      }, error => {
        this.userService.alertUser(error);
      });
  }

  addFriend(): void {
    this.userService.addFriend(this.user.id)
      .subscribe(() => {
        this.isInFriends = true;
    }, error => {
      this.userService.alertUser(error);
    });
  }
}
