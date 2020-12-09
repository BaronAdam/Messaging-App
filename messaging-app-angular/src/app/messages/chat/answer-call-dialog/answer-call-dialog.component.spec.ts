import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AnswerCallDialogComponent } from './answer-call-dialog.component';

describe('AnswerCallDialogComponent', () => {
  let component: AnswerCallDialogComponent;
  let fixture: ComponentFixture<AnswerCallDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AnswerCallDialogComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AnswerCallDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
