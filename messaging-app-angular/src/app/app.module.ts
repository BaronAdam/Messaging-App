import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import {MatIconModule} from '@angular/material/icon';
import {MatButtonModule} from '@angular/material/button';

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
import { AddFriendDialogComponent } from './messages/conversations/add-friend-dialog/add-friend-dialog.component';
import {MatDialog, MatDialogModule} from '@angular/material/dialog';
import {Overlay} from '@angular/cdk/overlay';
import {MatFormFieldModule, MatLabel} from '@angular/material/form-field';
import {MatInputModule} from '@angular/material/input';


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
    AddFriendDialogComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    RouterModule.forRoot(appRoutes),
    MatIconModule,
    MatInputModule,
    MatFormFieldModule,
    MatButtonModule,
    NoopAnimationsModule,
    MatDialogModule,
  ],
  providers: [DatePipe, MatDialog, Overlay],
  bootstrap: [AppComponent]
})
export class AppModule { }
