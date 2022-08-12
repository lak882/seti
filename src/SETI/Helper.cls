Class SETI.Helper
{

/// Add Property to the Class.
/// Ex: do ##class(SETI.Helper).AddProperty("HS.Local.SDA3.AllergyExtension", "Sneeziness", "%String")
ClassMethod AddProperty(className As %String, propertyName As %String, propertyType As %String, isList As %Boolean = 0)
{
    // open the class
    Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)

    // create new property
    Set extName = $piece(className, ".", *)
    Set pdef = ##class(%Dictionary.PropertyDefinition).%New(extName _ ":" _ propertyName)

    // define property type
    Set pdef.Type = propertyType

    if (isList = 1) {
        Set pdef.Collection = "list"
    }

    // insert the property into the class
    Do cdef.Properties.Insert(pdef)
    // save the class
    Do cdef.%Save()
}

/// Add Parameter to the Class.
/// Ex: do ##class(SETI.Helper).AddParameter("HS.Local.SDA3.AllergyExtension", "Sneeziness", "High")
ClassMethod AddParameter(className As %String, parameterName As %String, parameterValue As %String)
{
    // open the class
    Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)

    // create new parameter
    Set extName = $piece(className, ".", *)
    Set pdef = ##class(%Dictionary.ParameterDefinition).%New(extName _ ":" _ parameterName)

    // set parameter value
    Set pdef.Default = parameterValue
    
    // insert the parameter into the class
    Do cdef.Parameters.Insert(pdef)
    // save the class
    Do cdef.%Save()
}

/// Add a custom plural to the XML of class.
/// Ex:
/// Name: Diagnosis. Custom Plural: Diagnoses.
ClassMethod XMLCustomPlural(ByRef cdef As %Dictionary.ClassDefinition, customPlural As %String)
{
    // Set XML for the end and the start of the stream
    Set startXML = ##class(%Dictionary.MethodDefinition).%New("")
    Set startXML.Name = "StartXMLList"
    Set startXML.ClassMethod = 1
    Set str = ##class(%Stream.TmpCharacter).%New()
    do str.WriteLine("  Quit ""<" _ customPlural _ ">""")
    Set startXML.Implementation = str

    Set endXML = ##class(%Dictionary.MethodDefinition).%New("")
    Set endXML.Name = "EndXMLList"
    Set endXML.ClassMethod = 1
    Set str = ##class(%Stream.TmpCharacter).%New()
    do str.WriteLine("  Quit ""</" _ customPlural _ ">""")
    Set endXML.Implementation = str      

    // Use as the inital methods for the custom SDA
    do cdef.Methods.Insert(endXML) 
    do cdef.Methods.Insert(startXML)
    set s = cdef.%Save()
    do $system.Status.DisplayError(s)
}

/// Return True if dataType is part of the HS.SDA3 package
ClassMethod IsSDA3(dataType As %String) As %Boolean
{
    if ($PIECE(dataType, ".", 1) = "HS") {
        if ($PIECE(dataType, ".", 2) = "SDA3") {
            Return 1
        }
    }
    Return 0
}

/// Register any class in HS.Local to Health Insight.
/// HS.Local is automapped to HSANALYTICS
/// 
/// Parameters:
/// sourceClassName: original SDA3 class
/// hiClassName: analgous Health Insight class
ClassMethod RegisterInHealthInsight(sourceClassName As %String, hiClassName As %String, unregister As %Boolean = 0)
{
    // use class in HSANALYTiCS namespace
    try {
        zn "HSANALYTICS"
        // wether or not you want to unregister the class
        if (unregister) {
            set s = ##class(HSAA.TransferSDA3.Utils).UnregisterCustomClassMapping(sourceClassName, hiClassName)
        } else {
            set s = ##class(HSAA.TransferSDA3.Utils).RegisterCustomClassMapping(sourceClassName, hiClassName)
        }
        if (s = 1) {
            write !, "Health Insight Registration worked"
        } else {
            write !, "Health Insight Registration failed"
        }
        zn "HSCUSTOM"
    } catch {
        zn "HSCUSTOM"
        write !, "RegisterInHealthInsight: Switching to HSANALYTICS failed."
    }
}

/// Clear the properties of every class in a package.
ClassMethod ClearPropertiesInClasses(packageName As %String)
{
    do ##class(%SYSTEM.OBJ).GetPackageList(.result, packageName)

    // get the first class name
    set className = $Order(result(""))

    while (className '= "") {
        // get result at key
        set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
        // clear the properties
        do cdef.Properties.Clear()
        do cdef.%Save()

        // find next node
        set className = $Order(result(className))
    }

    //recompile package
    do $system.OBJ.CompilePackage(packageName, "ck")
}

/// Restart the productions that will update Health Insight.
ClassMethod RestartProductions()
{
    // restart HSANALYTICS production  interrupt service
    try {
        zn "HSANALYTICS"
        // disable, then enable
        do ##class(Ens.Director).EnableConfigItem("HSAA.TransferSDA3.Service.Interrupt", 0)
        do ##class(Ens.Director).EnableConfigItem("HSAA.TransferSDA3.Service.Interrupt", 1)
        zn "HSCUSTOM"
    } catch {
        zn "HSCUSTOM"
        write !, "RestartProductions: Switching to HSANALYTICS failed."
    }

    // restart HSHIFEEDER production analytics transmit service
    try {
        zn "HSHIFEEDER"
        // disable, then enable
        do ##class(Ens.Director).EnableConfigItem("HS.Gateway.Analytics.TransmitService", 0)
        do ##class(Ens.Director).EnableConfigItem("HS.Gateway.Analytics.TransmitService", 1)
        zn "HSCUSTOM"
    } catch {
        zn "HSCUSTOM"
        write !, "RestartProductions: Switching to HSANALYTICS failed."
    }
}

/// Find the corresponding data types for every HS.SDA3 class
ClassMethod SetHITypes()
{
    kill ^HITypes
    kill ^HISerial
     
    do $system.OBJ.GetPackageList(.classes, "HS.SDA3", "-r")
    set className = $Order(classes(""))
    
    // set %String
    set ^HITypes("%String") = "%String"

    while (className '= "") {
        set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
        set name = $PIECE(className, ".", 3)

        // basic data types: Numeric, Boolean
        if ($PIECE(cdef.Super, ".", 1) = "HS") && ($PIECE(cdef.Super, ".", 2) = "Types") {
            set hsaaClassName = "HSAA.Internal." _ name
            if (##class(%Dictionary.ClassDefinition).%ExistsId(hsaaClassName)) {
                set ^HITypes(className) = hsaaClassName
            } 
        }
        

        // do not include bases for other SDA
        if ((name = "SuperClass") || (name = "CodeTableDetail") || (name = "CodeTableExtension") || (name = "CodeTableTranslated") || (name = "DataType")) {
            set className = $Order(classes(className))
            continue
        }

        // TODO: implement custom serial objects
        #; // serial objects
        #; if ($CLASSMETHOD(className, "%Extends", "%SerialObject")) {
        #;     set hsaaClassName = "HSAA." _ name
        #;     if (##class(%Dictionary.ClassDefinition).%ExistsId(hsaaClassName)) {
        #;         set ^HITypes(className) = hsaaClassName
        #;     } else {
        #;         set hsaaClassName = "HSAA.Internal." _ name
        #;         if (##class(%Dictionary.ClassDefinition).%ExistsId(hsaaClassName)) {
        #;             set ^HITypes(className) = hsaaClassName
        #;         } else {
        #;             set hsaaClassName = "HSAA.Internal.Interface." _ name
        #;             if (##class(%Dictionary.ClassDefinition).%ExistsId(hsaaClassName)) {
        #;                 set ^HITypes(className) = hsaaClassName
        #;             }
        #;         }
        #;     }
        #; }

        set className = $Order(classes(className))
    }
}

/// Convert a varibale to a JSON string.
/// 
/// set s("name") = "Ella"
/// set s("zip") = 02138
/// 
/// write varToJson(s) 
/// {'Name' : "Ella"}, {'zip' : 02138}
ClassMethod VarToJSON(ByRef var) As %String
{
    set json = ""
    set key = $ORDER(var(""))

    if (key = "") {
        write ""
    }

    set json = json _ "{""" _ key  _""":""" _ var(key) _ """ " 
    set key = $ORDER(var(key))

    while (key '= "") {
        set json = json _ ", """ _ key  _""":""" _ var(key) _ """ "
        set key = $ORDER(var(key))
    }
    set json = json _ "}"

    return json
}

}
