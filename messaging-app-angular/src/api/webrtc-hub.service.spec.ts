import { TestBed } from '@angular/core/testing';

import { WebrtcHubService } from './webrtc-hub.service';

describe('HubConnectionService', () => {
  let service: WebrtcHubService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(WebrtcHubService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
