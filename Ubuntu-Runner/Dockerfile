FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive \
        API_TOKEN= \
        HOME=/home/runner \
        RUNNER_TOKEN= \
        RUNNER_WORKPLACE=actions-runner \
        #GITHUB_ORG=https://github.com/USDC-ORG \
        GITHUB_ORG=USDC-ORG \
        GITHUB_RUNNER_GROUP= \
        GITHUB_RUNNER_NAME= \
        GITHUB_RUNNER_LABELS= \
        GITHUB_RUNNER_WORKDIRETORY=

# Specify Terraform and Golang version here, for now, this uses the latest as of 3/16/2021
ARG TERRAFORM_VERSION=0.14.8
ARG GOLANG_VERSION=2:1.16-1longsleep1+bionic

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes; \
################################
# Update and Install dependencies for AzDO Agent
################################
        apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        gnupg \
        iputils-ping \
        jq \
        libcurl4 \
        libicu60 \
        libunwind8 \
        lsb-release \
        make \
        netcat \
        libssl1.0 \
        software-properties-common \
        unzip \ 
        wget; \
#
# Installing additional tools that the AzDO Agent needs for now
#
        # Repository for golang
        add-apt-repository ppa:longsleep/golang-backports; \
        # Repository for Pwsh
        add-apt-repository universe; \
        # GPG keys for docker
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg; \
        echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null; \
        # Download the Microsoft repository GPG keys
        wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb; \
        # Register the Microsoft repository GPG keys
        dpkg -i packages-microsoft-prod.deb; \
        apt-get update && apt-get install -y --no-install-recommends \
        # Install Docker
        docker-ce \
        docker-ce-cli \
        containerd.io \
        # Install Go Lang         
        # This step is separated because software-properties-common needs to be installed before add-apt-repository can be used
        build-essential \
        golang-go=${GOLANG_VERSION} \
        # Install Pwsh
        powershell; \
        # Install Az CLI
        curl -sL https://aka.ms/InstallAzureCLIDeb | bash; \
        # Download terraform for linux
        wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip; \
	# Unzip Terraform
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip; \
	# Move to local bin
	mv terraform /usr/local/bin/; \
	# Make it executable
	chmod +x /usr/local/bin/terraform; \
	# Check that it's installed
	terraform --version; \
        # Install Az modules
        pwsh -Command Install-Module Az -Force -Verbose; \
#
#  Creating runner user
#
        useradd -ms /bin/bash runner

        
WORKDIR $HOME

COPY /docker-entrypoint.d/* ./docker-entrypoint.d/
COPY docker-entrypoint.sh ./

RUN chown -R runner:runner $HOME && \
        chmod -R 0755 $HOME/

USER runner

ENTRYPOINT ["/bin/bash", "./docker-entrypoint.sh"]
