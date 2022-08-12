Class SETI.Tester
{

/// Extension: Sneeziness to Allergy.
ClassMethod ExtendTest(hi As %Boolean = 0)
{
    do ##class(SETI.SDAExtensions.Extension).ExtendSDA("Allergy", "Sneeziness", "%String", hi)
    if (hi) {
        do ##class(SETI.Patient).TestPatient("Sneeziness")
    }
}

/// Custom: Transplant.
ClassMethod CustomTest(hi As %Boolean = 0)
{
    do ##class(SETI.SDAExtensions.Custom).CustomSDA("Transplant", hi)
    do ##class(SETI.SDAExtensions.Custom).CustomAddProperty("Transplant", "OrganType", "%String", hi)
    if (hi) {
        do ##class(SETI.Patient).TestPatient("Transplant")
    }
}

/// Simpler version of the test.
/// Extension: Sneeziness to Allergy.
/// Custom: Transplant.
ClassMethod SimpleTest(hi As %Boolean = 0)
{
    do ##class(SETI.SDAExtensions.Extension).ExtendSDA("Allergy", "Sneeziness", "%String", hi)
    do ##class(SETI.SDAExtensions.Custom).CustomSDA("Transplant", hi)
    do ##class(SETI.SDAExtensions.Custom).CustomAddProperty("Transplant", "OrganType", "%String", hi)
    if (hi) {
        do ##class(SETI.Patient).TestPatient("Both")
    }
}

/// Build classes for tests.
/// 1. Extensions to existing SDA:
/// Sneeziness property on Allergy. MomAddressNumber on Address.
/// 2. Custom SDA:
/// Transplant. Diagnosis. Amputation.
ClassMethod Test(hi As %Boolean = 0)
{
    // 1. ExtendSDA
    do ##class(SETI.SDAExtensions.Extension).ExtendSDA("Allergy", "Sneeziness", "%String", hi)
    do ##class(SETI.SDAExtensions.Extension).ExtendSDA("Address", "MomAddressNumber", "%Integer", hi)
    // 2. CustomSDA
    do ##class(SETI.SDAExtensions.Custom).CustomSDA("Transplant", hi)
    // customPlural
    do ##class(SETI.SDAExtensions.Custom).CustomSDA("Diagnosis", hi, "Diagnoses")
    // infoType, dateProperty, matchings
    do ##class(SETI.SDAExtensions.Custom).CustomSDA("Amputation", hi, , "AMP", "DateIs", "AMP")
}

/// Reset all tests.
ClassMethod Reset()
{
    do ##class(SETI.SDAExtensions.Reset).ResetPatientsAndSDA()
}

}
