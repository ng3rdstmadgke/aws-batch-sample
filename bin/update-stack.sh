#!/bin/bash

IMAGE_NAME=$1
VPC_ID=$2
SUBNET_ID=$3

SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/..; pwd)

STACK_FILE="${ROOT_DIR}/stack/aws-batch-sample.yml"
STACK_NAME=$(basename $STACK_FILE .yml)

cd $ROOT_DIR
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
IMAGE_ARN="${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/${IMAGE_NAME}"

aws cloudformation update-stack \
--stack-name $STACK_NAME \
--template-body file://$STACK_FILE \
--capabilities CAPABILITY_NAMED_IAM \
--parameters \
  "ParameterKey=JobImage,ParameterValue=${IMAGE_ARN}" \
  "ParameterKey=VpcId,ParameterValue=${VPC_ID}" \
  "ParameterKey=SubnetId,ParameterValue=${SUBNET_ID}" \