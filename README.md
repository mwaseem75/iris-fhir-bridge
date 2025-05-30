## 🧾 Summary

**IRIS-FHIR-Bridge** is a robust interoperability engine built on **InterSystems IRIS for Health**, designed to transform healthcare data across multiple formats into **FHIR** and vice versa. It leverages the **InterSystems FHIR Object Model** (`HS.FHIRModel.R4.*`) to enable smooth data standardization and exchange across modern and legacy healthcare systems.

---

## 🚀 Key Features

- #### 🧾 CSV → FHIR Transformation
Convert structured legacy data in CSV format into FHIR resources using InterSystems' native FHIR object model.

**Currently supports:**
- `Patient`
- `Encounter`
- `Observation`
- `Practitioner`
- `Organization`

> ✅ Can be easily extended to support other FHIR resource types.

- #### 🔁 HL7 v2 → FHIR Conversion
- #### 📝 CCDA → FHIR Conversion
- #### 🔄 FHIR → HL7 v2 Conversion

---

## 📦 Repo Highlights
✅ **Sample data files**  
HL7, CDA, FHIR, CSV sample data files provided in the `src/data` folder.

✅ **Postman Collection Included**  
Test all REST endpoints using the ready-to-import Postman collection provided in the `src/collection` folder.
![image](https://github.com/user-attachments/assets/8398a595-3b6d-4189-bf93-0e66f3f962da)



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
Navigate to [http://localhost:32783/csp/healthshare/fhirbridge/EnsPortal.ProductionConfig.zen?$NAMESPACE=FHIRBRIDGE&](http://localhost:32783/csp/healthshare/fhirbridge/EnsPortal.ProductionConfig.zen?$NAMESPACE=FHIRBRIDGE&) to view the production by using SuperUser | SYS 
![image](https://github.com/user-attachments/assets/49754c56-5735-400f-8304-3b0d979b5770)


## 🔧 Conversion Workflows
### 🧾 CSV to FHIR (Using FHIR Object Model)

**File-Based Service**  
Parses structured CSV data and transforms it into valid FHIR resources using the InterSystems **FHIR Object Model (HS.FHIRModel.R4.)**. Designed for production environments, this service reads structured CSV files, maps each row to corresponding FHIR resources (e.g., Patient, Encounter, Observation, etc.), and assembles them into a fully compliant **FHIR Bundle**.
The generated FHIR Bundle is ready to be posted directly to a FHIR server, enabling seamless integration and automated ingestion of legacy tabular data into modern healthcare systems.

**Patient synthetic data (CSV format) and generated FHIR bundle resource**
![image](https://github.com/user-attachments/assets/c928c021-7134-498a-b893-b59effbf62c5)
![image](https://github.com/user-attachments/assets/9bfae4e5-e99c-4506-a078-3a93e5bc75b4)

**Observation synthetic data (CSV format) and generated FHIR bundle resource**
![image](https://github.com/user-attachments/assets/1b2fd08b-0762-4024-82f4-6559c1e6272a)
![image](https://github.com/user-attachments/assets/2856cc10-a842-482d-a3fa-05ba6a5b13a1)

**Encounter synthetic data (CSV format) and generated FHIR bundle resource**
![image](https://github.com/user-attachments/assets/bc53a1b9-8c8f-4c2f-a99e-e7706f5e52c9)
![image](https://github.com/user-attachments/assets/6ea1ba87-02fa-43de-b07f-29988df71172)

**Practitioner synthetic data (CSV format) and generated FHIR bundle resource**
![image](https://github.com/user-attachments/assets/deb6993d-139c-46f1-837a-e977070bda34)
![image](https://github.com/user-attachments/assets/67b1530a-93f9-4e4e-a109-7ed9174a516c)

**Organization synthetic data (CSV format) and generated FHIR bundle resource**
![image](https://github.com/user-attachments/assets/111addd7-4929-4b98-bfd9-a3af682cd561)
![image](https://github.com/user-attachments/assets/687a045f-4b16-4bc4-b544-5714e005ace7)


### HL7 v2 to FHIR
Transform inbound HL7 v2 messages into FHIR resources 
**REST API:** `HL7_Http_Service`  
Exposed via HTTP and testable with Postman
![image](https://github.com/user-attachments/assets/707fd829-4d69-4afd-9a09-2726f04554c7)

**File-Based Service:** `HL7_File_Service`  
Monitors folder and auto-processes HL7 v2 files
![image](https://github.com/user-attachments/assets/bac5f13f-c113-4454-a42d-aea2619bdb73)
![image](https://github.com/user-attachments/assets/e4d2415b-95f5-4267-8117-7f905b4e60ed)


### CCDA to FHIR
Convert structured clinical documents (CCDA) to FHIR resources using predefined mappings. This allows integration of rich clinical narratives into modern systems.
**REST API:** `CDA_Http_Service`  
Accepts CCDA XML and converts to FHIR JSON format
![image](https://github.com/user-attachments/assets/4810564e-794a-4284-a291-9abebafe2ab9)
![image](https://github.com/user-attachments/assets/4eddf0da-75ce-430f-8341-23149d312752)


### FHIR to HL7 v2
Convert FHIR resources back into HL7 v2 message formats, enabling backward compatibility with legacy systems and seamless data round-tripping.
**Interop Service:** `HS.FHIRServer.Interop.Service`  
Converts FHIR resources back to HL7 v2 messages for legacy system compatibility
![image](https://github.com/user-attachments/assets/56ffd185-7cdb-4caa-81e8-65b96123535b)




## Special Thanks to:
Guillaume Rongier for: [iris-healthtoolkit-service](https://openexchange.intersystems.com/package/iris-healthtoolkit-service) template for guidance

Thanks
