Class SETI.SDAExtensions.Reset
{

/// Reset every predefined SDA extension class.
/// 
/// 1. Clear properties of every class in HS.Local.User
/// 2. Clear properties of every class in HSAA.Local. (auto-removes analogous HSLIB class).
/// 3. Recompile HSAA in HISAALIB namespace.
/// 4. Recompile HS.SDA3
/// 
/// do ##class(SETI.SDAExtensions.Datatypes).ResetExtendSDA()
ClassMethod ResetExtendSDA()
{
    // 1. Clear properties of every class in HS.Local.User.
    // Auto-compiles package.
    do ##class(SETI.Helper).ClearPropertiesInClasses("HS.Local.SDA3")
    // Compile analogous SDA3 classes.
    do $system.OBJ.CompilePackage("HS.SDA3", "ck")

    // 2. Clear properties of every class in HSAA.Local. 
    // Auto-compiles package.
    // Auto-removes analogous HSLIB class.
    do ##class(SETI.Helper).ClearPropertiesInClasses("HSAA.Local")
    // compile analogous HSAA classes.
    try {
        zn "HSAALIB"
        do $system.OBJ.CompilePackage("HSAA", "ck")
        zn "HSCUSTOM"
    }
    catch {
        zn "HSCUSTOM"
        write !, "Switching to HSAALIB failed."
    }
}

/// Delete every custom SDA class.
/// 
/// 1. Delete every class in HS.Local.User.
/// Includes classes, health insight classes, streamlets, single container.
/// Includes clinical viewer classes.
/// 2. Remove container key.
ClassMethod ResetCustomSDA()
{
    /// 1. Delete every class in HS.Local.User.
    do ##class(%SYSTEM.OBJ).DeletePackage("HS.Local.User")

    // 2. Remove container key.
    try {
        zn "HSREGISTRY"
        do ##class(HS.Registry.Config).DeleteByName("\CustomSDA3Container")
        zn "HSCUSTOM"
    } catch {
        zn "HSCUSTOM"
        write "Switching to HSREGISTY failed."
    }

    kill ^customsda
}

/// Remove ever key that we registered in Health Insight. 
ClassMethod ResetHIRegistration()
{
    try {
        zn "HSANALYTICS"
        // clear all custom class mappings
        do ##class(HSAA.TransferSDA3.Utils).ClearAllCustomClassMappings()
        zn "HSCUSTOM"
    } catch {
        zn "HSCUSTOM"
        write !, "Switching to HSANALYTICS failed."
    }
}

/// Delete all the objects that dispaly on the dashboard.
ClassMethod ResetObjects()
{
    do ##class(SETI.Objects.CustomObject).%DeleteExtent()
    do ##class(SETI.Objects.ExtensionObject).%DeleteExtent()
    do ##class(SETI.Objects.PropertyObject).%DeleteExtent()
}

/// Reset every user custom SDA.
/// 
/// 1. Reset SDA Extensions.
/// 2. Reset Custom SDA Containers. (incl. ResetClinicalViewer)
/// 3. Reset the Health Insight Registry.
/// 4. Delete the Objects used for storing data on the dashboard.
/// 5. Restart Health Insight productions.
/// 
/// do ##class(SETI.SDAExtensions.Datatypes).ResetAllSDA()
ClassMethod ResetAllSDA()
{
    do ..ResetExtendSDA()
    do ..ResetCustomSDA() // incl. ResetClinicalViewer
    do ..ResetHIRegistration()
    do ..ResetObjects()
    do ##class(SETI.Helper).RestartProductions()
}

ClassMethod ResetPatientsAndSDA()
{
    // WARNING
    // must delete all patients before you reset the sda
    // any patient with custom SDA properties that don't exist will ecounter issues
    // the patient will get "stuck" and can't be fully deleted
    do ##class(SETI.Patient).DeleteAllPatients()
    do ..ResetAllSDA()
}

}
