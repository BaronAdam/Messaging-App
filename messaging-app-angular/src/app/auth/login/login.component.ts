import { Component, OnInit } from '@angular/core';
import {AuthService} from '../../../api/auth.service';
import {Router} from '@angular/router';
import {AlertifyService} from '../../../services/alertify.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private auth: AuthService, private router: Router, private alertify: AlertifyService) {}

  ngOnInit(): void {
    if (AuthService.getToken() != null) {
      this.router.navigate(['/messages']);
    }
  }

  login(loginData: {username: string, password: string}): void {
    this.auth.login(loginData).subscribe( isSuccessful => {
      if (isSuccessful) {
        this.router.navigate(['/messages']);
      }
      else {
        this.alertify.error('Wrong username or password');
      }
      }, error => {
      this.auth.handleErrorsLogin(error);
    });
  }
}
