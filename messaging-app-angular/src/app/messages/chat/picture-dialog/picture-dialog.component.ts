import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA} from '@angular/material/dialog';
import {PictureDialogData} from './picture-dialog-data';

@Component({
  selector: 'app-picture-dialog',
  templateUrl: './picture-dialog.component.html',
  styleUrls: ['./picture-dialog.component.css']
})
export class PictureDialogComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public data: PictureDialogData) { }

  ngOnInit(): void {
  }
}
