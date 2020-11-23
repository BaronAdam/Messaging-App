import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {CallDialogData} from './call-dialog-data';

@Component({
  selector: 'app-call-dialog',
  templateUrl: './call-dialog.component.html',
  styleUrls: ['./call-dialog.component.css']
})
export class CallDialogComponent implements OnInit {

  constructor(public dialogRef: MatDialogRef<CallDialogComponent>, @Inject(MAT_DIALOG_DATA) public data: CallDialogData) { }

  time = 0;
  display = '0:00';
  interval;

  ngOnInit(): void {
    this.startTimer();
  }

  startTimer(): void {
    this.interval = setInterval(() => {
      this.time++;
      this.display = this.transform(this.time);
    }, 1000);
  }
  transform(value: number): string {
    const minutes: number = Math.floor(value / 60);
    const seconds = (value - minutes * 60) < 10 ? '0' + (value - minutes * 60) : (value - minutes * 60);
    return minutes + ':' + seconds;
  }

  endCall(): void {
    this.dialogRef.close();
  }
}
