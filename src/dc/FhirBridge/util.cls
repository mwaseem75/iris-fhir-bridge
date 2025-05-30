Class dc.FhirBridge.util Extends %Persistent
{

/// Description
ClassMethod GetSDAFromHL7(pRequest As EnsLib.HL7.Message) As %Stream.GlobalCharacter
{
    Set status = ##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(pRequest, .sdaStream)
    // do something
    quit sdaStream
}

ClassMethod FormatJson(jsonObject) [ Language = python ]
{
    import json
    try:
        data = json.loads(jsonObject)
        formatted_json = json.dumps(data,indent=4, sort_keys=False)
        return formatted_json
    except json.JSONDecodeError as e:
        return f"Error: Invalid JSON - {str(e)}"
}

ClassMethod GetResourceType(pRequest As Ens.StreamContainer) As %String
{
    
    // do something
    set stream = pRequest.Stream
    if '$isobject(stream) {
            throw ##class(%Exception.General).%New("No stream found in Ens.StreamContainer")
    }
    set headers = stream.ReadLine()    
    set line = stream.ReadLine()         
    set values = $listfromstring(line, ",")       
    set CSVresource = $ZCONVERT($listget(values, 1),"L")
    return CSVresource
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
