#! /bin/bash

set -eux

echo "### INSTALL PACKAGES"

yum update -y
yum install -y amazon-efs-utils

echo "### INSTALL SSM AGENT"

cd /tmp
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
start amazon-ssm-agent

echo "### SETUP EFS"

EFS_DIR=/mnt/efs
EFS_ID=${tf_efs_id}

mkdir -p $${EFS_DIR}
echo "$${EFS_ID}:/ $${EFS_DIR} efs tls,_netdev" >> /etc/fstab
mount -a -t efs defaults

echo "### SETUP AGENT"

echo "ECS_CLUSTER=${tf_cluster_name}" >> /etc/ecs/ecs.config