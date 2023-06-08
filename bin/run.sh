#!/bin/bash

function usage {
cat <<EOS >&2
$0 [OPTIONS]

[OPTIONS]
  -h, --help
    Show usage.
  -e, --env-file
    Specify the environment file.
EOS
exit 1
}

export DOCKER_BUILDKIT=1 
SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/..; pwd)


ENV_FILE=$ROOT_DIR/.env
while [ "$#" != 0 ]; do
  case $1 in
    -h | --help     ) usage;;
    -e | --env-file ) shift; ENV_FILE="$1" ;;
    --              ) shift; opts+=($@); break ;;
    -* | --*        ) echo "$1 : 不正なオプションです" >&2; exit 1 ;;
    *               ) args+=("$1") ;;
  esac
  shift
done

[ ! -f $ENV_FILE ] && echo "$ENV_FILE : ファイルが存在しません" >&2 && exit 1


set -e
cd $ROOT_DIR
IMAGE_NAME="aws-batch-sample/job:latest"
docker build --rm -f docker/job/Dockerfile -t $IMAGE_NAME .

docker run --rm -it \
  --network host \
  --env-file $ENV_FILE \
  $IMAGE_NAME \
  /entrypoint.sh