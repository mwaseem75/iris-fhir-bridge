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
        //include Entry object
        do bundle.IncludeEntry()                  
        set bundleentry = ##class(HS.FHIRModel.R4.BundleX.SeqOfBundleXEntry).%New()                  
        set headers = $ZCONVERT(stream.ReadLine(),"L")        
        set headerArray = $listfromstring(headers, ",")
       
        //Read the file
        while 'stream.AtEnd {
            set line = stream.ReadLine()
            if line '= "" 
            {                
                set values = $listfromstring(line, ",")
                //get first column
                set CSVresource = $ZCONVERT($listget(values, 1),"L")
                // Create Resources based on the first column of the CSV file
                if CSVresource = "patient" { set resource = ..CreatePatientResource(headers,line)}
                elseif CSVresource = "observation"  { set resource = ..CreateObservationResource(headers,line)}
                elseif CSVresource = "practitioner" { set resource = ..CreatePractitionerResource(headers,line)}
                elseif CSVresource = "organization" { set resource = ..CreateOrganizationResource(headers,line)}
                elseif CSVresource = "encounter"    { set resource = ..CreateEncounterResource(headers,line)}
            }
                
            //create bundle entry
            set entry = ##class(HS.FHIRModel.R4.BundleX.Entry).%New()                 
            set entry.resource = resource
            set request = ##class(HS.FHIRModel.R4.BundleX.Request).%New()
            if (CSVresource = "observation")  
            {   //Post the resources with auto assign ID's
                set request.method = "POST"                    
                set request.url = $ZConvert($Extract(CSVresource, 1), "U")_$Extract(CSVresource, 2, *)
            } 
            else
            {                    
                // Using PUT menthod as we are forcing to use our provided ID
                set request.method = "PUT"
                set rid = resource.fhirID 
                set request.url = $ZConvert($Extract(CSVresource, 1), "U")_$Extract(CSVresource, 2, *)_"/"_rid
            }
                
            //Add Request Type 
            set entry.request = request  
            //add resource into bundle 
            do bundleentry.add(entry)               
               
            }          
                                 
        set bundle.entry = bundleentry          
        set bundleDao = bundle.toDao()
        set ptJson = bundleDao.%ToJSON()
      
        //format JSON
        set formattedJSON = ##class(dc.FhirBridge.util).FormatJson(ptJson)
        //convert to stream    
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

/// Generate Patient Resource
ClassMethod CreatePatientResource(headers As %String, line As %String) As HS.FHIRModel.R4.Patient
{
    // Get columns from header array
    set headerArray = $listfromstring(headers, ",")
    set values = $listfromstring(line, ",")
    
    //Create patient resource
    #dim patient As HS.FHIRModel.R4.Patient
    set patient = ##class(HS.FHIRModel.R4.Patient).%New()

    //Set id and identifier
    SET position = $LISTFIND(headerArray, "patientid")    
    if (position > 0)
    { 
        set patient.fhirID = $listget(values,position)
        do patient.IncludeIdentifier()
        set identifier = ##class(HS.FHIRModel.R4.Identifier).%New()
        set identifier.system = "http://irisfhirbridge.com/patient-id"
        set identifier.value = $listget(values, position)
        do patient.identifier.add(identifier) 
    }

    //Set Patient name
    SET positionfirstName= $LISTFIND(headerArray, "firstname")    
    SET positionfamilyName= $LISTFIND(headerArray, "familyname")    

    if (positionfirstName > 0)
    {          
        Do patient.IncludeName()
        set name = patient.name.MakeEntry()
        Do name.IncludeGiven()
        Do name.given.add($listget(values, positionfirstName))           
        if (positionfamilyName > 0 ) {set name.family = $listget(values, positionfamilyName) }  
        Do patient.name.add(name)       
    }
    //set gender
    SET position = $LISTFIND(headerArray, "gender")    
    if (position > 0)
    {
        set patient.gender = $listget(values,position)     
    }
    //set birth date
    SET position = $LISTFIND(headerArray, "birthdate")    
    if (position > 0)
    {
        set patient.birthDate = $listget(values,position)     
    }
    
    Return patient
}

/// Generate Observation Resource
ClassMethod CreateObservationResource(headers As %String, line As %String) As HS.FHIRModel.R4.Observation
{
    // Get columns from header array
    set headerArray = $listfromstring(headers, ",")
    set values = $listfromstring(line, ",")
    //Create observation resource
    #dim observation As HS.FHIRModel.R4.Observation
    set Observation = ##class(HS.FHIRModel.R4.Observation).%New()

    //Set the Status 
    SET position = $LISTFIND(headerArray, "status") 
    if (position > 0) {set Observation.status = $listget(values, position) }   

    //Set coding system
    SET position = $LISTFIND(headerArray, "code_system") 
    if (position > 0) 
    {
        Set code = ##class(HS.FHIRModel.R4.CodeableConcept).%New()
        do code.IncludeCoding()
        Set coding = ##class(HS.FHIRModel.R4.Coding).%New()         
        Set coding.system = $listget(values, position)
        SET positionCode = $LISTFIND(headerArray, "code") 
        if positionCode > 0 {  Set coding.code = $listget(values, positionCode) }
        SET positionCodeDisplay = $LISTFIND(headerArray, "code_display") 
        if positionCodeDisplay > 0 {  Set coding.code = $listget(values, positionCodeDisplay) }
        Do code.coding.add(coding)         
        Set Observation.code = code         
    }   
    
    // Set subject reference
    SET position = $LISTFIND(headerArray, "subject_reference") 
    if (position > 0) 
    {
        Set subject = ##class(HS.FHIRModel.R4.Reference).%New()
        Set subject.reference = $listget(values, position)
        Set Observation.subject = subject 
    }   
    // set value
    set positionValue = $LISTFIND(headerArray, "value") 
    if (positionValue > 0)
    {
        set positionUnit = $LISTFIND(headerArray, "unit") 
        set positionValueSystem = $LISTFIND(headerArray, "value_system") 
        set positionValueCode = $LISTFIND(headerArray, "value_code") 
        Set value = ##class(HS.FHIRModel.R4.Quantity).%New()    
        Set value.value = +$listget(values, positionValue)
        if (positionUnit > 0 ) {Set value.unit = $listget(values, positionUnit)}
        if (positionValueSystem > 0 ) {Set value.system = $listget(values, positionValueSystem)}
        if (positionValueCode > 0 ) {Set value.code = $listget(values, positionValueCode)}
        
        Set Observation.valueQuantity = value
    }      
    Return Observation
}

/// Generate Practitioner Resource
ClassMethod CreatePractitionerResource(headers As %String, line As %String) As HS.FHIRModel.R4.Practitioner
{
    // Get columns from header array
    set headerArray = $listfromstring(headers, ",")
    set values = $listfromstring(line, ",")
    //Create Practitioner resource
    #dim practitioner As HS.FHIRModel.R4.Practitioner
    set practitioner = ##class(HS.FHIRModel.R4.Practitioner).%New()
    
    //Set id and identifier
    SET position = $LISTFIND(headerArray, "id")    
    if (position > 0)
    { 
        set practitioner.fhirID = $listget(values,position)
        do practitioner.IncludeIdentifier()
        set identifier = ##class(HS.FHIRModel.R4.Identifier).%New()
        set identifier.system = "http://irisfhirbridge.com/practitioner-id"
        set identifier.value = $listget(values, position)
        do practitioner.identifier.add(identifier) 
    }
    
    //Set name
    SET positionFirstName = $LISTFIND(headerArray, "firstname")    
    SET positionFamilyName = $LISTFIND(headerArray, "familyname")    
    if (positionFirstName > 0) || (positionFamilyName > 0)
    {         
        Do practitioner.IncludeName()
        set name = practitioner.name.MakeEntry()
        if (positionFirstName > 0){
            Do name.IncludeGiven()
            Do name.given.add($listget(values, positionFirstName))           
        }     
        if (positionFamilyName > 0) {set name.family = $listget(values,positionFamilyName)}            
        Do practitioner.name.add(name)
    }

    //set Gender
    SET position = $LISTFIND(headerArray, "gender")    
    if (position > 0) { set practitioner.gender = $listget(values,position)}
    //set birthDate
    SET position = $LISTFIND(headerArray, "birthdate")    
    if (position > 0) { set practitioner.birthDate = $listget(values,position)}

    Return practitioner
}

/// Generate Organization Resource
ClassMethod CreateOrganizationResource(headers As %String, line As %String) As HS.FHIRModel.R4.Organization
{
    // Get columns from header array
    set headerArray = $listfromstring(headers, ",")
    set values = $listfromstring(line, ",")   

    //Create organization resource
    #dim organization As HS.FHIRModel.R4.Organization
    set organization = ##class(HS.FHIRModel.R4.Organization).%New()

    //Set id and identifier
    SET position = $LISTFIND(headerArray, "id")    
    if position > 0
    {
        set organization.fhirID = $listget(values, position)
        do organization.IncludeIdentifier()
        set identifier = ##class(HS.FHIRModel.R4.Identifier).%New()
        set identifier.system = "http://irisfhirbridge.com/organization-id"
        set identifier.value = $listget(values, position)
        do organization.identifier.add(identifier) 
    }

    //set name
    SET position = $LISTFIND(headerArray, "name")    
    if position > 0 { set organization.name = $listget(values, position)  }

    //Type
    SET position = $LISTFIND(headerArray, "type")    
    if position > 0
    {
        do organization.IncludeType()
        set code = ##class(HS.FHIRModel.R4.CodeableConcept).%New()
        do code.IncludeCoding()
        set coding = ##class(HS.FHIRModel.R4.Coding).%New()
        set coding.system = "http://terminology.hl7.org/CodeSystem/organization-type"
        set coding.code = $listget(values, position)
        do code.coding.add(coding)
        do organization.type.add(code) 
    }

    //Add Address
    SET positionCity = $LISTFIND(headerArray, "city")  
    SET positionState = $LISTFIND(headerArray, "state")  
    SET positionPostalCode = $LISTFIND(headerArray, "postalcode")  
    SET positionCountry = $LISTFIND(headerArray, "country")  
    if (positionCity > 0) || (positionState > 0) || (positionPostalCode > 0) || (positionCountry > 0)
    {
        do organization.IncludeAddress()
        set address = ##class(HS.FHIRModel.R4.Address).%New()
        if (positionCity > 0) { set address.city =  $listget(values, positionCity ) }
        if (positionState > 0) { set address.state =  $listget(values, positionState ) }
        if (positionPostalCode > 0) { set address.postalCode =  $listget(values, positionPostalCode ) }
        if (positionCountry  > 0) { set address.country =  $listget(values, positionCountry ) }
        do organization.address.add(address)
    }  

    Return organization
}

/// /// Generate Encounter Resource
ClassMethod CreateEncounterResource(headers As %String, line As %String) As HS.FHIRModel.R4.Encounter
{
    // Get columns from header array
    set headerArray = $listfromstring(headers, ",")
    set values = $listfromstring(line, ",")   

    //Create Encounter resource
       #dim encounter As HS.FHIRModel.R4.Encounter
    set encounter = ##class(HS.FHIRModel.R4.Encounter).%New()
    
    //Set id and identifier
    SET position = $LISTFIND(headerArray, "id")    
    if position > 0  
        {
        set encounter.fhirID = $listget(values, position)
        do encounter.IncludeIdentifier()
        set identifier = ##class(HS.FHIRModel.R4.Identifier).%New()
        set identifier.system = "http://example.com/encounter-id"
        set identifier.value = $listget(values, position)
        do encounter.identifier.add(identifier) 
        }

    //status
    SET position = $LISTFIND(headerArray, "status")    
    if position > 0 { set encounter.status = $listget(values, position)  }

    //Type
    SET position = $LISTFIND(headerArray, "class")    
    if position > 0
    {               
        set coding = ##class(HS.FHIRModel.R4.Coding).%New()
        set coding.system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
        set coding.code = $listget(values, position)
        set encounter.class = coding
        
    }

    //Set id and identifier
    SET position = $LISTFIND(headerArray, "subjectreference")    
    if position > 0  
    {
        Set subject = ##class(HS.FHIRModel.R4.Reference).%New()
        Set subject.reference = $listget(values, position)
        Set encounter.subject = subject
    }

    
    SET positionStartDate = $LISTFIND(headerArray, "startDate")    
    SET positionEndDate = $LISTFIND(headerArray, "endDate")    

    if (positionStartDate > 0) || (positionEndDate > 0) 
    {
        set period = ##class(HS.FHIRModel.R4.Period).%New()
        if (positionStartDate > 0) { set period.start =  $listget(values, positionStartDate ) }
        if (positionEndDate > 0) { set period.start =  $listget(values, positionEndDate ) }
        set encounter.period = period
    }
     
    //Set id and identifier
    SET position = $LISTFIND(headerArray, "organizationreference")    
    if position > 0  
    {
        Set provider = ##class(HS.FHIRModel.R4.Reference).%New()
        Set provider.reference = $listget(values, position)
        Set encounter.serviceProvider = provider
    }

    Return encounter
}

}
