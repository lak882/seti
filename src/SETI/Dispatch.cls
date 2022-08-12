Class SETI.Dispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Add SDA Extensions. -->
<Route Url="/extend" Method="POST" Call="ExtendSDA" Cors="true"/>
<Route Url="/custom" Method="POST" Call="CustomSDA" Cors="true"/>
<Route Url="/reset" Method="POST" Call="Reset" Cors="true"/>
<Route Url="/customAddProperty" Method="POST" Call="CustomAddProperty" Cors="true"/>

<!-- Get lists for dropdowns. -->
<Route Url="/getCustomSDA" Method="GET" Call="GetCustomSDA" Cors="true"/>
<Route Url="/getExtendSDA" Method="GET" Call="GetExtendSDA" Cors="true"/>
<Route Url="/getPropertyTypes" Method="GET" Call="GetHITypes" Cors="true"/>

<!-- Get objects for dashboard. -->
<Route Url="/getExtensionObjects" Method="GET" Call="GetExtensionObjects" Cors="true"/>
<Route Url="/getCustomObjects" Method="GET" Call="GetCustomObjects" Cors="true"/>
<Route Url="/getPropertyObjects" Method="GET" Call="GetPropertyObjects" Cors="true"/>

<Route Url="/getViewerPort" Method="GET" Call="GetViewerPort" Cors="true"/>
</Routes>
}

ClassMethod ExtendSDA() As %Status
{
    set proxyObj = {}.%FromJSON(%request.Content)
    set sda = proxyObj.sda
    set propertyName = proxyObj.propertyName
    set propertyType = proxyObj.propertyType 
    // need to add HS.SDA3. to any property type that is not already added
    if (propertyType '= "%String") {
        set propertyType = "HS.SDA3." _ propertyType
    }
    set hi = proxyObj.hi 
    set cv = proxyObj.cv 
    do ##class(SETI.SDAExtensions.Extension).ExtendSDA(sda, propertyName, propertyType, hi)
    set obj = ##class(SETI.Objects.ExtensionObject).%New(sda, propertyName, propertyType, hi, cv)
    do obj.%Save()
    Quit $$$OK
}

ClassMethod CustomSDA() As %Status
{
    set proxyObj = {}.%FromJSON(%request.Content)
    set sda = proxyObj.sda
    set hi = proxyObj.hi
    set cv = proxyObj.cv
    set customPlural = proxyObj.customPlural
    set infotype = proxyObj.infotype 
    set dateProperty = proxyObj.dateProperty
    set matchings = proxyObj.matchings
    do ##class(SETI.SDAExtensions.Custom).CustomSDA(sda, hi, customPlural, infotype, dateProperty, matchings)
    set obj = ##class(SETI.Objects.CustomObject).%New(sda, hi, cv, customPlural, infotype, dateProperty, matchings)
    do obj.%Save()
    Quit $$$OK
}

ClassMethod Reset() As %Status
{
    do ##class(SETI.SDAExtensions.Reset).ResetPatientsAndSDA()
    Quit $$$OK
}

ClassMethod CustomAddProperty() As %Status
{
    set proxyObj = {}.%FromJSON(%request.Content)
    set sda = proxyObj.sda
    set propertyName = proxyObj.propertyName
    set propertyType = proxyObj.propertyType 
    if (propertyType '= "%String") {
        set propertyType = "HS.SDA3." _ propertyType
    }
    set hi = proxyObj.hi 
    set cv = proxyObj.cv 
    do ##class(SETI.SDAExtensions.Custom).CustomAddProperty(sda, propertyName, propertyType, hi)
    set obj = ##class(SETI.Objects.PropertyObject).%New(sda, propertyName, propertyType, hi, cv)
    do obj.%Save()
    Quit $$$OK
}

ClassMethod GetCustomSDA() As %Status
{
    set json = ""
    set sda = $Order(^customsda(""))
    if (sda = "") {
        write ""
    }

    set json = json _ "{""" _ sda  _ """:""""" 
    set sda = $Order(^customsda(sda))

    while (sda '= "") {
        set json = json _ ", """ _ sda  _ """:"""""
        set sda = $Order(^customsda(sda))
    }
    set json = json _ "}"

    write json

    Quit $$$OK
}

ClassMethod GetExtendSDA() As %Status
{
    do $system.OBJ.GetPackageList(.classes, "HS.Local.SDA3", "-r")
   
    set className = $Order(classes(""))

    while (className '= "") {
        set name = $PIECE(className, ".", 4)
        set name = $REPLACE(name, "Extension", "")
        set result(name) = ""
        set className = $Order(classes(className))
    }

    write ##class(SETI.Helper).VarToJSON(.result)

    Quit $$$OK
}

ClassMethod GetHITypes() As %Status
{
    // set the HI Types
    do ##class(SETI.Helper).SetHITypes()
    
    // upload all the HI Types (%String, Numeric, Boolean)
    set key = $ORDER(^HITypes(""))
    set json = "{""" _ key  _""":""" _ ^HITypes(key) _ """ " 

    set key = $ORDER(^HITypes(key))
    while (key '= "") {
        set json = json _ ", """ _ key  _""":""" _ ^HITypes(key) _ """ "
        set key = $ORDER(^HITypes(key))
    }

    // write end of JSON
    set json = json _ "}"
    w json

    Quit $$$OK
}

ClassMethod GetExtensionObjects() As %Status
{
    &sql( DECLARE C1 CURSOR FOR 
    SELECT JSON_OBJECT('sda':SDA, 'propertyName': PropertyName,  'propertyType': PropertyType, 'hi': HealthInsight, 'cv': ClinicalViewer)
    INTO :result
    FROM SETI_Objects.ExtensionObject)
    
    // open SQL cursor, quit if there is nothing
    &sql(OPEN C1)
    Quit:(SQLCODE'=0) $$$OK
    w "["

    // get & write new row as long as there are new rows
    &sql(FETCH C1)
    WRITE result
    &sql(FETCH C1)
    WHILE (SQLCODE = 0) {
        WRITE ",", !, result
        &sql(FETCH C1) }
    &sql(CLOSE C1)

    w "]"

    Quit $$$OK
}

ClassMethod GetCustomObjects() As %Status
{
    &sql( DECLARE C1 CURSOR FOR 
    SELECT JSON_OBJECT('sda':SDA, 'customPlural': CustomPlural,  'infotype' : Infotype, 'dateProperty': DateProperty, 'matchings': Matchings, 'hi': HealthInsight, 'cv': ClinicalViewer)
    INTO :result
    FROM SETI_Objects.CustomObject)
    
    // open SQL cursor, quit if there is nothing
    &sql(OPEN C1)
    Quit:(SQLCODE'=0) $$$OK
    w "["

    // get & write new row as long as there are new rows
    &sql(FETCH C1)
    WRITE result
    &sql(FETCH C1)
    WHILE (SQLCODE = 0) {
        WRITE ",", !, result
        &sql(FETCH C1) }
    &sql(CLOSE C1)

    w "]"

    Quit $$$OK
}

ClassMethod GetPropertyObjects() As %Status
{
    &sql( DECLARE C1 CURSOR FOR 
    SELECT JSON_OBJECT('sda':SDA, 'propertyName': PropertyName,  'propertyType': PropertyType, 'hi': HealthInsight, 'cv': ClinicalViewer)
    INTO :result
    FROM SETI_Objects.PropertyObject)
    
    // open SQL cursor, quit if there is nothing
    &sql(OPEN C1)
    Quit:(SQLCODE'=0) $$$OK
    w "["

    // get & write new row as long as there are new rows
    &sql(FETCH C1)
    WRITE result
    &sql(FETCH C1)
    WHILE (SQLCODE = 0) {
        WRITE ",", !, result
        &sql(FETCH C1) }
    &sql(CLOSE C1)

    w "]"

    Quit $$$OK
}

ClassMethod GetViewerPort() As %Status
{
    w "{ """ _ ^viewerPort _ """: "" "" }"

    Quit $$$OK
}


}
