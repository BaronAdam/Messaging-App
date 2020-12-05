import {
  Component,
  ComponentFactoryResolver,
  ComponentRef,
  ElementRef,
  EventEmitter,
  OnInit,
  Output,
  ViewChild,
  ViewContainerRef
} from '@angular/core';
import {MessageGroup} from '../../../api/interfaces/message-group';
import {MessageService} from '../../../api/message.service';
import {Message} from '../../../api/interfaces/message';
import {MessageComponent} from './message/message.component';
import {delay} from 'rxjs/operators';
import {Router} from '@angular/router';
import {MatDialog} from '@angular/material/dialog';
import {ChangeGroupNameDialogComponent} from './change-group-name-dialog/change-group-name-dialog.component';
import {AddFriendToGroupDialogComponent} from './add-friend-to-group-dialog/add-friend-to-group-dialog.component';
import {SetAdminsInGroupComponent} from './set-admins-in-group-dialog/set-admins-in-group.component';
import {GroupService} from '../../../api/group.service';
import {CallDialogComponent} from './call-dialog/call-dialog.component';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css']
})
export class ChatComponent implements OnInit {
  public group: MessageGroup;
  private messages: Array<Message>;
  @ViewChild('messages', { read: ViewContainerRef }) container;
  @ViewChild('textMessage') inputField;
  @ViewChild('messagesContainer') scrollContainer: ElementRef;
  @Output() messageSent = new EventEmitter<any>();

  constructor(private messageService: MessageService, private resolver: ComponentFactoryResolver, private router: Router,
              private dialog: MatDialog, private groupService: GroupService) {}

  ngOnInit(): void {
    this.fetchData();
  }

  displayMessages(): void {
    for (const message of this.messages) {
      const factory = this.resolver.resolveComponentFactory(MessageComponent);
      const component: ComponentRef<MessageComponent> = this.container.createComponent(factory);
      component.instance.message = message;
    }
    setTimeout(() => this.scrollToBottom(), 0);
  }

  sendTextMessage(messageData: {message: string}): void {
    this.inputField.nativeElement.value = '';

    this.messageService.sendTextMessage(this.group.id, messageData.message).subscribe(() => {
      this.refresh();
    }, error => {
      this.messageService.alertUser(error);
    });
  }

  refresh(): void {
    this.container.clear();
    this.fetchData();
    this.messageSent.emit();
  }

  fetchData(): void {
    this.messageService.getMessagesForGroup(this.group.id).subscribe((responseData: Array<Message>) => {
      responseData = responseData.reverse();
      this.messages = responseData;
      this.displayMessages();
    }, error => {
      this.messageService.alertUser(error);
    });
  }

  scrollToBottom(): void {
    try {
      this.scrollContainer.nativeElement.scroll({
        top: this.scrollContainer.nativeElement.scrollHeight,
        left: 0
        });
    } catch (err) { }
  }

  logOut(): void {
    localStorage.clear();
    this.router.navigate(['/']);
  }

  changeName(): void {
    this.dialog.open(ChangeGroupNameDialogComponent, {data: {id: this.group.id}}).afterClosed()
      .subscribe(() => {
      setTimeout(() => this.refresh(), 100);
    });
  }

  addFriendToGroup(): void {
    this.dialog.open(AddFriendToGroupDialogComponent, {data: {id: this.group.id}});
  }

  setAdmins(): void {
    this.dialog.open(SetAdminsInGroupComponent, {data: {id: this.group.id}});
  }

  callUser(): void {
    this.groupService.getMembersForGroup(this.group.id)
      .subscribe((responseData: Array<number>) => {
        for (const id of responseData) {
          if (id !== parseInt(JSON.parse(localStorage.getItem('currentUser')).id, 10)) {
            this.dialog.open(CallDialogComponent, {
              data: {id, name: this.group.name},
              disableClose: true,
              panelClass: 'call-dialog-container' });
          }
        }
      }, error => {
        this.groupService.alertUser(error);
      });
  }

  fileChanged(event): void {
    const file = event.target.files[0];

    this.messageService.sendImage(this.group.id, file).subscribe(() => {
      this.refresh();
    }, error => {
      console.log(error)
      this.messageService.alertUser(error);
    });
  }
}
