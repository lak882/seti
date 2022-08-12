import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AlertsService } from './alerts.service';
import { catchError } from 'rxjs/operators'


export interface customInterface {
  sda: string;
  customPlural: string;
  infotype: string;
  dateProperty: string;
  matchings: string;
  cv: boolean;
  hi: boolean;
}

export interface extensionAndPropertyInterface {
  sda: string;
  propertyName: string;
  propertyType: string;
  cv: boolean;
  hi: boolean;
}

@Injectable({
  providedIn: 'root'
})

export class SdaExtensionsService {

  constructor(private http: HttpClient,
    public sb: AlertsService) { }

  // INSERT PORTS
  ucrURL = ""
  viewerURL = ""
  // INSERT PORTS

  // get ports from the website and from then use that to get it from the API
  getPorts(): void {
    this.ucrURL = "http://localhost:" + window.location.port
    var keys : string[]= []
    this.http.get(this.ucrURL + "/dispatch/getViewerPort").toPromise().then(data => {
      for (let key in data) {
        keys.push(key)
      }
      this.viewerURL = "http://localhost:" + keys[0]
    })
  }

  getDatatypes(): Observable<string[]> {
    return this.http.get<string[]>('/api/datatypes',{
      'headers': new HttpHeaders({'Accept': 'application/json', 'Authorization':'Basic U3VwZXJVc2VyOlNZUw=='})
    });
  }

  async extendSDA(sda: string, propertyName: string, propertyType: string, hi: boolean, cv: boolean) {
    this.sb.openSnackBar("Extending SDA...", "")
    var json = '{"sda":"' +  sda
    json += '", "propertyName":"' + propertyName
    json += '", "propertyType":"' + propertyType
    json += '", "hi":"' + (+hi)
    json += '", "cv":"' + (+cv)
    json += '", "extension":"' + propertyName
    json += '"}'
    // UCR
    await this.http.post(this.ucrURL + '/dispatch/extend',json)
    .pipe(catchError(error => 'error' )).toPromise()
    //.subscribe(response => { console.log(response) })
    if (cv == true) {
      // Viewer HSCUSTOM
      await this.http.post(this.viewerURL + '/dispatch/extend',json)
      .pipe(catchError(error => 'error' )).toPromise()
      // Viewer VIEWER
      await this.http.post(this.viewerURL + '/dispatchviewer/extend', json)
      .pipe(catchError(error => 'error' )).toPromise()
    }
    this.sb.openSnackBar("Extended SDA.", "Dismiss")
  };

  async customSDA(sda: string, hi: boolean, cv: boolean, customPlural: string, infotype: string,
    dateProperty: string, matchings: string) {
    this.sb.openSnackBar("Adding Custom SDA...", "")
    var json = '{"sda":"' +  sda
    json += '", "hi":"' + (+hi)
    json += '", "cv":"' + (+cv)
    json += '", "customPlural":"' + customPlural
    json += '", "infotype":"' + infotype
    json += '", "dateProperty":"' + dateProperty
    json += '", "matchings":"' + matchings
    json += '", "extension":"' + sda
    json += '"}'
    await this.http.post(this.ucrURL + '/dispatch/custom',json)
    .pipe(catchError(error => 'error' )).toPromise()
    if (cv == true) {
      await this.http.post(this.viewerURL + '/dispatch/custom',json)
      .pipe(catchError(error => 'error' )).toPromise()
      await this.http.post(this.viewerURL + '/dispatchviewer/custom', json)
      .pipe(catchError(error => 'error' )).toPromise()
    }
    //.subscribe(response => { console.log(response) })
    this.sb.openSnackBar("Added Custom SDA.", "Dismiss")
  };

  // reset the whole SDA
  async resetSDA() {
    this.sb.openSnackBar("Resetting SDA...", "")
    // reset UCR
    await this.http.post(this.ucrURL + '/dispatch/reset', "",)
    .pipe(catchError(error => 'error' )).toPromise()
    // reset Viewer VIEWER Namespace
    await this.http.post(this.viewerURL + '/dispatchviewer/reset', "",)
    .pipe(catchError(error => 'error' )).toPromise()
    // reset Viewer HSCUSTOM Namespace
    await this.http.post(this.viewerURL + '/dispatch/reset', "",)
    .pipe(catchError(error => 'error' )).toPromise()
    this.sb.openSnackBar("Reset SDA.", "Dismiss")
  }

  // add a property to a custom SDA
  async customAddProperty(sda: string, propertyName: string, propertyType: string, hi:boolean, cv:boolean) {
    this.sb.openSnackBar("Adding Property...", "")
    var json = '{"sda":"' +  sda
    json += '", "hi":"' + (+hi)
    json += '", "cv":"' + (+cv)
    json += '", "propertyName":"' + propertyName
    json += '", "propertyType":"' + propertyType
    json += '"}'
    await this.http.post(this.ucrURL + '/dispatch/customAddProperty',json)
    .pipe(catchError(error => 'error' )).toPromise()
    if (cv == true) {
      await this.http.post(this.viewerURL + '/dispatch/customAddProperty',json)
      .pipe(catchError(error => 'error' )).toPromise()
      await this.http.post(this.viewerURL + '/dispatchviewer/customAddProperty',json)
      .pipe(catchError(error => 'error' )).toPromise()
    }
    //.subscribe(response => { console.log(response) })
    this.sb.openSnackBar("Added Property.", "Dismiss")
  };

  // get list of all created custom sda fields
  customSDAList : string[] = [];
  getCustomSDA() {
    this.customSDAList = []
    this.http.get(this.ucrURL + '/dispatch/getCustomSDA').toPromise().then(data => {
      for (let key in data) {
        this.customSDAList.push(key)
      }
    })
  }

  // get list of all default sda fields we may want to extend
  extendSDAList : string[] = [];
  getExtendSDA() {
    this.extendSDAList = []
    this.http.get(this.ucrURL + '/dispatch/getExtendSDA').toPromise().then(data => {
      for (let key in data) {
        this.extendSDAList.push(key)
      }

    })
  }

  // get all the property types 
  propertyTypes : string[] = [];
  getPropertyTypes() {
    this.propertyTypes = []
    this.http.get(this.ucrURL + '/dispatch/getPropertyTypes').toPromise().then(data => {
      for (let key in data) {
        if (key.substring(0, 1) != "%") {
          key = key.substring(8)
        }
        this.propertyTypes.push(key)
      }
    })
  }


  getExtensionObjects() : Observable<extensionAndPropertyInterface[]> {
    return this.http.get<extensionAndPropertyInterface[]>(this.ucrURL + '/dispatch/getExtensionObjects')
  }

  getCustomObjects() : Observable<customInterface[]> {
    return this.http.get<customInterface[]>(this.ucrURL + '/dispatch/getCustomObjects')
  }

  PROPERTY: extensionAndPropertyInterface[] = []
  getPropertyObjects() : Observable<extensionAndPropertyInterface[]> {
    return this.http.get<extensionAndPropertyInterface[]>(this.ucrURL + '/dispatch/getPropertyObjects')
  }

}
