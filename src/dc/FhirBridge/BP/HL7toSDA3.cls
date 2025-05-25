/// 
Class dc.FhirBridge.BP.HL7toSDA3 Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='tmpStatus' type='%Library.Status' instantiate='0' />
<property name='sdaStream' type='%Stream.GlobalCharacter' instantiate='0' />
<property name='streamContainer' type='Ens.StreamContainer' instantiate='1' />
</context>
<sequence xend='200' yend='650' >
<assign name="Transform HL7 V2 to SDA" property="context.sdaStream" value="##class(hospital.HL7toSDA3).GetSDAFromHL7(request)" action="set" languageOverride="" xpos='200' ypos='250' />
<assign name="Instantiate Stream" property="context.streamContainer.Stream" value="##class(%Stream.GlobalCharacter).%New()" action="set" languageOverride="" xpos='200' ypos='350' />
<assign name="Package Stream Container" property="context.tmpStatus" value="context.streamContainer.Stream.CopyFrom(context.sdaStream)" action="set" languageOverride="" xpos='200' ypos='450' />
<call name='Dispatch to Target' target='SDAtoFHIR_process' async='1' xpos='200' ypos='550' >
<request type='Ens.Request' >
<assign property="callrequest" value="context.streamContainer" action="set" languageOverride="" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
