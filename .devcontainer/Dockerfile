###############################################################################
# .devcontainer/Dockerfile.go                                                 #
#                                                                             #
# Description: Docker image used by VSCode for building a Golang development  #
#              sandbox.                                                       #
# See:         https://code.visualstudio.com/docs/remote/containers           #
###############################################################################


# -----------------------------------------------------------------------------
# BUILD-TIME VARIABLES
#
# Unfortunately, build-time arguments cannot be given in the devcontainer.json 
# file. This feature will certainly be available soon... so let's be prepared.
# -----------------------------------------------------------------------------

ARG ARG_BAZEL_VERSION=4.0.0
ARG ARG_TASK_VERSION=3.3.0

# -----------------------------------------------------------------------------
# SANDBOX STAGE
# -----------------------------------------------------------------------------

FROM golang:1.16-stretch

ARG ARG_BAZEL_VERSION
ARG ARG_TASK_VERSION

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV KEY_HERE=${KEY_HERE}

# Configure APT, install packages and tools
RUN apt update \
  && apt install -y \
  build-essential \
  apt-utils \
  bash-completion \
  curl \
  g++ \
  git \
  lsb-release \
  patch \
  procps \
  unzip \
  zlib1g-dev \
  libunwind-dev \
  apt-transport-https \
  ca-certificates \
  gnupg2
#
# Install Bazel
RUN curl -LO "https://github.com/bazelbuild/bazel/releases/download/${ARG_BAZEL_VERSION}/bazel_${ARG_BAZEL_VERSION}-linux-x86_64.deb" \
  && dpkg -i bazel_*.deb \
  && rm -rf bazel_*.deb
#
# Install Docker CE CLI
RUN curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
  && echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
  && apt update \
  && apt install -y docker-ce-cli
#
# Install Docker Compose
RUN apt install -y docker-compose
#
# Install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
  && apt update \
  && apt install -y kubectl
#
# Install Task
# For Installation To /usr/local/bin for userwide access with debug logging
RUN curl -sL "https://github.com/go-task/task/releases/download/v${ARG_TASK_VERSION}/task_linux_amd64.tar.gz" -o /tmp/task.tgz \
  && tar zxf /tmp/task.tgz -C /usr/local/bin/
#
#
# Install Gocode autocomplemention deamon
RUN export GO111MODULE=auto \
  && go get -x -d github.com/stamblerre/gocode 2>&1 \
  && go build -o gocode-gomod github.com/stamblerre/gocode \
  && mv gocode-gomod $GOPATH/bin/
#
# Install various Go tools
RUN export GO111MODULE=on \
  && go get -u -v \
  github.com/bazelbuild/buildtools/buildifier \
  github.com/bazelbuild/bazel-gazelle/cmd/gazelle \
  honnef.co/go/tools/... \
  golang.org/x/tools@v0.1.1-0.20210319172145-bda8f5cee399 \
  golang.org/x/tools/cmd/gorename@v0.1.1-0.20210319172145-bda8f5cee399 \
  golang.org/x/tools/cmd/goimports@v0.1.1-0.20210319172145-bda8f5cee399 \
  golang.org/x/tools/cmd/guru@v0.1.1-0.20210319172145-bda8f5cee399 \
  golang.org/x/lint/golint \
  golang.org/x/tools/gopls@v0.6.9 \
  github.com/mdempsky/gocode \
  github.com/cweill/gotests/... \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/sqs/goreturns \
  github.com/josharian/impl \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/uudashr/gopkgs/v2/cmd/gopkgs \
  github.com/ramya-rao-a/go-outline \
  github.com/acroca/go-symbols \
  github.com/godoctor/godoctor \
  github.com/rogpeppe/godef \
  github.com/zmb3/gogetdoc \
  github.com/fatih/gomodifytags \
  github.com/mgechev/revive \
  github.com/go-delve/delve/cmd/dlv \
  # Install yq
  github.com/mikefarah/yq/v4
#
# golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin 2>&1
#
# Clean up
RUN apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
