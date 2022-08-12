import { TestBed } from '@angular/core/testing';

import { SdaExtensionsService } from './sda-extensions.service';

describe('SdaExtensionsService', () => {
  let service: SdaExtensionsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(SdaExtensionsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
