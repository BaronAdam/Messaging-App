import {
  Component,
  ComponentFactoryResolver,
  ComponentRef,
  EventEmitter, Input,
  OnInit,
  Output,
  ViewChild,
  ViewContainerRef
} from '@angular/core';
import {MessageGroup} from '../../../api/interfaces/message-group';
import {MessageService} from '../../../api/message.service';
import {GroupComponent} from './group/group.component';
import {DatePipe} from '@angular/common';
import {AddFriendDialogComponent} from './add-friend-dialog/add-friend-dialog.component';
import {MatDialog} from '@angular/material/dialog';
import {AddGroupDialogComponent} from './add-group-dialog/add-group-dialog.component';

@Component({
  selector: 'app-conversations',
  templateUrl: './conversations.component.html',
  styleUrls: ['./conversations.component.css']
})
export class ConversationsComponent implements OnInit {

  private conversations: Array<MessageGroup>;
  @ViewChild('container', { read: ViewContainerRef }) container;
  @Output() selectedChat = new EventEmitter<MessageGroup>();
  @Input() private sendMessage: EventEmitter<any>;

  constructor(private messageService: MessageService, private resolver: ComponentFactoryResolver, private datePipe: DatePipe,
              private dialog: MatDialog) {}

  ngOnInit(): void {
    this.fetchData();

    if (this.sendMessage) {
      this.sendMessage.subscribe(() => {
        this.fetchData();
      });
    }
  }

  fetchData(): void {
    this.messageService.getChats().subscribe((responseData: Array<MessageGroup>) => {
      for (const element of responseData) {
        const date = new Date(element.lastSent);
        element.lastSent = this.datePipe.transform(date, 'dd.MM.yyyy');
      }
      this.conversations = responseData;
      this.displayConversations();
    }, error => {
      this.messageService.alertUser(error);
    });
  }

  private displayConversations(): void {
    this.container.clear();
    for (const conversation of this.conversations) {
      const factory = this.resolver.resolveComponentFactory(GroupComponent);
      const component: ComponentRef<GroupComponent> = this.container.createComponent(factory);
      component.instance.group = conversation;
      component.instance.selectedChat.subscribe(evt => {
        this.selectedChat.emit(evt);
      });
    }
  }

  addFriend(): void {
    this.dialog.open(AddFriendDialogComponent).afterClosed().subscribe(() => {
      setTimeout(() => this.fetchData(), 100);
    });
  }

  addGroup(): void {
    this.dialog.open(AddGroupDialogComponent).afterClosed().subscribe(() => {
      setTimeout(() => this.fetchData(), 100);
    });
  }
}
