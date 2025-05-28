## 🧾 Summary
IRIS-FHIR Bridget is a robust interoperability engine designed to seamlessly convert healthcare data across multiple standards.
It seamlessly converts HL7 v2, CCDA, and CSV formats to FHIR, and FHIR back to HL7 v2, enabling smooth data exchange across diverse healthcare systems.


## 🚀 Key Features
- 🔁 Convert **HL7 v2 → FHIR**
- 📝 Convert **CCDA → FHIR**
- 📊 Convert **CSV → FHIR** (using **InterSystems FHIR Object Model**)
- 🔄 Convert **FHIR → HL7 v2** 


## 📦 Repo Highlights
✅ **Sample data files**  
HL7, CDA, FHIR, CSV sample data files provided in the Use `src/data` folder.

✅ **Postman Collection Included**  
Test all REST endpoints using the ready-to-import Postman collection provided in the `src/Postman_collection` folder.


## ✅ Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.


## ⚙️ Installation

### 🐳 Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/mwaseem75/iris-fhir-bridge.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d
```

### 🧰 IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```
USER>zpm "install iris-fhir-bridge"
```


## 🖥️ View Production
Navigate to [http://localhost:32783/csp/healthshare/fhirbridge/EnsPortal.ProductionConfig.zen?$NAMESPACE=FHIRBRIDGE&](http://localhost:32783/csp/healthshare/fhirbridge/EnsPortal.ProductionConfig.zen?$NAMESPACE=FHIRBRIDGE&) to view the production 
![image](https://github.com/user-attachments/assets/4c928ba2-b0d1-4003-88b7-7f70f5b4071c)


## 🔧 Conversion Workflows
### 1. HL7 v2 to FHIR
**REST API:** `HL7_Http_Service`  
Exposed via HTTP and testable with Postman
![image](https://github.com/user-attachments/assets/707fd829-4d69-4afd-9a09-2726f04554c7)

**File-Based Service:** `HL7_File_Service`  
Monitors folder and auto-processes HL7 v2 files
![image](https://github.com/user-attachments/assets/e4d2415b-95f5-4267-8117-7f905b4e60ed)


### 2. CCDA to FHIR
**REST API:** `CDA_Http_Service`  
Accepts CCDA XML and converts to FHIR JSON format
![image](https://github.com/user-attachments/assets/4eddf0da-75ce-430f-8341-23149d312752)


### 3. CSV to FHIR (Using FHIR Object Model)
**File-Based Service**  
Parses structured CSV data and builds valid Patient resources using the InterSystems FHIR Object Model
![image](https://github.com/user-attachments/assets/c928c021-7134-498a-b893-b59effbf62c5)
![image](https://github.com/user-attachments/assets/9bfae4e5-e99c-4506-a078-3a93e5bc75b4)

Parses structured CSV data and builds valid Observation resources using the InterSystems FHIR Object Model
![image](https://github.com/user-attachments/assets/1b2fd08b-0762-4024-82f4-6559c1e6272a)
![image](https://github.com/user-attachments/assets/2856cc10-a842-482d-a3fa-05ba6a5b13a1)



### 4. FHIR to HL7 v2
**Interop Service:** `HS.FHIRServer.Interop.Service`  
Converts FHIR resources back to HL7 v2 messages for legacy system compatibility
![image](https://github.com/user-attachments/assets/56ffd185-7cdb-4caa-81e8-65b96123535b)




## Special Thanks to:
Guillaume Rongier for: [iris-healthtoolkit-service](https://openexchange.intersystems.com/package/iris-healthtoolkit-service) template for guidance

Thanks
