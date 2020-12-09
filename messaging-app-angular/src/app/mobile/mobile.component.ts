import { Component, OnInit } from '@angular/core';
import {Platform} from '@angular/cdk/platform';

@Component({
  selector: 'app-mobile',
  templateUrl: './mobile.component.html',
  styleUrls: ['./mobile.component.css']
})
export class MobileComponent implements OnInit {

  platformString: string;

  constructor(private platform: Platform) {
    this.platformString = this.platform.ANDROID ? 'Android' : 'iOS';
  }

  ngOnInit(): void {
  }

}
