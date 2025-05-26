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
<sequence xend='200' yend='450' >
<call name='CSVtoFHIR_Process' target='CSVtoFHIR_Bundle_Operation' async='0' xpos='200' ypos='250' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.StreamContainer' >
<assign property="request.Stream" value="callresponse.Stream" action="set" languageOverride="" />
</response>
</call>
<call name='Create JSON' target='EnsLib.File.PassthroughOperation' async='1' xpos='200' ypos='350' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.StreamContainer' />
</call>
</sequence>
</process>
}

}
