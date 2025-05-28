Class dc.FhirBridge.BO.CSVtoFHIRBundle Extends Ens.BusinessOperation
{

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As Ens.StreamContainer, Output pResponse As Ens.StreamContainer) As %Status
{
	Set tSC = $$$OK
    //Set pResponse = ##class(Ens.Response).%New()
	Try {
        // Initialize CSV data array
        set CSVData = ##class(%DynamicArray).%New()

        set stream = pRequest.Stream
        if '$isobject(stream) {
            throw ##class(%Exception.General).%New("No stream found in Ens.StreamContainer")
        }
        
        //init bundle 
        set bundle = ##class(HS.FHIRModel.R4.Bundle).%New()
        set bundle.type = "batch"
        do bundle.IncludeEntry()                  
        set bundleentry = ##class(HS.FHIRModel.R4.BundleX.SeqOfBundleXEntry).%New()                  
        set headers = stream.ReadLine()
        set headerArray = $listfromstring(headers, ",")
        
        while 'stream.AtEnd {
            set line = stream.ReadLine()
            if line '= "" {                
                set values = $listfromstring(line, ",")
                //get first column
                set CSVresource = $ZCONVERT($listget(values, 1),"L")
                if CSVresource = "patient"
                {
                   set resource = ..CreatePatientResource(headers,line)
                }
                elseif CSVresource = "observation"
                {
                    set resource = ..CreateObservationResource(headers,line)
                }
                }
                
                //create bundle entry
                set entry = ##class(HS.FHIRModel.R4.BundleX.Entry).%New()                 
                set entry.resource = resource
                set request = ##class(HS.FHIRModel.R4.BundleX.Request).%New()
                if CSVresource = "patient"
                {
                    set request.method = "PUT"
                    set rid = resource.fhirID 
                    set request.url = $ZConvert($Extract(CSVresource, 1), "U")_$Extract(CSVresource, 2, *)_"/"_rid
                } 
                else
                {
                    set request.method = "POST"                    
                    set request.url = $ZConvert($Extract(CSVresource, 1), "U")_$Extract(CSVresource, 2, *)
                }
                
                set entry.request = request  
                do bundleentry.add(entry)               
               
            }          
                                 
        set bundle.entry = bundleentry          
        set bundleDao = bundle.toDao()
        set ptJson = bundleDao.%ToJSON()
      
        //format JSON
        set formattedJSON = ##class(dc.FhirBridge.util).FormatJson(ptJson)

        Set stream = ##class(%Stream.GlobalCharacter).%New()
        Do stream.Write(formattedJSON)
        Set pResponse = ##class(Ens.StreamContainer).%New()
        Set pResponse.Stream = stream        
       
    }
    Catch (ex) {
		Set tSC = ex.AsStatus()
	    }
    Quit tSC
}

/// Description
ClassMethod CreatePatientResource(headers As %String, line As %String) As HS.FHIRModel.R4.Patient
{
    // do something
    set headerArray = $listfromstring(headers, ",")
    set values = $listfromstring(line, ",")
    //Create patient resource
    #dim patient As HS.FHIRModel.R4.Patient
    set patient = ##class(HS.FHIRModel.R4.Patient).%New()
    // Map values to headers, start form 2nd colums as 1st column is resource type
    for i=1:1:$listlength(headerArray) {
        //convert fieldName into lower char
        set fieldName = $ZCONVERT($listget(headerArray, i),"L")
        If (fieldName = "firstname") {
            Do patient.IncludeName()
            set name = patient.name.MakeEntry()
            Do name.IncludeGiven()
            Do name.given.add($listget(values, i))
            
        } ElseIf (fieldName = "familyname") {
            set name.family = $listget(values, i)
            Do patient.name.add(name)
            Do patient.name.get(0).put("use","official")
        } Elseif ((fieldName = "gender")) {
            set patient.gender = $listget(values,i)                    
        } Elseif ((fieldName = "birthdate")) {
            set patient.birthDate = $listget(values,i)
        } Elseif ((fieldName = "patientid")) {
            set patient.fhirID = $listget(values,i)    
        }    
    }
    Return patient
}

/// Description
ClassMethod CreateObservationResource(headers As %String, line As %String) As HS.FHIRModel.R4.Observation
{
    // do something
    set headerArray = $listfromstring(headers, ",")
    set values = $listfromstring(line, ",")
    //Create patient resource
    #dim observation As HS.FHIRModel.R4.Observation
    set Observation = ##class(HS.FHIRModel.R4.Observation).%New()
    // Map values to headers, start form 2nd colums as 1st column is resource type
    for i=1:1:$listlength(headerArray) {
        //convert fieldName into lower char
        set fieldName = $ZCONVERT($listget(headerArray, i),"L")
        If (fieldName = "status") {
            set Observation.status = $listget(values, i)
        }
        elseIf (fieldName = "code_system") {
            Set code = ##class(HS.FHIRModel.R4.CodeableConcept).%New()
            do code.IncludeCoding()
            Set coding = ##class(HS.FHIRModel.R4.Coding).%New()         
            Set coding.system = $listget(values, i)
            //get two next values from csv file and increament i accordingly         
            Set coding.code = $listget(values, i + 1)         
            Set coding.display = $listget(values, i + 2)         
            Do code.coding.add(coding)         
            Set Observation.code = code         
            set i = i + 2         
        }
        elseif(fieldName = "subject_reference")
        {
            Set subject = ##class(HS.FHIRModel.R4.Reference).%New()
            Set subject.reference = $listget(values, i)
            Set Observation.subject = subject
        }
        elseIf (fieldName = "value") {
            Set value = ##class(HS.FHIRModel.R4.Quantity).%New()
            Set value.value = $listget(values, i)
            Set value.unit = $listget(values, i + 1)
            Set value.system = $listget(values, i + 2)
            Set value.code = $listget(values, i + 3)
            set i = i + 3
            Set Observation.valueQuantity = value
        }
    }
    Return Observation
}

}
