import { Component } from '@angular/core';
import {Platform} from '@angular/cdk/platform';
import {Router} from '@angular/router';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'messaging-app-angular';

  constructor(private platform: Platform, private router: Router) {
    if (platform.ANDROID || platform.IOS) {
      this.router.navigate(['mobile']);
    }
  }
}
