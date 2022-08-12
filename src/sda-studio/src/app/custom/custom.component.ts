import { Component, OnInit } from '@angular/core';
import { SdaExtensionsService } from '../sda-extensions.service';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-custom',
  templateUrl: './custom.component.html',
  styleUrls: ['../form.css']
})
export class CustomComponent implements OnInit {

  constructor(public sda: SdaExtensionsService, public http: HttpClient) { }

  ngOnInit(): void {
  }

  // dynamic update of matchings
  setMatchings() {   
    var infotype = (document.getElementById("infotype") as HTMLInputElement).value
    var dateProperty = (document.getElementById("dateProperty") as HTMLInputElement).value
    var matchings = (document.getElementById("matchings") as HTMLInputElement)
    if (infotype != "" && dateProperty != "" ) {
      matchings.value = infotype + "/" + dateProperty
    }
  }

  // get input for custom SDA
  customSDAInput() {
    var sdainput = (document.getElementById("sda") as HTMLInputElement).value
    var customPlural = (document.getElementById("customPlural") as HTMLInputElement).value
    var infotype = (document.getElementById("infotype") as HTMLInputElement).value
    var dateProperty = (document.getElementById("dateProperty") as HTMLInputElement).value
    var matchings = (document.getElementById("matchings") as HTMLInputElement).value
    // adding -input to matcheckbox id gets implicit <input> tag
    var hi = (document.getElementById("hi-input") as HTMLInputElement).checked
    var cv = (document.getElementById("cv-input") as HTMLInputElement).checked
    this.sda.customSDA(sdainput, hi, cv, customPlural, infotype, dateProperty, matchings)
  }


}
