# GitOps Monitor

This is a very small proof-of-concept to explore possible needs in a gitops 
approach to manage a remote K8s cluster.

## Usage

Under the directory "deploy" there is a K8s manifest that will deploy a pod 
and will run the bash monitor. This can only monitor one repository and as per
kubectl documentation, it will apply all the K8s manifests located inside the
repo.

Change the repo located in deploy/gitops.yaml, line 10:

	args: ["-c", "./gitops.sh https://github.com/oglok/samplepod"]

That URL is the Git repository that will be monitored. 

In order to be able to apply manifests to a running cluster, we need a kubeconfig.
As this is a simple PoC, you will see an empty kubeconfig file here. Please,
replace it by the kubeconfig file that will allow GitOps monitor to control your
cluster.

## Build image

Next step will require you to build your image and store it somewhere.

	 imagebuilder -t gitops -f Dockerfile .
	 docker run gitops echo "gitops" > /dev/null
	 docker ps -a | grep gitops
	 docker commit $CONTAINER_ID quay.io/oglok/gitops
	 docker push quay.io/oglok/gitops

This will store the image in quay.io.

## Deployment

In order to deploy the GitOps Monitor, please apply the deployment file:

	kubectl apply -f deploy/gitops.yaml

The monitor will download the repo and apply the manifests for the very first time.
Then, it will only apply them again if there is any change on the monitored repo.


