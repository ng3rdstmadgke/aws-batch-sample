#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/..; pwd)

STACK_FILE="${ROOT_DIR}/stack/aws-batch-sample.yml"
STACK_NAME=$(basename $STACK_FILE .yml)

cd $ROOT_DIR

aws cloudformation delete-stack --stack-name $STACK_NAME