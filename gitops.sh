!/bin/bash
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

echo $REPONAME

export KUBECONFIG=/tmp/kubeconfig

init()
{
	if [ ! -d "$REPONAME" ]; then
		git clone $REPO
	fi
	cd $REPONAME
	pwd
	reslog=$(git log HEAD..origin/master --oneline)
	if [[ "${reslog}" != "" ]] ; then
 	 git merge origin/master # completing the pull
	kubectl apply -f .
	fi
}

init