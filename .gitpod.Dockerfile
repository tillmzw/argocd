FROM gitpod/workspace-base:latest

ARG KUBECTL_VERSION=v1.22.2
ARG KUBESEAL_VERSION=0.18.0

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl && \
    mkdir ~/.kube

RUN curl -LO https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz && \
    tar xf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz && \
    chmod +x ./kubeseal && \
    sudo mv ./kubeseal /usr/local/bin/kubeseal

#RUN set -x; cd "$(mktemp -d)" && \
#    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
#    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
#    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" && \
#    tar zxvf krew.tar.gz && \
#    KREW=./krew-"${OS}_${ARCH}" && \
#    "$KREW" install krew && \
#    echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /home/gitpod/.bashrc