FROM jenkins/jenkins:2.213
USER root

RUN apt-get update \
    && apt-get -y install wget \
    && apt-get -y install curl \
    && wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_1.2.6-3_amd64.deb \
    && wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && dpkg -i docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && apt-get -y install libseccomp2 \
    && apt-get -y install iptables \
    && apt-get -y install libdevmapper-dev  \
    && dpkg -i containerd.io_1.2.6-3_amd64.deb \
    && dpkg -i docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \ 
    && curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \ 
    && rm docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && rm containerd.io_1.2.6-3_amd64.deb \
    && rm docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \
    && chmod +x /usr/local/bin/docker-compose \
    && usermod -aG docker jenkins \
    # fixes permission error try to access socket when running as jenkins user
    && touch /var/run/docker.sock \
    && chmod 666 /var/run/docker.sock \
    && apt-get remove wget -y

USER jenkins