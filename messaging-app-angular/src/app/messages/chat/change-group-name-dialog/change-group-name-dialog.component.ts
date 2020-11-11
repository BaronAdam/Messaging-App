import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {GroupService} from '../../../../api/group.service';
import {DialogData} from '../dialog-data';

@Component({
  selector: 'app-change-group-name-dialog',
  templateUrl: './change-group-name-dialog.component.html',
  styleUrls: ['./change-group-name-dialog.component.css']
})
export class ChangeGroupNameDialogComponent implements OnInit {

  constructor(public dialogRef: MatDialogRef<ChangeGroupNameDialogComponent>, private groupService: GroupService,
              @Inject(MAT_DIALOG_DATA) public data: DialogData) { }

  ngOnInit(): void {
  }

  changeName(formData: {groupName: string}): void {
    this.groupService.editGroupName(this.data.id, formData.groupName);

    this.dialogRef.close();
  }
}
