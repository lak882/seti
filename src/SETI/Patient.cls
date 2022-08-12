Class SETI.Patient
{

/// Deletes All Patients in the ECR.
ClassMethod DeleteAllPatients()
{
    // Delete all custom persistent instances 
    Try {
        ZNspace "HSANALYTICS"
        // get the first class name
        // package-mapped from HSCUSTOM
        Set sda = $ORDER(^customsda(""))
        While (sda '= "") {
            // clear all instances of this persistent
            Set className = "HS.Local.User.Z" _ sda _ "HI"
            Do $CLASSMETHOD(className,"%DeleteExtent")

            // find next node
            Set sda = $ORDER(result(sda))
        }
        ZNspace "HSCUSTOM"
    } Catch {
        ZNspace "HSCUSTOM"
        Write !, "DeleteAllPatients: Switching to HSANALYTICS failed."
    }

    // Switch to the HSEDGE1 namespace to delete all the patients
    Try {
        ZNspace "HSEDGE1"
        Do ##class(HS.Gateway.ECR.PatientDelete).DeleteAll()
        ZNspace "HSCUSTOM"
    } Catch {
        ZNspace "HSCUSTOM"
        Write !, "DeleteAllPatients: Switching to HSEDGE1 failed."
    }
   
    // Delete any other "stuck" patients
    // Delete litterally anything populated in HealthInsight
    Try {  
        ZNspace "HSANALYTICS"
        Do $SYSTEM.OBJ.GetPackageList(.classList, "HSAA")
        Set class = $ORDER(classList(""))
        While (class '= "") {
            If ($CLASSMETHOD(class, "%Extends", "%Persistent")) {
                Do $CLASSMETHOD(class,"%KillExtent")
            }
            Set class = $ORDER(classList(class))
        }
        ZNspace "HSCUSTOM"
    } Catch {
        ZNspace "HSCUSTOM"
        Write !, "DeleteAllPatients: Switching to HSANALYTICS failed."
    }
    
    Do ##class(SETI.Helper).RestartProductions()
}

/// Imports a test patient and restarts Health Insight productions.
/// 
/// Parameter "kind" is part of the name of the patient file. TestPatient_{kind}.xm;
/// Patient must be in ucr/data/test and be called TestPatient_{kind}.xml.
ClassMethod TestPatient(kind As %String)
{
    // get the ucr/data directory
    Set dir = ##class(%File).ManagerDirectory()
    Set dir = ##class(%File).ParentDirectoryName(dir)
    Set data = ##class(%File).SubDirectoryName(dir, "Data")

    // get the ucr/data/test directory
    Set test = ##class(%File).SubDirectoryName(data, "Test") _ "\"

    // get the ucr/data/HSEDGE1/SDAIn directory
    Set sdain = ##class(%File).SubDirectoryName(data, "HSEDGE1")
    Set sdain = ##class(%File).SubDirectoryName(sdain, "SDAIn") _ "\"

    Set filename = "TestPatient_" _ kind _ ".xml"
    Do ##class(%File).CopyFile(test _ filename, sdain  _ filename)
    
    Hang 5 // 5 seconds to import test patient file

    Do ##class(SETI.Helper).RestartProductions()
}

}
