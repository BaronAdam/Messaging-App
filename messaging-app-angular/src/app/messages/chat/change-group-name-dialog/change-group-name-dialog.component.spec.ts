import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangeGroupNameDialogComponent } from './change-group-name-dialog.component';

describe('ChangeGroupNameDialogComponent', () => {
  let component: ChangeGroupNameDialogComponent;
  let fixture: ComponentFixture<ChangeGroupNameDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ChangeGroupNameDialogComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangeGroupNameDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
