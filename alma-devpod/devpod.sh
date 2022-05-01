#!/bin/bash

DEVPOD_USER=podder
BASE_NAME=alma-devpod
IMG_VERSION=${IMG_VERSION:-latest}
ARTIFACT_VERSIONED_NAME=docker.io/library/${BASE_NAME}:${IMG_VERSION}
CONTAINER_NAME=${BASE_NAME}-${IMG_VERSION}-${USER:-local}

usage() {
    echo -e "Usage: $(basename $0) build|publish|run-shell|exec-shell|dev-shell|info|clean"
    exit 1
}

case "$1" in
"build")
    podman build -t ${ARTIFACT_VERSIONED_NAME} .
    ;;
"publish")
    podman push ${ARTIFACT_VERSIONED_NAME}
    ;;
"run-shell")
    podman run --name ${CONTAINER_NAME} -it ${ARTIFACT_VERSIONED_NAME}
    ;;
"exec-shell")
    podman start ${CONTAINER_NAME} || echo -e "Container already started!"
    podman exec -it ${CONTAINER_NAME} /bin/bash
    ;;
"dev-shell")
    ## Create required folder and content
    podman unshare mkdir -p $HOME/podvol/ssh
    podman unshare touch $HOME/podvol/gitconfig
    podman unshare chmod 700 $HOME/podvol/ssh

    ## Setup rw access to container user (i.e., with uid 1000)
    podman unshare chown 1000:1000 -R $HOME/podvol/ssh
    podman unshare chown 1000:1000 $HOME/podvol/gitconfig

    ## Finally, start the container
    podman run --name ${CONTAINER_NAME} ${ELE_DEVPOD_ENVFILE} \
        -v $HOME/podvol/ssh:/home/${DEVPOD_USER}/.ssh:Z \
        -v $HOME/podvol/gitconfig:/home/${DEVPOD_USER}/.gitconfig:Z \
        -it ${ARTIFACT_VERSIONED_NAME}
    ;;
"info")
    echo -e "Devpod image name: ${ARTIFACT_VERSIONED_NAME}"
    echo -e "Devpod container name: ${CONTAINER_NAME}"
    ;;
"clean")
    podman stop ${CONTAINER_NAME} && sync
    sleep 3 && podman rm ${CONTAINER_NAME}
    ;;
"*")
    usage
    ;;
esac

exit 0
