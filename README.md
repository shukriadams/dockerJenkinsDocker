# Dockerized Jenkins with docker support

Extends the official Jenkins docker image by adding support for docker inside Jenkins.

Available @ https://hub.docker.com/repository/docker/shukriadams/dockerjenkinsdocker

## Use

An existing container image can mounted using this compose script

    version: "2"
        services:
            jenkins:
                container_name: jenkins
                image: shukriadams/dockerjenkinsdocker:2.213
                restart: unless-stopped
                ports:
                - "8080:8080"
                volumes:
                - /var/run/docker.sock:/var/run/docker.sock/:rw

Note that docker.sock must be passed in to the container for this to work. Also, your host must have the same docker version as this container, which is 19.03.5

## Build your own

build with

    docker build -t yourcontainername .
