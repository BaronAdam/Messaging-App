import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import {MatIconModule} from '@angular/material/icon';

import { AppComponent } from './app.component';
import { FormsModule } from '@angular/forms';
import { LoginComponent } from './auth/login/login.component';
import { RegisterComponent } from './auth/register/register.component';
import { AuthComponent } from './auth/auth.component';
import {RouterModule, Routes} from '@angular/router';
import { MessagesComponent } from './messages/messages.component';
import { ConversationsComponent } from './messages/conversations/conversations.component';
import { ChatComponent } from './messages/chat/chat.component';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { GroupComponent } from './messages/conversations/group/group.component';
import {DatePipe} from '@angular/common';
import { MessageComponent } from './messages/chat/message/message.component';

const appRoutes: Routes = [
  { path: 'messages', component: MessagesComponent },
  { path: '', component: AuthComponent }
];

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterComponent,
    AuthComponent,
    MessagesComponent,
    ConversationsComponent,
    ChatComponent,
    GroupComponent,
    MessageComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    RouterModule.forRoot(appRoutes),
    MatIconModule,
    NoopAnimationsModule,
  ],
  providers: [DatePipe],
  bootstrap: [AppComponent]
})
export class AppModule { }
