import { Component, OnInit } from '@angular/core';
import { SdaExtensionsService } from '../sda-extensions.service';

@Component({
  selector: 'app-custom-property',
  templateUrl: './custom-property.component.html',
  styleUrls: ['../form.css']
})

export class CustomPropertyComponent implements OnInit {

  constructor(public sda: SdaExtensionsService) { }

  ngOnInit(): void {
    this.sda.getCustomSDA()
  }

  sdaInput = ""
  propertyType = ""
  
  propertyInput() {
    const propertyName = (document.getElementById("propertyName") as HTMLInputElement).value
    // adding -input to matcheckbox id gets implicit <input> tag
    var hi = (document.getElementById("hi-input") as HTMLInputElement).checked
    var cv = (document.getElementById("cv-input") as HTMLInputElement).checked
    this.sda.customAddProperty(this.sdaInput, propertyName, this.propertyType, hi, cv)
  }
}
