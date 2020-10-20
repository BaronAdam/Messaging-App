import { Component, OnInit } from '@angular/core';
import {AuthService} from '../../../api/auth.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

  constructor(private auth: AuthService) { }

  ngOnInit(): void {
  }

  register(loginData: {username: string, password: string, email: string, name: string}): void {
    this.auth.register(loginData);
  }
}
