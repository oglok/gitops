#!/bin/bash

echo "---------------------------------------------------------------------------"
echo "------------------------------    GitOps   --------------------------------"
echo "---------------------------------------------------------------------------"
echo "This script will clone and monitor a Git repository containing K8s manifests."
echo -e "It will apply modified manifests in order to enforce changes in the running cluster\n"


if [ "$1" == "" ]; then
    echo -e "ERROR: GitOps script needs the repo URL for your cluster\n"
fi

REPO=$1
BASENAME=$(basename $REPO)
REPONAME=${BASENAME%.*}

export KUBECONFIG=/tmp/gitops/kubeconfig

source gitid
git config --global user.name $USERNAME
git config --global user.email $EMAIL

init()
{
	if [ ! -d "$REPONAME" ]; then
		git clone $REPO
	fi
	cd $REPONAME
	kubectl apply -f .
}

monitor()
{
	echo "Monitoring repo..."
	git fetch origin
	reslog=$(git log HEAD..origin/master --oneline)
	echo $reslog
	if [[ "${reslog}" != "" ]] ; then
		git merge origin/master # completing the pull
		kubectl apply -f .
	fi
}

init
while true;
do monitor
sleep 60
done
