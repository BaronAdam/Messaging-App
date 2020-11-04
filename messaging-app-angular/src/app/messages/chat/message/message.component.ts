import { Component, OnInit } from '@angular/core';
import {Message} from '../../../../api/interfaces/message';

@Component({
  selector: 'app-message',
  templateUrl: './message.component.html',
  styleUrls: ['./message.component.css']
})
export class MessageComponent implements OnInit {

  public message: Message;
  public isMe: boolean;

  constructor() { }

  ngOnInit(): void {
    this.isMe = this.message.senderId === parseInt(JSON.parse(localStorage.getItem('currentUser')).id);
    if (this.isMe) {
      this.message.senderName = 'You';
    }
  }
}
