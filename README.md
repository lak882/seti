[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/SETI)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fintersystems-iris-dev-template&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fseti)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)

<h1 align="center">
  <br>
  <a href=""><img src="logo/Logo_h256.png" height="100"></a>
</h1>

<h4 align="center">An easy to use SDA extension UI</h4>
      
* [Quick Start Guide](#quick-start-guide)
* [SDA Studio](#sda-studio)
* [Importing Patients](#importing-patients-with-sda-extensions)
* [Health Insight](#viewing-sda-extensions-in-health-insight)
* [Clinical Viewer](#viewing-sda-extensions-in-clinical-viewer)
* [Technical Overview](#technical-overview)
* [Setup Overview](#setup-overview)
* [Class Reference](#class-reference)
* [IRIS for Health](#iris-for-health)

# SDA Extension Tool (SETI)
The SDA Extension Tool (shortnamed SETI) extends SDA and then propagates extensions to Clinical Viewer and Health Insight. 

# Quick Start Guide
### Installation
1. For Unified Care Record open a Terminal in the HSCUSTOM namespace.
2. Use [ObjectScript Package Manager](https://openexchange.intersystems.com/package/ObjectScript-Package-Manager) to install SETI.
```
HSCUSTOM> zpm "install seti"
```
3. You will be prompted to enter the web port number for your Clinical Viewer instance. If you are not using Clinical Viewer it does not matter what you enter for the Clinical Viewer web port number. 
```
Please enter your Clinical Viewer web port number:
52774 
```
You can change the web port at any time by running:
```
HSCUSTOM> do ##class(SETI.Setup.Ports).SetPorts()
```
### Requirements
* [ObjectScript Package Manager](https://openexchange.intersystems.com/package/ObjectScript-Package-Manager) installed 
* HealthShare with appropriate license (or see [IRIS for Health](#iris-for-health))
* SETI uses namespace naming conventions of InstallDemo() ie. HSREGISTRY, HSANALYTICS, HSVIEWER (see [Setup Overview](#setup-overview))
* Install to unlock Clinical Viewer functonality: [SDA Extension Tool Viewer](https://openexchange.intersystems.com/package/SETI-Viewer-1)
### Usage ([Demo](https://intersystemscorporation-my.sharepoint.com/:v:/g/personal/lkabelka_intersystems_com/EVTw-fv2kE5IhnDx0HdrKhwBjMAwQ_fZp1OkpCQkUeKd9A))
1. Add your extensions in SDA Studio.
2. Add a patient with those extensions.
3. View your extensions in Health Insight and Clinical Viewer. <br>

# SDA Studio  
Once you've installed SETI, you will be able to view SDA Studio in the Managment Portal. In UCR navigate to "HealthShare Managment" -> "HSREGISTRY" -> "Registry Managment" -> "SDA Studio".  <br>
You can also go there directly by visiting http://localhost:{insert-ucr-port}/csp/healthshare/hsregistry/SETI.SDAStudio.cls <br>
<a href=""><img src="screenshots/sda-studio/1.png" height="400"></a> <br>
There are five tabs on which you can edit and view SDA: <br>
A - **Extend SDA**: Adding new sub-fields to already existing SDA fields. <br>
B - **Custom SDA**: Adding new fields. <br>
C - **Custom SDA Property**: Adding new properties to a custom SDA that was created. <br>
D - **Dashboard**: View all the SDA extensions that were created. <br>
E - **Reset SDA & Patients**: One button click to delete all the SDA extensions and delete all the patients.<br> 

## A - Extend SDA 
1 - **SDA**: The SDA to extend with a sub-field. <br>
2 - **Property Name**: The name of the sub-field. <br>
3 - **Property Type**: The type of the sub-field. <br>
<a href=""><img src="screenshots/sda-studio/2.png" height="400"></a> <br> <br>
## B - Custom SDA 
1 - **SDA**: The name of the new SDA field. <br>
2 - **Custom Plural**: If the plural of the name is not created by adding "s" to the end (ex. Diagnosis, Diagnoses). <br>
3 - **Infotype**, 4 - **Date Property**, 5 - **Matchings**: Basic streamlet data to communicate with Health Insight and Clinical Viewer. <br> ( These are the conventional defaults, if you do not care about streamlets: Infotype: PRC || DateProperty: EnteredOn || Matchings: PRC/EnteredOn. ) <br>
<a href=""><img src="screenshots/sda-studio/3.png" height="400"></a> <br>
## C - Custom SDA Property
1 - **SDA**: The Custom SDA to add a sub-field to. <br>
2 - **Property Name**: The name of the sub-field. <br>
3- **Property Type**: The type of the sub-field. <br>
<a href=""><img src="screenshots/sda-studio/4.png" height="400"></a> <br>
## D - Dashboard
Three different dashboard are selectable from the "Select Dashboard" dropdown for the forms that we looked at in A - C.
<a href=""><img src="screenshots/sda-studio/5.png" height="400"></a> <br> 
## E - Reset SDA & Patients
There is a button in the top right to Reset SDA & Patients. The reason why we also delete all the patients is because it can cause problems if a patient exists in the enviroment with SDA extension fields and then those SDA extensions are deleted before the patient is deleted. 

# Importing Patients with SDA Extensions
## Extend SDA
Add an &lt;Extension&gt; tag before adding the tag for the extension. <br>
<a href=""><img src="screenshots/patient/1.png" width="500"></a>
## Custom SDA
Requires a "Z" before the name of the custom SDA. This avoids conflicts with already existing fields. <br>
<a href=""><img src="screenshots/patient/2.png" width="500"></a>
## Test Patient
In the [SETI Test Patient](https://github.com/lak882/seti-test-patient) repository, we have provided patient files. They can be imported by moving them into the {UCR folder}/Data/HSEDGE1/SDAIn/. 
<br> If you move the patients into a new folder called {UCR folder}/Data/Test, then patients can be imported using the following: 
```
HSCUSTOM> do ##class(Demo.Patient).TestPatient("Base")
HSCUSTOM> do ##class(Demo.Patient).TestPatient("Final")
HSCUSTOM> do ##class(Demo.Patient).TestPatient("Delete")
```
**TestPatient_Base** represents a patient without extensions. <br>
**TestPatient_Final** is the same patient but with the following extensions:  <br>
1 - A extended SDA on "Allergy" called "Sneeziness" of type "%String". <br>
2 - A custom SDA called "Transplant" with default streamlets (PCR, EnteredOn, PCR/EnteredOn). <br>
3 - Custom properties on "Transplant" called "OrganType" of type "%String" and "NetPrice" of type "Numeric". <br>
**TestPatient_Delete** will delete the test patient. <br> <br>
Both the TestPatient_Base and TestPatient_Final can be imported individually. TestPatient_Final can also be used to add extensions onto TestPatient_Base. This is accomplished by importing TestPatient_Base, then adding the extensions in SDA Studio, then importing TestPatient_Final. <br>
## Delete Patients
Patients can be deleted at any time. To delete all the patients run the following:
```
HSCUSTOM> do ##class(Demo.Patient).DeleteAllPatients()
```

# Viewing SDA Extensions in Health Insight
After adding a patient with extensions, the Health Insight productions must be restarted to view the patient in Health Insight. The Health Insight productions are HSAA.TransferSDA3.Service.Interrupt and HS.Gateway.Analytics.TransmitService. They can be restarted by running the following command in UCR:
```
HSCUSTOM> do ##class(SETI.Helper).RestartProductions()
```
If you are using **HealthShare version 2022.1 or above**, you need to switch off the System Indexing to view patients in Health Insight. Everything else including the Clinical Viewer will work as intended regardless of wether you are using System Indexing. To turn off System Indexing, run the following in HSANALYTICS:
```
HSANALYTICS> do ##class(HSAA.API.Config).SetHIDataFeed()
Health Insight data feed mechanism is currently set to "System Index"
 
Do you want to configure it differently?
Enter yes (or y) to configure or no (or n) to quit: y
 
==== Set up the data feed mechnism for Health Insight ====
 
 
 
*** Please select either AADBQ or System Index by entering 0 or 1 only:
0: AADBQ
1: System Index
Enter 0 or 1 to set up, or q to quit: 0
```

## Extend SDA
* In the SQL Explorer, search for HSAA.{SDA} with {SDA} as the extended SDA. 
* Query that category.
* Ctrl+F for Extension_{Property Name}. <br>
<a href=""><img src="screenshots/hi/1.png" height="400"></a>
## Custom SDA
* In the SQL Explorer, search for HS_Local*
* Query the field that's called HS_Local_User.Z{SDA}HI with {SDA} as the custom SDA. <br>
<a href=""><img src="screenshots/hi/2.png" height="400"></a>

# Viewing SDA Extensions in Clinical Viewer 
Install to unlock Clinical Viewer functonality: [SDA Extension Tool Viewer](https://openexchange.intersystems.com/package/SETI-Viewer-1)
## Extend SDA
SDA Studio will automatically create a transform that can be applied to a column. We do not automatically add a column, because that interfers with Layout Editor customization we felt was best left up to the user. The following steps show how to apply that transform to a column and change the name of a column. We use the example of adding **"Sneeziness" to "Allergies"**. <br> <br>
1 - Navigate to a patient in the Clinical Viewer. <br>
2 -	Click on the wrench icon in the upper right corner. Then click “Layout Picker” on the Allergies table. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture1.png" height="30"></a> <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture2.png" height="150"></a> <br>
3 -	Click on the three blue dots next to any layout with Owner “System”. Then click “Copy. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture3.png" height="300"></a> <br>
4 -	Name it “CustomAllergy”. Then click “Update”. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture4.png" height="300"></a> <br>
5 -	Click on the three blue dots next to the “CustomAllergy” layout. Then click “Create Preference for Current User". Then click “Update”.<br> 
<a href=""><img src="screenshots/extensions-to-viewer/Picture5.png" height="300"></a> <br>
6 -	Click on the wrench icon again. This time select “Layout Editor” on the Allergies table. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture6.png" height="200"></a> <br>
7 -	Select a table item that you don’t need. Drag it over to the list, to where any “plus-sign” is. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture7.png" height="300"></a> <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture8.png" height="300"></a> <br>
8 -	Click on the pencil icon on the table item. Then select your Transform from the drop-down. Click "File" -> “Save”. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture9.png" height="100"></a> <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture10.png" height="300"></a> <br>
9 -	Go back to the Chart. Click the wrench icon again. Click on the “Layout Picker” on the Allergies table. <br>
10 -	Click on “Translation Workbench”. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture11.png" height="150"></a> <br>
11 - Scroll down until you find the table item you selected. Add “Sneeziness” to the "Component Specific Translation”. If "Component Specific Translation" has been filled, it would be safest to go back to (7) and select a different table item. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture12.png" height="150"></a> <br>
12 - Click “Update”. Then “Back to: Layout Picker”. Click “Update” again. <br>
13 - The “Sneeziness” property will now have been added. <br>
<a href=""><img src="screenshots/extensions-to-viewer/Picture13.png" height="150"></a>
## Custom SDA
Custom SDA that is added with the Clinical Viewer checkbox checked will become a new tab. Custom SDA properties that are added with the Clinical Viewer checkbox checked will become new columns for that tab. <br>
<a href=""><img src="screenshots/custom-to-viewer/1.png" height="400"></a>

# Technical Overview
The Technical Overview describes what is generated when you use SDA Studio. Compilation steps are not outlined, but you can assume they are done in the right order.
## Extend SDA
* Property called {PropertyName} of type {PropertyType} is added to HS.Local.SDA3.{SDA}Extension.
* SETI.Objects.Extension object to display on the dashboard.<br> <br>
**If Health Insight:**<br> 
* Property called {PropertyName} of type {PropertyType} is added to HSAA.Local.{SDA}Extension.<br> <br>
**If Clinical Viewer:**<br>
* All the non-Health Insight changes are also done in Viewer.
* Transformation method called {SDA}{PropertyName}Transformation in HS.Local.User.ExtensionToViewer that fetches the column values. 
* Transformation in TrakCare (websys.Transform object) that calls the transformation method.
## Custom SDA
* Custom SDA data class called HS.Local.User.Z{SDA}. 
* If custom plural, two methods in the custom SDA data class that declare the start and the end of XML tags.
* Custom SDA streamlet called HS.Local.User.Streamlet.Z{SDA}.
* If no container yet, a container called "HS.Local.User.ZContainer". All the lists of custom SDAs are in this class. 
* If no container yet, registers the container in HSREGISTRY with key "\CustomSDA3Container". 
* SETI.Objects.Custom object to display on the dashboard<br> <br>
**If Health Insight:**<br>
* Analogous Health Insight data class called HS.Local.SDA3.{SDA}HI. 
* Registers analogous Health Insight data class in Health Insight. <br> <br>
**If Clinical Viewer:**<br>
* All the non-Health Insight changes are also done in Viewer.
* Data class with a method that forwards data to the CSP page called HS.Local.User.{SDA}ToViewer.
* CSP page in /CSP/healthshare/hsviewer that is displayed in Viewer.
* CSP caller method in HS.Local.User.{SDA}ToViewer that calls the CSP page from TrakCare.
* Creates chart in TrakCare with CustomURLExpression set to the CSP caller method.
* Adds to the HS-Doctor chartbook as first in sequence.
## Custom SDA Property
* Property called {PropertyName} of type {PropertyType} is added to HS.Local.User.Z{SDA}. 
* SETI.Objects.Property object to display on the dashboard.<br> <br>
**If Health Insight:**<br> 
* Property called {PropertyName} of type {PropertyType} is added to HS.Local.User.Z{SDA}HI.<br> <br>
**If Clinical Viewer:**<br>
* All the non-Health Insight changes are also done in Viewer.
* The data class, CSP page and CSP caller method are recreated to include the new property. 

# Setup Overview
The Setup Overview describes all the changes that are made to HealthShare when you run zpm. 
## zpm "install seti"
### Module.xml
* Imports SETI package into HSCUSTOM
* REST Api "/dispatch" that communicates with SETI.Disaptch
* Page on "/seti" that displays angular app in {UCR folder}/CSP/sda-studio
* Imports sda-studio into {UCR folder}/CSP/sda-studio <br>
### SETI.Install
* Map SETI.CSP to HSREGISTRY
* Map ^customsda global to HSANALYTICS
* Recompile SETI.CSP in HSREGISTRY
* Add SDAStudio option to GetRegistryManagment() in HS.UI.Home, if it hasn't been added yet.
* Edit path of of "/seti" page to link to {UCR folder}/CSP/sda-studio/dist/sda-studio, which is the ng build version of seti. <br>
### SETI.Ports
* Set ^ucrPort and ^viewerPort globals
* Change XData of SETI.CSP.SDAStudio to call CSP page using ^ucrPort
## zpm "install seti-viewer"
### Module.xml
* Imports SETI package into HSCUSTOM
* Import SETIViewer package into HSCUSTOM
* REST Api "/dispatch" that communicates with SETI.Dispatch
### SETIViewer.Setup.Install
* Map SETIViewer to HSVIEWER
* Map ^extension global to HSVIEWER
* Recompile SETI.Viewer in HSVIEWER
* Rest Api "/dispatchviewer" that communicates with SETIViewer.DispatchViewer

# Class Reference
There are two main packages: **SETI & SETIViewer**. SETI is availible in both UCR and Viewer. SETIViewer is only availible in Viewer. <br> <br>
There are two differences between the SETI package in UCR and Viewer:<br> 
1 - The SETI.CSP & SETI.Setup folders are only availible in UCR. These folders are used for setting up SDA Studio and Health Insight functonality. <br>
2 - In Viewer, SETI.Dispatch has all of the Health Insight values equal to false. <br>
These are to prevent any use of functonality that is only availible in UCR, such as Health Insight.  <br>
<br>
It is advantageous to **use SDA Studio over calling methods to add SDA extensions**. Most importantly Health Insight and Clinical Viewer are on different instances. You cannot make adjustments to both instances with one method call, since you cannot switch between instances in a method. SDA Studio can make API calls to both instances, such that analogous methods are called in each instance. So using SDA Studio will almost always be more efficent **unless you only use either Health Insight or Clinical Viewer**. Then switching between instances is irrelevant, since you only need to use one instance. <br>

## SETI.SDAExtensions
The SDAExtenisons folder encompasses the methods that are actually used to modify and create new SDA classes. It recompiles the SDA classes in the correct order. It also adds any registration (ie. Heatlth Insight registration, Custom Container registration) that you would normally have to add in the Managment Portal. <br>
### SETI.SDAExtensions.Custom <br>
* **ClassMethod CustomSDA(sda As %String, healthInsight As %Boolean = 0, customPlural As %String = "", infotype As %String = "PRC", dateProperty As %String = "EnteredOn", matchings As %String = "")** <br> 
Creates a new custom SDA data class, a custom SDA streamlet and a custom SDA container, if one does not already exist. If healthInsight = 1, it will also create an analogous Health Insight class and registers it in Health Insight. The new classes will be in the HS.Local.User folder. 
* **ClassMethod CustomAddProperty(sda As %String, propertyName As %String, propertyType As %String, hi As %Boolean = 0)** <br>
Create a new property on a custom SDA data class. If hi = 1, it will also add that property onto the analogous Health Insight class.
### SETI.SDAExtensions.Extension <br>
* **ClassMethod ExtendSDA(sda As %String, propertyName As %String, propertyType As %String, healthInsight As %Boolean = 0)** <br>
Extends an existing SDA by using the provided extensions class. Each SDA has a corresponding extension class with no properties by default. These extension classes are located in HS.Local.SDA3. There are also analogous Health Insight extension classes in HSAA.Local. If healthInsight = 1, it will also add to that HSAA.Local class.
### SETI.SDAExtensions.Reset <br>
* **ClassMethod ResetExtendSDA()** <br>
Reset every predefined SDA extension class. This includes every class in HS.Local.SDA3 and every class in HSAA.Local.
* **ClassMethod ResetCustomSDA()** <br>
Delete every custom SDA class. Also deletes the container and the custom container registration. It does this by deleting every class HS.Local.User. This includes all the SETIViewer classes that were stored in HS.Local.User. So, do not use this method unless you want those to be deleted too. In general, using any of these methods individually is less safe than doing a full reset. 
* **ClassMethod ResetHIRegistration()** <br>
Remove ever key that that was registered in Health Insight.
* **ClassMethod ResetObjects()** <br>
Resets the objects in SETI.Objects. Thus, also clears the dashboard in SDA Studio.
* **ClassMethod ResetAllSDA()** <br>
Calls the four previous reset methods.
* **ClassMethod ResetPatientsAndSDA()** <br>
The reset method that is called in SDA Studio. It calls the DeleteAllPatients method and then the RestAllSDA method. 

## SETIViewer.SDAExtensions
The analogous Viewer folder to the other SDAExtensions folder. The classes are all related to propogating visiblity to the Clinical Viewer. <br> While this folder is also in the HSCUSTOM namespace, it is used exclusivley in the HSVIEWER namespace. That is where the web app is set up to do API calls to. The only reason why it is even in the HSCUSTOM namespace is because of how we chose to handel the installation of the package. We chose to use package mapping over having the user run zpm in two different namespaces with yet another folder. <br>
### SETIViewer.SDAExtensions.Custom
* **ClassMethod CreateViewerTab(custom As %String, customPlural As %String)** <br>
Creates a new chart with custom SDA from scratch.
* **ClassMethod UpdateViewerTab(custom As %String)** <br>
When you've added a new property to a custom SDA class, the Clinical Viewer will not update automatically. Instead we need to recreate the embeded CSP page that we created. Luckily there are methods that do this automatically for us. So to update the Clinical Viewer page, just run this method.
* **ClassMethod CreateDataClass(custom As %String)** <br>
Create a data class that forwards data to a CSP page. Writes the rows for the table that will be displayed in the Clinical Viewer tab. It uses the aggregation key from the patient using ##class(web.SDA3.Loader).GetAgKey(id), where id is the session data that is passed in from the CSP page. This is the most complicated part of getting custom SDA to display in Clinical Viewer. Like all the other custom class, these will be located HS.Local.User. 
* **ClassMethod CreateCSPPage(custom As %String)** <br>
Creates CSP page in the HSVIEWER CSP folder. This is the page that is actually displayed within the chart when you click on a custom SDA tab. If you want to change the look of the custom SDA CSP pages, then this would be the method to change. We can write the column headers, since they are patient independant. At the end of the page, we call the data class that we created, giving it the patient data with $g(%session.Data(""PatientID"")).
* **ClassMethod CreateCSPCaller(custom As %String)** <br>
Creates a method that calls the CSP page. This is just a simple way for the TrackCare chart to be able to access the CSP page. We change directories to get to the CSP directory, then call the page. 
* **ClassMethod ChartTrackCare(custom As %String, customPlural As %String)** <br>
Creates a new chart in TrakCare. By default, the chart will always be below Chart Summary. It is added as being the first in order. Then the rest are filtered using recency. Set its CustomChartExpression to the CSPCaller method.

### SETIViewer.SDAExtensions.Extension
* **ClassMethod CreateTransformTrakCare(extension As %String, sda As %String)** <br>
Create a transform in TrakCare. This creates the transform that can be applied to columns. It calls the transform class and gets the row ID using $g(rs.Data(""RowID"")). 
* **ClassMethod CreateTransformClass(extension As %String, sda As %String)** <br>
Create the class that gets the data from the patient. It gets the infotype from the SDA streamlet. Then it uses that & the row ID from TrakCare to get the streamletID for the patient's property we want to display. 
### SETIViewer.SDAExtensions.Reset
* **ClassMethod ResetCharts()** <br>
Delete the charts in TrakCare & HealthShare we created.
* **ClassMethod ResetCSPPages()** <br>
Delete the CSP pages we created.
* **ClassMethod ResetTransforms()** <br>
Delete the transformations from TrakCare. 
* **ClassMethod Reset()** <br>
Reset the Clinical Viewer enviroment.

## For SDA Studio
### SETI.CSP.SDAStudio <br>
When you click on SDA Studio in the Managment Portal, this is the CSP page that is called. During the setup, it overwrites the XData to include an iframe containing the link to the web app for SDA Studio. The code for the Managment Portal header is readily availible in other CSP pages. So having the angular page inside a CSP page means we can just copy the code for the Managment Portal from another CSP page.

### SETI.Objects.CustomObject // SETI.Objects.ExtensionObject // SETI.Objects.PropertyObject <br>
These are persistent objects that store the data for SDA extensions created in SDA Studio. They are the data that is being called when you look at the dashboard in SDA Studio.

# IRIS for Health
SETI in theory works on IRIS for Heatlh. The only caveat is that it will not integrate SDA Studio directly into the Managment Portal. IRIS for Health does not have a HealthShare Managment tab and no HSREGISTRY CSP directory. You can access the same page as described in the SDA Studio section, except without the Managment Portal header. To open SDA Studio, visit:  http://localhost:{insert-iris-for-health-port}/seti/index.html <br>
Clicking the Health Insight & Clinical Viewer checkboxes will not cause problems, but may create unnessecary files. These are best left untouched, if you are not using IRIS for Heatlth <br>
You can also add new SDA extensions using the methods as described in the [Class Reference](#class-reference). Unlike HealthShare we do not need to worry about propogating to different instances. <br>


