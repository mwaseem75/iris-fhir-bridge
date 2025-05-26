Class dc.FhirBridge.util Extends %Persistent
{

/// Description
ClassMethod GetSDAFromHL7(pRequest As EnsLib.HL7.Message) As %Stream.GlobalCharacter
{
    Set status = ##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(pRequest, .sdaStream)
    // do something
    quit sdaStream
}

Storage Default
{
<Data name="utilDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dc.FhirBridge.utilD</DataLocation>
<DefaultData>utilDefaultData</DefaultData>
<IdLocation>^dc.FhirBridge.utilD</IdLocation>
<IndexLocation>^dc.FhirBridge.utilI</IndexLocation>
<StreamLocation>^dc.FhirBridge.utilS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
