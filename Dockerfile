# base this container on official Jenkins image
FROM jenkins/jenkins:2.527

# the jenkins image we're extending will be set to user:jenkins, switch to root so we can install stuff
USER root

RUN apt-get update \
    # utils needed to install docker
    && apt-get -y install wget \
    && apt-get -y install curl \
    # libs required by docker
    && apt-get -y install libseccomp2 \
    && apt-get -y install iptables \
    && apt-get -y install libdevmapper-dev  
    # install docker @ 19.03 explicitly
    wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_1.2.6-3_amd64.deb \
    && wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && dpkg -i docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && dpkg -i containerd.io_1.2.6-3_amd64.deb \
    && dpkg -i docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \ 
    && curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \ 
    # clean up docker install files
    && rm docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && rm containerd.io_1.2.6-3_amd64.deb \
    && rm docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    # docker-compose needs to be explicitly set to executable as it wasn't installed via installer
    && chmod +x /usr/local/bin/docker-compose \
    # add jenkins user to docker group so it can access docker daemon
    && usermod -aG docker jenkins \
    # remeove utils. We'll keep curl because why not
    && apt-get remove wget -y

# revert to user:jenkins that container expects to run as
USER jenkins
