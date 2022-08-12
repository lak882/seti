import { Component } from '@angular/core';
import { SdaExtensionsService } from './sda-extensions.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  
  constructor(public sda: SdaExtensionsService) { }

  ngOnInit() : void {
    this.sda.getPorts()
  }
  
  resetSDA() {
    this.sda.resetSDA()
  }
}