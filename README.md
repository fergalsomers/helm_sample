# helm_sample  <!-- omit from toc -->
Simple example for deployment parameterization via Helm.

See the [values.yaml](/simpleapp/values.yaml) chart for environment values in the `env:` section.
Helm uses these values when rendering the [deployment.yaml template](/simpleapp/templates/deployment.yaml)

- [Prerequisites](#prerequisites)
- [View the generated template](#view-the-generated-template)
- [Create a kind cluster](#create-a-kind-cluster)
- [Deploy the Helm simpleapp](#deploy-the-helm-simpleapp)
- [Have a look at the logs](#have-a-look-at-the-logs)
- [Clean-up](#clean-up)


# Prerequisites

1. Helm installed
2. Kubectl installed
3. Kind installed
4. Make installed


# View the generated template

```bash
> helm template simpleapp | grep "env:" -A 12

          env:
            - name: A
              value: "1"
            - name: B
              valueFrom:
                configMapKeyRef:
                  key: X-KEY
                  name: simpleapp-config
            - name: C
              valueFrom:
                secretKeyRef:
                  key: Y-KEY
                  name: simpleapp-secret
```

This env stanza defines 3 environment variables A - defined directly, B taken using the X-Key from the `simpleapp-configmap` and C taken using the Y-Key from the `simpleapp-secret`

# Create a kind cluster

```bash
make kind
```

Should print something like this
```
kind create cluster --name=kind
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.30.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

```

#  Deploy the Helm simpleapp

```
make helm-deploy
```

This will deploy the Helm applicattion using the following helm command:

```
helm install simpleapp ./simpleapp  --set image.tag=latest --set secret="3"
```
note we are setting a Helm override for the secret to be 3 - this will be the value of the Y-Key in the generated secret

# Have a look at the logs

``` 
make logs
```

Should eventually print:

```
Hello world
Here are some ENV variables : A = 1, B = 2, C = "3"
```


# Clean-up

```
make clean
```