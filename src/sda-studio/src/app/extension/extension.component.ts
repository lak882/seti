import { Component, OnInit } from '@angular/core';
import { SdaExtensionsService } from '../sda-extensions.service';

@Component({
  selector: 'app-extension',
  templateUrl: './extension.component.html',
  styleUrls: ['../form.css']
})
export class ExtensionComponent implements OnInit {

  constructor(public sda: SdaExtensionsService) { }

  ngOnInit(): void {
    this.sda.getExtendSDA()
    this.sda.getPropertyTypes()
  }

  sdaInput = ""
  propertyType = ""

  extendSDAInput() {
    const propertyName = (document.getElementById("propertyName") as HTMLInputElement).value
    // adding -input to matcheckbox id gets implicit <input> tag
    var hi = (document.getElementById("hi-input") as HTMLInputElement).checked
    var cv = (document.getElementById("cv-input") as HTMLInputElement).checked
    this.sda.extendSDA(this.sdaInput, propertyName, this.propertyType, hi, cv)
  }
}
