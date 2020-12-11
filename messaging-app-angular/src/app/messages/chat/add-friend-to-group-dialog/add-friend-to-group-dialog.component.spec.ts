import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddFriendToGroupDialogComponent } from './add-friend-to-group-dialog.component';

describe('AddFriendToGroupDialogComponent', () => {
  let component: AddFriendToGroupDialogComponent;
  let fixture: ComponentFixture<AddFriendToGroupDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddFriendToGroupDialogComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddFriendToGroupDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
