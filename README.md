# Dockerized Jenkins with Docker support

Extends the official Jenkins Docker image by adding support for Docker inside Jenkins. Tags follow official Jenkins tags, check Dockerfile for which version of Docker is compiled into the container.

Available @ https://hub.docker.com/repository/docker/shukriadams/dockerjenkinsdocker

## Use

An existing container image can mounted using docker-compose as folllows

    version: "2"
        services:
            jenkins:
                container_name: jenkins
                image: shukriadams/dockerjenkinsdocker:2.213
                restart: unless-stopped
                ports:
                - "8080:8080"
                user: "root:${GID}" # for container users
                volumes:
                - ./data:/var/jenkins_home/:rw
                - /var/run/docker.sock:/var/run/docker.sock/:rw

### Conditions 

- Docker.sock must be passed in to the container for this to work
- You need to set permissions of the socket on the host with, the simplest way is with
    
      chmod 666 /var/run/docker.sock 

  You can presumably also fix this by giving the jenkins user (1000) special access to the host socket
- The container host's Docker must be same version as the container's - @ Jenkins 2.213, Docker version is 19.03.5 To install Docker at this version use

        wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_1.2.6-3_amd64.deb \
            && wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
            && wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \
            && sudo dpkg -i docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
            && sudo dpkg -i containerd.io_1.2.6-3_amd64.deb \
            && sudo dpkg -i docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \ 
            && curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \   
            && rm docker-ce-cli_19.03.5~3-0~ubuntu-bionic_amd64.deb \
            && rm containerd.io_1.2.6-3_amd64.deb \
            && rm docker-ce_19.03.5~3-0~ubuntu-bionic_amd64.deb \
            && sudo chmod +x /usr/local/bin/docker-compose \
            && sudo usermod -aG docker jenkins 
            
## Build your own

Build with

    docker build -t yourcontainername .

## Using containers within this container

`docker` is available within this container from the command line, but if you want to persist your data outside of the container with volume mounts, you'll need to
pay attention to paths - paths are relative to the filesystem that is hosting the Jenkins container. If for example your Jenkins container's home directory is mounted
to /srv/jenkins/data on the host machine, then your job should mount to this absolute path

    docker run -u ${UID}:${GID} -v /srv/jenkins/data/workspace/"$JOB_NAME":/tmp/myworkdir ubuntu:22.04 touch myfile
    
This will create a file `myfile` in the Jenkins workspace for the current job.
