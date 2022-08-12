import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CustomPropertyComponent } from './custom-property.component';

describe('CustomPropertyComponent', () => {
  let component: CustomPropertyComponent;
  let fixture: ComponentFixture<CustomPropertyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CustomPropertyComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CustomPropertyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
