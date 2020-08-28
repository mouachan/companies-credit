# companies-credit


Companies application is a set of services that allows business user to :

- create/update/delete a company
- calculate loan score using kogito DMN services or streaming process service (reactive messaging)
- simulate loan validation process service 



The following architecture deployed on Openshift,is composed by 
 - mongodb instance to store company and scoring details
 - quarkus, panache services to manage CRUD companies and scoring operations (Rest operations)
 - quarkus, kogito service to calculate the score. the service offer differents ways to caclulate score :
    - DMN rest service 
    - event process (using kafka)
 - quarkus, kogito service to simulate a loan validation process. the communication between the process use reactive messaging, all objects are stored in infinispan.
- frontend to manage all services
- all services offers rest api

##
install :
- oc cli
- kn cli
- kogito cli

## connect to Openshift server 

```
oc login https://ocp-url:6443 -u login -p password
```
## add a github secret to checkout sources 

```
oc create secret generic username \
    --from-literal=username=username \
    --from-literal=password=password \
    --type=kubernetes.io/basic-auth
```

## add a registry secret

```
oc create secret docker-registry quay-secret \
    --docker-server=quay.io/username \
    --docker-username=username \
    --docker-password=password\
    --docker-email=email

oc secrets link builder quay-secret
oc secrets link default quay-secret --for=pull
```

## Clone the source from github
```
git clone https://github.com/mouachan/companies-credit.git

```

## Create MongoDB instance on OCP

## Create a persistent mongodb 

From Openshift Developper view, click on Add,select Database

![Add database app](/img/catalog-db-ocp.png) 

From the developer catalog, click on MongoDB Template (persistent)

![Developer catalog](/img/developer-catalog.png) 

Click on Instantiate Template (use the filled values)

![Instantiate the template](/img/instantiate-template-mongodb.png) 



## Build and deploy companies services managment (create/update/delete company and score)
## Create  DB and collection

Connect to the db and :

```
#create db
use companies
#create collection
db.createCollection( "companyInfo", {
   validator: { $jsonSchema: {
      bsonType: "object",
      required: [ "siren" ],
      properties: {
         siren: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         denomination: {
            bsonType : "string",
            description: "must be a string"
         },
         siret: {
            bsonType : "string",
            description: "must be a string"
         },
         address: {
            bsonType : "string",
            description: "must be a string"
         },
         capitalSocial: {
            bsonType : "string",
            description: "must be a String"
         },
         chiffreAffaire: {
            bsonType : "string",
            description: "must be a String"
         },
          trancheEffectif: {
            bsonType : "string",
            description: "must be a String"
         },
          tva: {
            bsonType : "string",
            description: "must be a string"
         },
         immatriculationDate: {
            bsonType : "date",
            description: "must be a Date"
         },
          type: {
            bsonType : "string",
            description: "must be a string"
         },
         updateDate: {
            bsonType : "date",
            description: "must be a Date"
         }
      }
   } }
} )

//create notation collection
db.createCollection( "notation", {
   validator: { $jsonSchema: {
      bsonType: "object",
      required: [ "siren" ],
      properties: {
         siren: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         dateCalcul: {
            bsonType : "date",
            description: "must be a date"
         },
         score: {
            bsonType : "string",
            description: "must be a string"
         },
         note: {
            bsonType : "string",
            description: "must be a string"
         },
         orientation: {
            bsonType : "string",
            description: "must be a String"
         },
         typeAiguillage: {
            bsonType : "string",
            description: "must be a String"
         },
          decoupageSectoriel: {
            bsonType : "string",
            description: "must be a String"
         },
          detail: {
            bsonType : "string",
            description: "must be a string"
         }
      }
   } }
} )
```
## Add companies
```
 //insertion notation
    var dateCalcul = new Date(2020, 07, 24);
  db.notation.insert({  siren: "542107651",
         "dateCalcul": dateCalcul,
         "note": "A",
         "orientation": "Favorable",
         "score": "0.1",
         "typeAiguillage": "MODELE_1",
         "decoupageSectoriel": "1",
         "detail": ""
       })
//List of companies
    var immatriculationDate = new Date(1954, 12, 24);
    var updateDate =  new Date(2020, 04, 11);
  db.companyInfo.insert({  siren: "542107651",
         "denomination": "ENGIE",
         "siret": "54210765113030",
         "address": "ENGIE, 1 PL SAMUEL DE CHAMPLAIN 92400 COURBEVOIE",
         "tva": "FR03542107651",
         "immatriculationDate": immatriculationDate,
         type: "SA à conseil d'administration",
         "updateDate": updateDate,
         "capitalSocial": "2 435 285 011,00 €",
         "chiffreAffaire": "27 833 000 000.00 €",
         "trancheEffectif": "5000 à 9999 salariés"
              }
        )

     var immatriculationDate = new Date(1920, 12, 01);
    var updateDate =  new Date(2020, 04, 01);
        db.companyInfo.insert({  siren: "423646512",
         "denomination": "FOURNIL SAINT JACQUES",
         "siret": "    42364651200016",
         "address": "11 RUE DE LA TOMBE ISSOIRE 75014 PARIS",
         "tva": "FR03423646512",
         "immatriculationDate": immatriculationDate,
         "type": "Société à responsabilité limitée",
         "updateDate": updateDate,
         "capitalSocial": "7 622,45 €",
         "chiffreAffaire": "NON Connu",
         "trancheEffectif": "1 à 2 salariés"
        })

     var immatriculationDate = new Date(2009, 02, 26);
    var updateDate =  new Date(2020, 04, 01);
      db.companyInfo.insert({  siren: "510662190",
         denomination: "ASHILEA",
         siret: "    51066219000014",
         address: "49 AV DE SAINT OUEN 75017 PARIS",
         tva: "FR0510662190",
         "immatriculationDate": immatriculationDate,
         "type": "Société par actions simplifiée",
         "updateDate": updateDate,
         "capitalSocial": "7 622,45 €",
         "chiffreAffaire": "21 000,00 €",
         "trancheEffectif": "10 salariés"
        }
   )
```


## Install knative-serving (serverless)
Install openshift-serverless operator from OperatorHub
Create a knative-serving instance

```
cd manifest/
./knative-serving.sh
```

## Build and deploy companies CRUD services

```
oc new-app quay.io/quarkus/ubi-quarkus-native-s2i:20.1.0-java11~https://github.com/mouachan/companies-svc.git --name=companies-svc

```

## Or build and generate container image 


```
cd ../companies-svc
```

Java
```
cd ../companies-svc
./mvnw clean package  -Dquarkus.container-image.build=true -Dquarkus.container-image.name=companies-svc -Dquarkus.container-image.tag=1.0
```

Or native 
```
./mvnw clean package  -Dquarkus.container-image.build=true -Dquarkus.container-image.name=companies-svc -Dquarkus.container-image.tag=native-1.0 -Pnative  -Dquarkus.native.container-build=true 
```

### Push the image to your registry 

Java
```
docker tag mouachani/companies-svc:1.0 quay.io/mouachan/companies-svc:1.0
docker push quay.io/mouachan/companies-svc:1.0
```

Or native
```
docker tag mouachani/companies-svc:native-1.0 quay.io/mouachan/companies-svc:native-1.0
docker push quay.io/mouachan/companies-app/companies-svc:native-1.0
```

## Create a knative service 
```
cd manifest
oc apply -f ./companies-svc-knative.yml 
```

## verify the service availability
Browse the url  : http://companies-svc-companies-app.apps.ocp4.ouachani.net/
replace .apps.ocp4.ouachani.net by your OCP url

![Verify service](/img/list-companies.png)


## Install Strimzi, infinispan and kogito operator

Install Infinispan/Red Hat Data Grid operator (operator version 1.1.X)
![infinispan installation](/img/install-infinispan-11x.png)
Install Strimizi operator
![strimzi installation](/img/install-strimzi.png)
Install Kogito operator
![strimzi installation](/img/install-kogito.png)

## Install kogit-infra 

```
kogito install infinispan
kogito install kafka
```

Install data-index

```
kogito install data-index
```

Add protobuf models of process loanValidation, processNotation and kogitoApp

```
oc apply -f ./manifest/data-index-protobuf-files.yml
```
Get username and password infinispan and decode it

```
oc get secret/kogito-infinispan-credential -o yaml
echo ZGV2ZWxvcGVy | base64 -d
```

Modify the values of the properties related to the services kafka, infinispan, data-index and companies-svc in ./manifest/companies-notation-svc.properties also infinispan credential  and create the configmap

```
oc apply -f ./manifest/companies-notation-svc-properties.yml
oc apply -f ./manifest/companies-notation-svc-protobuf-files.yml

oc apply -f ./manifest/companies-loan-application-svc-properties.yml
oc apply -f ./manifest/companies-loan-application-svc-protobuf-files.yml 
```


```
kogito deploy-service companies-notation-svc --enable-persistence --enable-events 
```

```
./mvnw clean package -DskipTests=true -Dquarkus.container-image.build=true -Dquarkus.container-image.name=companies-notation-svc -Dquarkus.container-image.tag=1.0 -Dquarkus.container-image.builder=s2i
```

```
oc start-build companies-notation-svc --from-dir=target -n companies-app 
```


```
kogito deploy-service companies-loan-application-svc --enable-persistence --enable-events 
```

```
./mvnw clean package -DskipTests=true -Dquarkus.container-image.build=true -Dquarkus.container-image.name=companies-loan-svc -Dquarkus.container-image.tag=1.0 -Dquarkus.container-image.builder=s2i
```

```
oc start-build companies-loan-application-svc --from-dir=target -n companies-app 
```
