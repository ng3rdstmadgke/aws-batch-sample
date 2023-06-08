# ECSにリポジトリを作成

今回は `aws-batch-sample/job` というリポジトリを作ってみた。


# 変数定義

```bash
# ジョブイメージの名前
IMAGE_NAME=aws-batch-sample/job:latest
# vpc id
VPC_ID=vpc-xxxxxxxxxxxxxxxxx
# subnet id
SUBNET_ID=subnet-xxxxxxxxxxxxxxxxx
```

# イメージのpush

```bash
./bin/push.sh $IMAGE_NAME --profile default
```

# CloudFormation

```bash

# Create
./bin/create-stack.sh $IMAGE_NAME $VPC_ID $SUBNET_ID

# Update
./bin/update-stack.sh $IMAGE_NAME $VPC_ID $SUBNET_ID

# Delete
./bin/delete-stack.sh
```