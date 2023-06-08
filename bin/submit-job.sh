#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/..; pwd)

STACK_FILE="${ROOT_DIR}/stack/aws-batch-sample.yml"
STACK_NAME=$(basename $STACK_FILE .yml)

set -eu

cd $ROOT_DIR
JOB_NAME="${STACK_NAME}-$(date +%Y%m%d%H%M%S)"
JOB_QUEUE=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`JobQueue`].OutputValue' --output text)
JOB_DEFINITION=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`JobDefinition`].OutputValue' --output text)

aws batch submit-job \
  --job-name $JOB_NAME \
  --job-queue $JOB_QUEUE \
  --job-definition $JOB_DEFINITION