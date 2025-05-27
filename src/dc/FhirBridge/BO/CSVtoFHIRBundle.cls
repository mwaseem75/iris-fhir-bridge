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
        set bundle.type = "transaction"
        do bundle.IncludeEntry()                  
        set bundleentry = ##class(HS.FHIRModel.R4.BundleX.SeqOfBundleXEntry).%New()                  
        set headers = stream.ReadLine()
        set headerArray = $listfromstring(headers, ",")
        
        //Set response = ..FhirBundleCreator(pRequest.OriginalFilename)
        while 'stream.AtEnd {
            set line = stream.ReadLine()
            if line '= "" {
                set row = ##class(%DynamicObject).%New()
                set values = $listfromstring(line, ",")
                //Create patient resource
                #dim patient As HS.FHIRModel.R4.Patient
                set patient = ##class(HS.FHIRModel.R4.Patient).%New()
                // Map values to headers
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
                    }
                   
                    set fieldName = $listget(headerArray, i)
                    set fieldValue = $listget(values, i)
                    if fieldName '= "" {
                        do row.%Set(fieldName, fieldValue)
                    }
                }
                
                do CSVData.%Push(row)
            
                //create bundle entry
                
                set entry = ##class(HS.FHIRModel.R4.BundleX.Entry).%New()                 
                set entry.resource = patient
                set request = ##class(HS.FHIRModel.R4.BundleX.Request).%New()
                set request.method = "POST"
                set request.url = "Patient"
                set entry.request = request  
                do bundleentry.add(entry)               
               
            }                                     
        }
        set bundle.entry = bundleentry          
        // Log parsed data for debugging
        //$$$LOGINFO("Parsed CSV with "_CSVData.%Size()_" rows")
        //set patientDao = patient.toDao()
        //set ptJson = patientDao.%ToJSON()

        set bundleDao = bundle.toDao()
        set ptJson = bundleDao.%ToJSON()
        
        //format JSON
        set formattedJSON = ##class(dc.FhirBridge.util).FormatJson(ptJson)
        //Set jsonString = CSVData.%ToJSON()

        Set stream = ##class(%Stream.GlobalCharacter).%New()
        Do stream.Write(formattedJSON)
        Set pResponse = ##class(Ens.StreamContainer).%New()
        Set pResponse.Stream = stream
        
        //set tSC = ConvertToStreamContainer(CSVData, pResponse)
        //if $$$ISERR(tSC) {
        //    throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
        // }
        
        //Set pResponse = ##class(Ens.StreamContainer).%New()
        //Set pResponse.OriginalFilename = response
        //Set pResponse.Stream = ##class(%Stream.FileBinary).%New()
        //$$$TOE(tSC, pResponse.Stream.LinkToFile(response))
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
