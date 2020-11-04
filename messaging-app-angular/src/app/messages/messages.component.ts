import {Component, ComponentFactoryResolver, ComponentRef, EventEmitter, OnInit, ViewChild, ViewContainerRef} from '@angular/core';
import {AuthService} from '../../api/auth.service';
import {Router} from '@angular/router';
import {MessageGroup} from '../../api/interfaces/message-group';
import {GroupComponent} from './conversations/group/group.component';
import {ChatComponent} from './chat/chat.component';

@Component({
  selector: 'app-messages',
  templateUrl: './messages.component.html',
  styleUrls: ['./messages.component.css']
})
export class MessagesComponent implements OnInit {

  public selectedGroup: MessageGroup;
  @ViewChild('chat', { read: ViewContainerRef }) container;
  public sendMessage: EventEmitter<any> = new EventEmitter<any>();

  constructor(private router: Router, private resolver: ComponentFactoryResolver) { }

  ngOnInit(): void {
    if (AuthService.getToken() == null) {
      this.router.navigate(['/']);
    }
  }

  onSelectedGroup(selectedGroup: MessageGroup): void {
    this.selectedGroup = selectedGroup;

    this.container.clear();

    const factory = this.resolver.resolveComponentFactory(ChatComponent);
    const component: ComponentRef<ChatComponent> = this.container.createComponent(factory);
    component.instance.group = selectedGroup;
    component.instance.messageSent.subscribe(evt => {
      this.sendMessage.emit();
    });
  }
}
