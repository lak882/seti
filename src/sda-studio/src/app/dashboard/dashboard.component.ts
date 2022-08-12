import { Component, OnInit } from '@angular/core';
import { SdaExtensionsService } from '../sda-extensions.service';
import { HttpClient } from '@angular/common/http';
import { extensionAndPropertyInterface } from '../sda-extensions.service';
import { customInterface } from '../sda-extensions.service';


@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['../form.css']
})


export class DashboardComponent implements OnInit {

  constructor(public sda: SdaExtensionsService, public http: HttpClient) { }

  
  ngOnInit(): void {
    this.getPropertyObjects()
    this.getCustomObjects()
    this.getExtensionObjects()
    this.selectDashboard()
  }

  custom : customInterface[] = []
  getCustomObjects() {
    this.sda.getCustomObjects().subscribe((data : customInterface[]) => {  this.custom = data})
  }
  displayCustom: string[] = ['sda', 'customPlural', 'infotype', 'dateProperty', 'matchings', 'hi', 'cv']

  extension : extensionAndPropertyInterface[] = []
  getExtensionObjects() {
    this.sda.getExtensionObjects().subscribe((data : extensionAndPropertyInterface[]) => { this.extension = data })
  }
  displayExtension: string[] = ['sda', 'propertyName', 'propertyType', 'hi', 'cv']

  property : extensionAndPropertyInterface[] = []
  getPropertyObjects() {
    this.sda.getPropertyObjects().subscribe((data : extensionAndPropertyInterface[]) => {  this.property = data })
  }
  displayProperty: string[] = ['sda', 'propertyName', 'propertyType', 'hi', 'cv']

  dashboardList = ["Extend SDA", "Custom SDA", "Custom SDA Property"]
  dashboard = "Extend SDA"

  selectDashboard() {
    for(let key in this.dashboardList) {
      var d = document.getElementById(this.dashboardList[key]) as HTMLDivElement
      if (this.dashboardList[key] == this.dashboard) {
        d.style.display = 'flex'
      } else {
        d.style.display = 'none'
      }
    }
  }

  // TODO: delete SDA input
  deleteSDAInput() {
  }

}
