# Summary
IRIS-FHIR Bridget is a robust interoperability engine designed to seamlessly convert healthcare data across multiple standards.
It seamlessly converts HL7 v2, CCDA, and CSV formats to FHIR, and FHIR back to HL7 v2, enabling smooth data exchange across diverse healthcare systems.


## Features
* Convert HL7v2 to FHIR 
* Convert CCDA to FHIR 
* Convert CSV to FHIR 
* Convert FHIR to HL7

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

### Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/mwaseem75/iris-fhir-bridge.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d
```

### IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```
USER>zpm "install iris-fhir-bridge"
```

## View Production
Navigate to [http://localhost:32783/csp/healthshare/fhirbridge/EnsPortal.ProductionConfig.zen?$NAMESPACE=FHIRBRIDGE&](http://localhost:32783/csp/healthshare/fhirbridge/EnsPortal.ProductionConfig.zen?$NAMESPACE=FHIRBRIDGE&) to view the production 



## Special Thanks to:
Guillaume Rongier for: [iris-healthtoolkit-service](https://openexchange.intersystems.com/package/iris-healthtoolkit-service) template for guidance

Thanks
