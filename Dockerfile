FROM openshift/base-centos7
WORKDIR /tmp/gitops
COPY . .
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN cp kubectl /usr/local/bin

RUN mkdir ~/.kube/
ADD kubeconfig ~/.kube/
RUN INSTALL_PKGS=" \
      git \
      " && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all
