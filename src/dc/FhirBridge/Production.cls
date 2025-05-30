Class dc.FhirBridge.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.FhirBridge.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HL7_File_Service" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.2</Setting>
    <Setting Target="Adapter" Name="FilePath">/opt/irisapp/data/in/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HL7toSDA3_Process</Setting>
  </Item>
  <Item Name="HS.FHIRServer.Interop.Operation" Category="" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="SDAtoFHIRProcess" Category="" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fhirserverlocal/fhir/r4</Setting>
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
  </Item>
  <Item Name="HL7toSDA3_Process" Category="" ClassName="dc.FhirBridge.BP.HL7toSDA3" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HL7_Http_Service" Category="" ClassName="dc.FhirBridge.BS.HL7HTTP" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HL7toSDA_Process</Setting>
  </Item>
  <Item Name="HL7toSDA_Process" Category="" ClassName="dc.FhirBridge.BP.HL7toSDA" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">SDAtoFHIR_process</Setting>
  </Item>
  <Item Name="SDAtoFHIR_process" Category="" ClassName="dc.FhirBridge.BP.SDAtoFHIR" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fhirserverlocal/fhir/r4</Setting>
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TransformClass">dc.FhirBridge.BP.BPSDAtoFHIRDTL</Setting>
    <Setting Target="Host" Name="TargetConfigName">Http_FHIR_Operation</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="Http_FHIR_Operation" Category="" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIRServer.Interop.Service" Category="" ClassName="HS.FHIRServer.Interop.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">FHIRRouter</Setting>
  </Item>
  <Item Name="CSV_File_Service" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">CSVtoFHIR_Process</Setting>
    <Setting Target="Adapter" Name="FilePath">/opt/irisapp/data/in/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.csv</Setting>
    <Setting Target="Adapter" Name="DeleteFromServer">1</Setting>
  </Item>
  <Item Name="CSVtoFHIR_Process" Category="" ClassName="dc.FhirBridge.BP.CSVtoFHIR" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="CSVtoFHIR_Bundle_Operation" Category="" ClassName="dc.FhirBridge.BO.CSVtoFHIRBundle" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FHIRRouter" Category="" ClassName="dc.FhirBridge.BP.FHIRRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="FHIRtoSDA_Process" Category="" ClassName="dc.FhirBridge.BP.FHIRtoSDA" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">SDAtoHL7_Process</Setting>
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
  </Item>
  <Item Name="SDAtoHL7_Process" Category="" ClassName="dc.FhirBridge.BP.SDAtoHL7" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName"></Setting>
  </Item>
  <Item Name="CDA_Http_Service" Category="" ClassName="dc.FhirBridge.BS.CDAHTTP" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="CDAtoSDA_Process" Category="" ClassName="dc.FhirBridge.BP.CDAtoSDA" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="CSVtoFHIR_Patient_Operation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">Patient_%f_%Q%!+(_a).json</Setting>
    <Setting Target="Adapter" Name="FilePath">/opt/irisapp/data/out/Patients/</Setting>
  </Item>
  <Item Name="CSVtoFHIR_Observation_Operation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">Observation_%f_%Q%!+(_a).json</Setting>
    <Setting Target="Adapter" Name="FilePath">/opt/irisapp/data/out/Observations/</Setting>
  </Item>
  <Item Name="CSVtoFHIR_Organization_Operation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">Organization_%f_%Q%!+(_a).json</Setting>
    <Setting Target="Adapter" Name="FilePath">/opt/irisapp/data/out/Organizations/</Setting>
  </Item>
  <Item Name="CSVtoFHIR_Encounter_Operation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">Encounter_%f_%Q%!+(_a).json</Setting>
    <Setting Target="Adapter" Name="FilePath">/opt/irisapp/data/out/Encounters/</Setting>
  </Item>
  <Item Name="CSVtoFHIR_Practitioner_Operation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">Practitioner_%f_%Q%!+(_a).json</Setting>
    <Setting Target="Adapter" Name="FilePath">/opt/irisapp/data/out/Practitioners/</Setting>
  </Item>
</Production>
}

}
