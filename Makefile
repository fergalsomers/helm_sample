# Makefile for deploying a simple application using Helm and Kind

kind:
	kind create cluster --name=kind

helm-deploy:
	helm lint simpleapp
	helm install simpleapp ./simpleapp  --set image.tag=latest --set secret="3"


# get the logs from the pod (this first waits to make sure the pod is ready)
logs:	
	kubectl wait --for=jsonpath='{.status.phase}'=Running pod/${shell kubectl get pod -l app=simpleapp -o jsonpath='{.items[0].metadata.name}'} --timeout=60s
	kubectl logs -l app=simpleapp

helm-delete:
	helm delete simpleapp

clean:
	kubectl delete secret simpleapp-secret
	helm delete simpleapp
	kind delete cluster --name=kind
