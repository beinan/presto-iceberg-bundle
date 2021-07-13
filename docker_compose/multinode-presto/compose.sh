#!/usr/bin/env bash

set -euo pipefail

source "${BASH_SOURCE%/*}/../base/base.sh"

docker-compose \
    -f ${BASH_SOURCE%/*}/../base/docker-compose.yml \
    -f ${BASH_SOURCE%/*}/docker-compose.yml \
    "$@"