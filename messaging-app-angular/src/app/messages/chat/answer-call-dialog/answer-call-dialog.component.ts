import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialog, MatDialogRef} from '@angular/material/dialog';
import {CallDialogData} from '../call-dialog-data';
import {WebrtcHubService} from '../../../../api/webrtc-hub.service';
import {CallDialogComponent} from '../call-dialog/call-dialog.component';

@Component({
  selector: 'app-answer-call-dialog',
  templateUrl: './answer-call-dialog.component.html',
  styleUrls: ['./answer-call-dialog.component.css']
})
export class AnswerCallDialogComponent implements OnInit {

  constructor(public dialogRef: MatDialogRef<AnswerCallDialogComponent>, @Inject(MAT_DIALOG_DATA) public data: CallDialogData,
              private hubService: WebrtcHubService, private dialog: MatDialog) {
  }

  ngOnInit(): void {

  }

  endCall(): void {
    this.hubService.declineCall(this.data.id);
    this.dialogRef.close();
  }

  answerCall(): void {
    this.hubService.acceptCall(this.data.id);
    this.dialog.open(CallDialogComponent, {
      data: {id: this.data.id, name: this.data.name, isNewCall: false},
      disableClose: true,
      panelClass: 'call-dialog-container'
    }).afterClosed().subscribe(() => {
      this.dialogRef.close();
    });
  }
}
