import { Component, OnInit } from '@angular/core';
import {Message} from '../../../../api/interfaces/message';
import {MatDialog} from '@angular/material/dialog';
import {PictureDialogComponent} from '../picture-dialog/picture-dialog.component';

@Component({
  selector: 'app-message',
  templateUrl: './message.component.html',
  styleUrls: ['./message.component.css']
})
export class MessageComponent implements OnInit {

  public message: Message;
  public isMe: boolean;

  constructor(private dialog: MatDialog) { }

  ngOnInit(): void {
    this.isMe = this.message.senderId === parseInt(JSON.parse(localStorage.getItem('currentUser')).id, 10);
    if (this.isMe) {
      this.message.senderName = 'You';
    }
  }

  showPicture(): void {
      this.dialog.open(PictureDialogComponent, {data: {url: this.message.url}});
  }
}
