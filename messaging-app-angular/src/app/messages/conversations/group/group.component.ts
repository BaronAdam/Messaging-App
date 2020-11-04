import {Component, Input, OnInit, Output, ViewChild} from '@angular/core';
import {MessageGroup} from '../../../../api/interfaces/message-group';
import {EventEmitter} from '@angular/core';

@Component({
  selector: 'app-group',
  templateUrl: './group.component.html',
  styleUrls: ['./group.component.css']
})
export class GroupComponent implements OnInit{
  @Output() selectedChat = new EventEmitter<MessageGroup>();
  @ViewChild('container') container;

  public group: MessageGroup;

  constructor() { }

  ngOnInit(): void {
  }

  openChat(): void {
    this.selectedChat.next(this.group);
  }
}
