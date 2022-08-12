/// Stores custom objects on the dashboard.
Class SETI.Objects.CustomObject Extends %Persistent
{

Property SDA As %String;

Property CustomPlural As %String;

Property Infotype As %String;

Property DateProperty As %String;

Property Matchings As %String;

Property HealthInsight As %Boolean;

Property ClinicalViewer As %Boolean;

Method %OnNew(sda As %String, healthInsight As %Boolean = 0, clinicalViewer As %Boolean, customPlural As %String = "", infotype As %String = "PRC", dateProperty As %String = "EnteredOn", matchings As %String = "") As %Status [ Private, ServerOnly = 1 ]
{
    set ..SDA = sda
    set ..HealthInsight = healthInsight 
    set ..ClinicalViewer = clinicalViewer
    set ..CustomPlural = customPlural 
    set ..Infotype = infotype
    set ..DateProperty = dateProperty
    set ..Matchings = matchings

    set valid = ..%ValidateObject()

    return valid
}

Storage Default
{
<Data name="CustomObjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDA</Value>
</Value>
<Value name="3">
<Value>CustomPlural</Value>
</Value>
<Value name="4">
<Value>Infotype</Value>
</Value>
<Value name="5">
<Value>DateProperty</Value>
</Value>
<Value name="6">
<Value>Matchings</Value>
</Value>
<Value name="7">
<Value>HealthInsight</Value>
</Value>
<Value name="8">
<Value>ClinicalViewer</Value>
</Value>
</Data>
<DataLocation>^SETI.Objects.CustomObjectD</DataLocation>
<DefaultData>CustomObjectDefaultData</DefaultData>
<IdLocation>^SETI.Objects.CustomObjectD</IdLocation>
<IndexLocation>^SETI.Objects.CustomObjectI</IndexLocation>
<StreamLocation>^SETI.Objects.CustomObjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
