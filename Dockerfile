FROM openshift/base-centos7
WORKDIR /tmp/gitops
COPY . .
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN cp kubectl /usr/local/bin
RUN INSTALL_PKGS=" \
      git \
      " && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

ENTRYPOINT ["while true; do ./gitops.sh https://github.com/oglok/samplepod; sleep 60; done"]
