# Simple Flask app with Postgres on Kubernetes along with Prometheus Grafana as the monitoring solution

This project utilizes a simple Flask app (app.py) -> Dockerfile, that connects with postgres database which is run on Kubernetes clusters. Subsequently, the Prometheus-Grafana is installed using Helm chart. The app.py contains the end point definition (/metrics) for sending the metrics to service monitor defined in Prometheus. Prometheus postgres node exporter chart needs to be installed using Helm and the corresponding service monitor needs to be defined and used as values file during the installation. 
Grafana displays the metrics as dashboards. 

(To be done: Bring in application metrics, develop custom dashboards in Grafana, move the secrets to a vault..)

Deployment.yaml - file has the definition for deployment, service for both the application and the database
app.py - file has the application file where the endpoint for Prometheus for application metrics need to be defined. 
Dockerfile - this file has the definition of the docker image that was created for reference or changing any config.
requirements.txt - file defines the required python packages which will be installed using pip. 

Config.py - need to be defined that has the database url (incl the password)

For the App:

## Interact with the API
POST a message to the API:
```bash
curl -X POST http://127.0.0.1:5000/message -H "Content-Type: application/json" --data '{"message": "hi"}'
```

GET a message
```bash
curl http://127.0.0.1:5000/message/1
```

HEALTHCHECK
```bash
curl http://127.0.0.1:5000/healthcheck
```

# Test Locally
If you desire to test locally to see things working there first before you put it on Kubernetes, you can follow the instructions below:

## Install the app
```bash
git clone git@github.com:gaingroundspeed/devops-takehome.git
cd devops-takehome
virtualenv -p python3 .
source bin/activate
pip install -r requirements.txt
```

## Start the app
If you're using a local postgres db use the following to run the app.
```bash
DATABASE_URL='postgresql://postgres:postgres@localhost:5432/groundspeed_devops' python app.py
```
## Deploy the App on Kubernetes

Make sure to connect to right cluster (minikube/GKE). Follow the instructions to set up the kubeconfig that will set the context: 

#Create the necessary, deployment, services for the flask applciatino and the database. Recommended to have 3 replicas for the database

```kubectl create -f deployment.yaml -n application ```

#the following installs Prometheus stack (which comes with grafana) and the postgres node exporter. The values file has details about conncetion to the Postgres database

```helm install prometheus prometheus-community/kube-prometheus-stack -f prometheus_values.yaml -n monitoring
helm install prometheus-postgres prometheus-community/prometheus-postgres-exporter -f postgres_values.yaml -n monitoring
```
Note: 'values' files have not been uploaded to this repo due to security reasons. It can be consumed from secret management systems like Hashicorp Vault.

#to be converted into a yaml file 

```kubectl expose deployment prometheus-grafana --type=LoadBalancer --name=grafana```

#Same can be done for the prometheus service itself to test and debug.

#Find the right External IP address from the grafana service created above and use that to access the Grafana dashboard link. 

```kubectl get svc -n monitoring ```


Once the final dashboards are built, it can be exported and imported later. Alerts can also be set up on Grafana and connected with VictorOps or similar tool.

