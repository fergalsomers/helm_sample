# Makefile for deploying a simple application using Helm and Kind

kind:
	kind create cluster --name=kind

secret:
	kubectl create secret generic another-secret --from-literal=Z-KEY="4"

helm-deploy:
	helm lint simpleapp
	helm upgrade --install simpleapp ./simpleapp  --set image.tag=latest --set secret=3


# Get the name of the pod created by the Helm chart
# Really this should be items[0], but this is a workaround for cases where pod doesn't yet exist
# due to nature of bash variable assignment
POD := ${shell kubectl get pod -l app=simpleapp -o jsonpath='{.items[*].metadata.name}'  | cut -f1 -d' '} 

# get the logs from the pod (this first waits to make sure the pod is ready)
logs:	
	kubectl wait --for=jsonpath='{.status.phase}'=Running pod/${POD} --timeout=60s
	kubectl logs ${POD}

helm-delete:
	helm delete simpleapp

clean:
	kubectl delete secret another-secret
	helm delete simpleapp
	kind delete cluster --name=kind
