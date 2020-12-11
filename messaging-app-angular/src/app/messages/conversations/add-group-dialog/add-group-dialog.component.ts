import { Component, OnInit } from '@angular/core';
import {MatDialogRef} from '@angular/material/dialog';
import {GroupService} from '../../../../api/group.service';

@Component({
  selector: 'app-add-group-dialog',
  templateUrl: './add-group-dialog.component.html',
  styleUrls: ['./add-group-dialog.component.css']
})
export class AddGroupDialogComponent implements OnInit {

  constructor(public dialogRef: MatDialogRef<AddGroupDialogComponent>, private groupService: GroupService) { }

  ngOnInit(): void {
  }

  addGroup(formData: {groupName: string}): void {
    this.groupService.addGroup(formData.groupName);

    this.dialogRef.close();
  }
}
