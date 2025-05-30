/// 
Class dc.FhirBridge.BP.FHIRRouter Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='950' >
<if name='RequestPath include hl7' condition='request.Request.RequestPath [ "hl7"' xpos='200' ypos='250' xend='200' yend='850' >
<true>
<switch name='HL7 Type' xpos='470' ypos='400' xend='470' yend='650' >
<case condition='request.Request.RequestPath [ "adt"' >
<assign name="Default" property="^HL7Transforme" value="&quot;HS.Gateway.SDA3.SDA3ToHL7.ADTA0N&quot;" action="set" languageOverride="" xpos='470' ypos='550' />
</case>
<case condition='request.Request.RequestPath [ "oru"' >
<assign name="ORU message" property="^HL7Transforme" value="&quot;HS.Gateway.SDA3.SDA3ToHL7.ORUR01&quot;" action="set" languageOverride="" xpos='740' ypos='550' />
</case>
<case condition='request.Request.RequestPath [ "vxu"' >
<assign name="VXU message" property="^HL7Transforme" value="&quot;HS.Gateway.SDA3.SDA3ToHL7.VXUV04&quot;" action="set" languageOverride="" xpos='1010' ypos='550' />
</case>
<default>
<assign name="ADT message" property="^HL7Transforme" value="&quot;HS.Gateway.SDA3.SDA3ToHL7.ADTA0N&quot;" action="set" languageOverride="" xpos='1280' ypos='550' />
</default>
</switch>
<call name='FHIRtoSDA Transformation' target='FHIRtoSDA_Process' async='0' xpos='470' ypos='750' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" languageOverride="" />
</response>
</call>
</true>
<false>
<call name='To FHIRServer Operation' target='HS.FHIRServer.Interop.Operation' async='0' xpos='200' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" languageOverride="" />
</response>
</call>
</false>
</if>
</sequence>
</process>
}

}
