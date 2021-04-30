#!/bin/bash

set -eu

_main() {
    echo "Waiting for container ${INPUT_CONTAINER_NAME} to be ready..."
    _check_container_existance
}

_check_container_status() {
    CONTAINER_STATUS=""
    counter="0"

	while [ "${CONTAINER_STATUS}" != "healthy" ]; do
		sleep 1
		counter=$((counter+1))
        CONTAINER_STATUS=$(docker container inspect -f '{{.State.Health.Status}}' ${INPUT_CONTAINER_NAME})
		if [ "${CONTAINER_STATUS}" == "healthy" ]; then
            echo "Container ${INPUT_CONTAINER_NAME} has reached healthy status!"
            exit 0
		fi
		if [[ "${counter}" == "${INPUT_TIMEOUT}" ]]; then
			echo "Container ${INPUT_CONTAINER_NAME} has not reached healthy state in 5 minutes!"
            exit 1
        fi
	done

}

_check_container_existance() {
    CONTAINER_NAMES=""
    counter="0"

    while [ "${CONTAINER_NAMES}" != "${INPUT_CONTAINER_NAME}" ]; do
		sleep 1
		counter=$((counter+1))
        CONTAINER_NAMES=$(docker ps -a --format "{{.Names}}")
		if [ "${CONTAINER_NAMES}" != "" ]; then
            for container in ${CONTAINER_NAMES}; do
                if [ "$container" == "${INPUT_CONTAINER_NAME}" ]; then
                    sleep 10
                    _check_container_status
                fi
            done
		fi
		if [[ "${counter}" == "${INPUT_TIMEOUT}" || "${INPUT_CONTAINER_NAME}" == "" ]]; then
			echo "Container ${INPUT_CONTAINER_NAME} has not been deployed in 5 minutes!"
            exit 1
        fi
	done
}

_main
