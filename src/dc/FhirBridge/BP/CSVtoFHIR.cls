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
<property name='streamContainer' type='Ens.StreamContainer' instantiate='1' />
</context>
<sequence xend='200' yend='450' >
<call name='CSVtoFHIR_Process' target='CSVtoFHIR_Bundle_Operation' async='0' xpos='200' ypos='250' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.StreamContainer' >
<assign property="context.streamContainer" value="callresponse" action="set" languageOverride="" />
</response>
</call>
<call name='Create JSON' target='EnsLib.File.PassthroughOperation' async='1' xpos='200' ypos='350' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="context.streamContainer" action="set" languageOverride="" />
</request>
<response type='Ens.StreamContainer' >
<assign property="callresponse" value="context.streamContainer" action="set" languageOverride="" />
</response>
</call>
</sequence>
</process>
}

}
