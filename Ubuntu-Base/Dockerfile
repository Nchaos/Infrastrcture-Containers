FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN \
        # Update and Install dependencies for AzDO Agent
        apt-get update && \
        apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        iputils-ping \
        jq \
        libcurl4 \
        libicu60 \
        libunwind8 \
        lsb-release \
        libssl1.0 \
        software-properties-common

CMD ["/bin/bash"]