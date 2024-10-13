# docker-compose has a limited understanding of relative paths and interprets them relative to
# compose-file location. We can't guarantee the shape of the paths coming from env variables,
# so we canonicalize them.
function export_canonical_path() {
    # make the path start with '/' or './'. Otherwise the result for 'foo.txt' is an absolute path.
    local PATH_REFERENCE=$1
    # when ref=var; var=value; then ${!ref} returns value
    # echo the variable to resolve any wildcards in paths
    local PATH
    PATH=$( echo ${!PATH_REFERENCE} )
    if [[ ${PATH} != /* ]] ; then
      PATH=./${PATH}
    fi
    if [[ -d $PATH ]]; then
        PATH=$(cd $PATH && pwd)
    elif [[ -f $PATH ]]; then
        PATH=$(echo "$(cd ${PATH%/*} && pwd)/${PATH##*/}")
    else
        echo "Invalid path: [$PATH]. Working directory is [$(pwd)]." >&2
        exit 1
    fi
    export $PATH_REFERENCE=$PATH
}

SCRIPT_DIR=${BASH_SOURCE%/*}
export_canonical_path SCRIPT_DIR
DOCKER_COMPOSE_CONF_LOCATION="${SCRIPT_DIR}/.."
export_canonical_path DOCKER_COMPOSE_CONF_LOCATION
PROJECT_ROOT="${DOCKER_COMPOSE_CONF_LOCATION}/.."
export_canonical_path PROJECT_ROOT
DOCKER_CONF_LOCATION="${PROJECT_ROOT}/docker_images"
export_canonical_path DOCKER_CONF_LOCATION

export DOCKER_IMAGES_VERSION=${DOCKER_IMAGES_VERSION:-10}
export HADOOP_BASE_IMAGE=${HADOOP_BASE_IMAGE:-"prestodb/hdp2.6-hive"}

export HIVE_PROXY_PORT=${HIVE_PROXY_PORT:-1180}

if [[ -z "${PRESTO_SERVER_DIR:-}" ]]; then
    if [[ -z "${PRESTO_PROJECT_DIR:-}" ]]; then
        PRESTO_PROJECT_DIR="${PROJECT_ROOT}/../presto"
    fi
    source "${PRESTO_PROJECT_DIR}/presto-product-tests/target/classes/presto.env"
    echo "Presto version found ${PRESTO_VERSION}"
    PRESTO_SERVER_DIR="${PRESTO_PROJECT_DIR}/presto-server/target/presto-server-${PRESTO_VERSION}/"
fi
export_canonical_path PRESTO_SERVER_DIR
