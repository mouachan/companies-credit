## Infrastructure services


To allow a quick setup of all services required to run this demo, we provide a docker compose template that starts the following services:
- Infinispan
- Kafka
- Prometheus
- Grafana

This setup ensures that all services are connected using the default configuration as well as provisioning the Travel Agency dashboard to Grafana.  

In order to use it, please ensure you have Docker Compose installed on your machine, otherwise follow the instructions available
 in [here](https://docs.docker.com/compose/install/).
 
### Starting required services

  You should start all the services before you execute any of the Travel Agency applications, to do that please execute:
  
  For MacOS and Windows:
  
    docker-compose -f credit-services-macos-windows.yml up
  
  For Linux:
  
    docker-compose -f credit-services-linux.yml up
    
  Once all services bootstrap, the following ports will be assigned on your local machine:
  - Infinispan: 11222
  - Kafka: 9092
  - Prometheus: 9090
  - Grafana: 3000
  
To access the Grafana dashboard, simply navigate to http://localhost:3000 and login using the default username 'admin' and password 'admin'.
Prometheus will also be available on http://localhost:9090, no authentication is required. 

### Stopping and removing volume data
  
  To stop all services, simply run:

    docker-compose -f credit-services-macos-windows.yml stop
    
  It is also recommended to remove any of stopped containers by running:
  
    docker-compose -f credit-services-macos-windows.yml rm  
    
  For more details please check the Docker Compose documentation.
  
    docker-compose --help  

  ### Start data-index
  ./data-index/run-data-index-minimal.sh
  ### Start managment console
  ./mgmt-services/run-mgmt-console.sh
  ### Start kadrop
  ./kafdrop/run-kafdrop.sh

  ### Install mongodb
  brew install mongodb-community
  brew services start mongodb-community   
Connect to the db and :
mongo companies -u admcomp -p r3dhat2020!

```
#create users
> db.createUser(
...   {
...     user: "admin",
...     pwd: "",
...     roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
...   }
... )
Successfully added user: {
    "user" : "admin",
    "roles" : [
        {
            "role" : "userAdminAnyDatabase",
            "db" : "admin"
        }
    ]
}
> db.createUser(
...   {
...     user: "mroot",
...     pwd: "",
...     roles: [ { role: "root", db: "admin" } ]
...   }
... )
Successfully added user: {
    "user" : "mroot",
    "roles" : [
        {
            "role" : "root",
            "db" : "admin"
        }
    ]
}

> db.createUser(
   {
     user: "admcomp",
     pwd:  "r3dhat2020!",
     roles: [ { role: "readWrite", db: "companies" } ]
   }
 )
Successfully added user: {
    "user" : "admcomp",
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "companies"
        }
    ]
}
```
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
```
### to run each service  : companies-svc, companies-notation-svc, companies-loan-application-svc :
 ./mvnw clean compile quarkus:dev 


