Class SETI.SDAExtensions.Custom
{

/// Create custom SDA container.
/// Using HS.Local.User, because it is automapped to HSANALYTICS (Health Insight).
/// 
/// 1. For each SDA section, define custom SDA data class.
/// 2. For each custom SDA data class, define SDA streamlet class to store data.
/// 3. Define custom SDA container, include each custom section as property.
/// 4. Register custom SDA container in configuration registry.
/// 5. Health Insight.
/// 6. Add to global.
/// 
/// Parameters:
/// sda: name of new sda without Z
/// customPlural: unique plural name for multiples of sda
/// infotype / dateProperty / matchings: data tags
/// 
/// Ex:
/// Transplants.
/// do ##class(SETI.SDAExtensions.Datatypes).CustomSDA("Transplant")
/// Diagnosis with customPlural.
/// do ##class(SETI.SDAExtensions.Datatypes).CustomSDA("Diagnosis", , "Diagnoses")
ClassMethod CustomSDA(sda As %String, healthInsight As %Boolean = 0, customPlural As %String = "", infotype As %String = "PRC", dateProperty As %String = "EnteredOn", matchings As %String = "")
{
    // 1. For each SDA section, define custom SDA data class.
    Set className = "HS.Local.User.Z" _ sda
    Set cdef = ##class(%Dictionary.ClassDefinition).%New(className)
    // extends HS.SDA3.SuperClass
    Set cdef.Super = "HS.SDA3.SuperClass"

    // setup the custom plural for XML
    if (customPlural '= "") {
        set customPlural = "Z" _ customPlural
        do ##class(SETI.Helper).XMLCustomPlural(.cdef, customPlural)
    }

    // save & compile class
    do cdef.%Save()
    do $system.OBJ.Compile(className, "ck")

    // 2. For each custom SDA data class, define SDA streamlet class to store data.
    Set streamletName = "HS.Local.User.Streamlet.Z" _ sda
    Set cdef = ##class(%Dictionary.ClassDefinition).%New(streamletName)
    do cdef.%Save()

    // extends HSAA package classes
    Set cdef.Super = "HS.SDA3.Streamlet.Abstract, %Persistent"
    Set cdef.Inheritance = "left"
    do cdef.%Save()

    // set default type for matchings
    If (matchings = "") {
        Set matchings = infotype _ "/" _ dateProperty
    }

    // set all the parameters 
    Do ##class(SETI.Helper).AddParameter(streamletName, "INFOTYPE", infotype)
    Do ##class(SETI.Helper).AddParameter(streamletName, "SDACLASS", className)
    Do ##class(SETI.Helper).AddParameter(streamletName, "DATEPROPERTY", dateProperty)
    Do ##class(SETI.Helper).AddParameter(streamletName, "MATCHINGS", matchings)

    // compile class
    do $system.OBJ.Compile(streamletName, "ck")

    // 3. Define custom SDA container, include each custom section as property.
    set containerName = "HS.Local.User.ZContainer"
    // does a container not exist yet
    set newContainer = '##class(%Dictionary.ClassDefinition).%Exists(containerName)

    // if there's no container, create new container
    // else, open existing container
    if (newContainer) {
        // create new container
        set cdef = ##class(%Dictionary.ClassDefinition).%New(containerName) 
        do cdef.%Save()
        // add XMLNAME Parameter
        do ##class(SETI.Helper).AddParameter(containerName, "XMLNAME", "Container")
        // container extends SDA3 Container
        set cdef.Super = "HS.SDA3.Container"
    } else {
        set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(containerName)
    }

    // make plural depending on wether customPlural was given
    if (customPlural = "") {
        set plural = "Z" _ sda _ "s"
    } else {
        set plural = customPlural
    }
    
    // add list property to container
    do ##class(SETI.Helper).AddProperty(containerName, plural, className, 1)

    // compile container
    do $system.OBJ.Compile(containerName, "ck")

    // 4. Register custom SDA container in configuration registry.
    // registry is in the HSREGISTRY
    if (newContainer) {
        try {
            zn "HSREGISTRY"
            do ##class(HS.Registry.Config).AddNewKey("\CustomSDA3Container", containerName)
            zn "HSCUSTOM"
        } catch {
            zn "HSCUSTOM"
            write !, "CustomSDA 4: Switching to HSREGISTY failed."
        }
    }

    // 5. Register in Health Insight
    if (healthInsight) {   
        // 5.1 Create anaglogous Health Insight class
        Set hiClassName = "HS.Local.User.Z" _ sda _ "HI"
        Set cdef = ##class(%Dictionary.ClassDefinition).%New(hiClassName)
        // extends HSAA package classes
        Set cdef.Super = "%Persistent, HSAA.Internal.SuperClass, HSAA.IndexCommonData"
        Set cdef.Inheritance = "left"

        // save & compile class
        Do cdef.%Save()
        Do $system.OBJ.Compile(hiClassName, "ck")

        // 5.2 compile in HSANALYTICS
        try {
            zn "HSANALYTICS"
            Do $system.OBJ.Compile(className, "ck")
            Do $system.OBJ.Compile(hiClassName, "ck")
            Do $system.OBJ.Compile(streamletName, "ck")
            Do $system.OBJ.Compile(containerName, "ck")
            zn "HSCUSTOM"
        } catch {
            zn "HSCUSTOM"
            write !, "CustomSDA 5: Switching to HSANALYTICS failed"
        }

        // 5.3 register in Helath Insight
        do ##class(SETI.Helper).RegisterInHealthInsight(className, hiClassName)

        // 5.4 restart productions
        do ##class(SETI.Helper).RestartProductions()
    }

    // 6. Add to custom SDAs
    set ^customsda(sda) = ""
}

/// Add property to a Custom SDA.
ClassMethod CustomAddProperty(sda As %String, propertyName As %String, propertyType As %String, hi As %Boolean = 0)
{
    // add property the class
    Set className = "HS.Local.User.Z" _ sda
    Do ##class(SETI.Helper).AddProperty(className, propertyName, propertyType)

    if (hi) {
        // add to health insight class
        Set hiClassName = "HS.Local.User.Z" _ sda _ "HI"

        set hsaaPropertyType = ^HITypes(propertyType)

        do ##class(SETI.Helper).AddProperty(hiClassName, propertyName, hsaaPropertyType)

        // compile in HSANALYTICS
        try {
            zn "HSANALYTICS"
            do $system.OBJ.CompilePackage("HS.Local.User", "ck")
            zn "HSCUSTOM"
        } catch {
            zn "HSCUSTOM"
            write !, "CustomAddProperty: Switching to HSANALYTICS failed"
        }
    }
    
    // compile in HSCUSTOM
    do $system.OBJ.CompilePackage("HS.Local.User", "ck")
}

}
