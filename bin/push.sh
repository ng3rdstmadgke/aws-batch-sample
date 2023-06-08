#!/bin/bash

function usage {
cat <<EOS >&2
$0 REMOTE_IMAGE_URI [OPTIONS]

REMOTE_IMAGE_NAME
  xxxxxxx/yyy/zzz:latest

[OPTIONS]
  -h, --help
    Show usage.
 --profile <AWS_PROFILE>:
   Specify the aws profile name.
EOS
exit 1
}

export DOCKER_BUILDKIT=1 
SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/..; pwd)


AWS_PROFILE_OPTION=
AWS_REGION="ap-northeast-1"
while [ "$#" != 0 ]; do
  case $1 in
    -h | --help     ) usage;;
    --profile       ) shift; AWS_PROFILE_OPTION="--profile $1" ;;
    --              ) shift; opts+=($@); break ;;
    -* | --*        ) echo "$1 : 不正なオプションです" >&2; exit 1 ;;
    *               ) args+=("$1") ;;
  esac
  shift
done

[ ${#args[@]} -lt 1 ] && echo "引数が不足しています" >&2 && usage

REMOTE_IMAGE_NAME=${args[0]}

set -e

AWS_ACCOUNT_ID=$(aws $AWS_PROFILE_OPTION sts get-caller-identity --query 'Account' --output text)
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
cd "$PROJECT_ROOT"

REMOTE_IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/${REMOTE_IMAGE_NAME}"

docker build --rm -f docker/job/Dockerfile -t $REMOTE_IMAGE_URI .
docker push $REMOTE_IMAGE_URI