/// 
Class dc.FhirBridge.BP.CSVtoFHIR Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.StreamContainer' height='2000' width='2000' >
<context>
<property name='resourceType' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='streamContainer' type='Ens.StreamContainer' instantiate='0' />
</context>
<sequence xend='200' yend='800' >
<assign name="Get Resource Type" property="context.resourceType" value="##class(dc.FhirBridge.util).GetResourceType(request)" action="set" languageOverride="" xpos='200' ypos='250' />
<call name='CSVtoFHIR_Process' target='CSVtoFHIR_Bundle_Operation' async='0' xpos='200' ypos='350' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.StreamContainer' >
<assign property="context.streamContainer" value="callresponse" action="set" languageOverride="" />
</response>
</call>
<if name='Check Resource Type' condition='context.resourceType = "patient"' xpos='200' ypos='450' xend='200' yend='700' >
<true>
<call name='Create Patient Resource' target='CSVtoFHIR_Patient_Operation' async='1' xpos='470' ypos='600' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="context.streamContainer" action="set" languageOverride="" />
</request>
<response type='Ens.StreamContainer' >
<assign property="callresponse" value="context.streamContainer" action="set" languageOverride="" />
</response>
</call>
</true>
<false>
<call name='Create Observation Resource' target='CSVtoFHIR_Observation_Operation' async='1' xpos='200' ypos='600' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="context.streamContainer" action="set" languageOverride="" />
</request>
<response type='Ens.StreamContainer' >
<assign property="callresponse.Stream" value="context.streamContainer.stream" action="set" languageOverride="" />
</response>
</call>
</false>
</if>
</sequence>
</process>
}

}
