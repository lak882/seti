/// Stores custom property objects on the dashboard.
Class SETI.Objects.PropertyObject Extends %Persistent
{

Property SDA As %String;

Property PropertyName As %String;

Property PropertyType As %String;

Property HealthInsight As %Boolean;

Property ClinicalViewer As %Boolean;

Method %OnNew(sda As %String, propertyName As %String, propertyType As %String, healthInsight As %Boolean, clinicalViewer As %Boolean) As %Status
{
    set ..SDA = sda
    set ..PropertyName = propertyName 
    set ..PropertyType = propertyType
    set ..HealthInsight = healthInsight 
    set ..ClinicalViewer = clinicalViewer

    set valid = ..%ValidateObject()
    return valid
}

Storage Default
{
<Data name="PropertyObjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDA</Value>
</Value>
<Value name="3">
<Value>PropertyName</Value>
</Value>
<Value name="4">
<Value>PropertyType</Value>
</Value>
<Value name="5">
<Value>hi</Value>
</Value>
<Value name="6">
<Value>cv</Value>
</Value>
<Value name="7">
<Value>HealthInsight</Value>
</Value>
<Value name="8">
<Value>ClinicalViewer</Value>
</Value>
</Data>
<DataLocation>^SETI.Objects.PropertyObjectD</DataLocation>
<DefaultData>PropertyObjectDefaultData</DefaultData>
<IdLocation>^SETI.Objects.PropertyObjectD</IdLocation>
<IndexLocation>^SETI.Objects.PropertyObjectI</IndexLocation>
<StreamLocation>^SETI.Objects.PropertyObjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
