import {Component, Inject, OnInit, OnDestroy} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {CallDialogData} from '../call-dialog-data';
import {WebrtcHubService} from '../../../../api/webrtc-hub.service';

@Component({
  selector: 'app-call-dialog',
  templateUrl: './call-dialog.component.html',
  styleUrls: ['./call-dialog.component.css']
})
export class CallDialogComponent implements OnInit, OnDestroy {

  constructor(public dialogRef: MatDialogRef<CallDialogComponent>, @Inject(MAT_DIALOG_DATA) public data: CallDialogData,
              private hubService: WebrtcHubService) { }

  time = 0;
  display = '0:00';
  interval;

  ngOnInit(): void {
    const hub = this.hubService.getHubReference();

    hub.on('callAccepted', (data) => {
      const acceptingUser = data;
      this.startTimer();

      this.hubService.initializeCall(acceptingUser.connectionId)
        .catch((err) => console.log(`Error while creating offer: ${err}`));
    });

    hub.on('callDeclined', (data) => {
      this.hubService.closeConnection(data.connectionId);
      this.dialogRef.close();
    });

    hub.on('receiveSignal', (signalingUser, signal) => {
      this.setAudioStream(this.hubService);
      this.hubService.newSignal(signalingUser.connectionId, signal);
    });

    hub.on('callEnded', (data) => {
      this.hubService.closeConnection(data.connectionId);
      const audio: HTMLAudioElement = document.querySelector('.partner');
      audio.src = '';

      this.dialogRef.close();
    });

    if (this.data.isNewCall) {
      this.display = 'Calling...';
      this.hubService.callUser(this.data.id)
        .then(isSuccessful => {
          if (!isSuccessful) {
            this.dialogRef.close();
          }
        })
        .catch(() => console.log('Error while calling user'));
    }

    if (!this.data.isNewCall) {
      this.startTimer();
    }
  }

  setAudioStream(hubService): void {
    const stream = hubService.getStream();
    const audio: HTMLAudioElement = document.querySelector('.partner');
    if (audio.srcObject !== stream) {
      audio.srcObject = stream;
    }
  }

  ngOnDestroy(): void {
    this.hubService.deleteMethods();
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
    this.hubService.endCall();
    this.dialogRef.close();
  }
}
