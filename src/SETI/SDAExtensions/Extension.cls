Class SETI.SDAExtensions.Extension
{

/// Extend an exsisting SDA object by using the provided extension class.
/// Each SDA class has corresponding extension object class with no properties by default.
/// 
/// Parameters:
/// sda: sda being extended
/// propertyName: name of property to add to SDA
/// porpertyType: type of property to add to SDA
/// 
/// 1. Add property to extension class.
/// 2. Recompile classes
/// 3. Populate extension properties.
/// 4. Health Insight.
/// 4.1. Make analgous SDA extension changes in Health Insight.
/// 4.2. If SerialObject, register in Health Insight.
/// 4.3. Restart Productions.
/// 
/// Ex:
/// HS.SDA3.Allergy corresponds to HS.Local.SDA3.AllergyExtension.
/// Add Sneeziness As %String property.
/// do ##class(SETI.SDAExtensions.Datatypes).ExtendSDA("Allergy", "Sneeziness", "%String")
ClassMethod ExtendSDA(sda As %String, propertyName As %String, propertyType As %String, healthInsight As %Boolean = 0)
{
    // 1. Add property to extension class.
    // get the class name of the extension
    set className = "HS.Local.SDA3." _ sda _ "Extension"
    do ##class(SETI.Helper).AddProperty(className, propertyName, propertyType)

    // 2. Recompile classes.
    set parentClassName = "HS.SDA3." _ sda
    do $system.OBJ.Compile(parentClassName, "ck")
    do $system.OBJ.Compile(className, "ck")

    // 3. Populate extension properties.
    // TODO: get XML schema from user and import it
    
    // 4. Health Insight
    if (healthInsight) {

        // 4.1. Get analogous HSAA type.
        set hsaaPropertyType = ^HITypes(propertyType)

        // 4.2 If SerialClass, register analogous types in HealthInsight.
        // TODO: implement custom Serial Objects

        // 4.3. Make analgous SDA extension changes in Health Insight.
        // make changes to HSAA.Local
        set hsaaClassName = "HSAA.Local." _ sda _ "Extension"
        do ##class(SETI.Helper).AddProperty(hsaaClassName, propertyName, hsaaPropertyType)
        do $system.OBJ.Compile(hsaaClassName, "ck")

        // compile the classes in the HSAALIB namespace in HSAA.
        try {
            zn "HSAALIB"
            set libClassName = "HSAA." _ sda
            do $system.OBJ.Compile(libClassName, "ck")
            zn "HSCUSTOM"
        }
        catch {
            zn "HSCUSTOM"
            write !, "Switching to HSAALIB failed."
        }

        // 4.4 Restart Productions.
        do ##class(SETI.Helper).RestartProductions()
    }
}

}
