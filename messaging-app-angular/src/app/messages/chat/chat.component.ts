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

  constructor(private messageService: MessageService, private resolver: ComponentFactoryResolver) {}

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
}
