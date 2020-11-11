import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SetAdminsInGroupComponent } from './set-admins-in-group.component';

describe('SetAdminsInGroupComponent', () => {
  let component: SetAdminsInGroupComponent;
  let fixture: ComponentFixture<SetAdminsInGroupComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SetAdminsInGroupComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SetAdminsInGroupComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
