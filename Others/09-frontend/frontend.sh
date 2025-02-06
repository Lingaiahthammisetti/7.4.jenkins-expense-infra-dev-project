#!/bin/bash
component=$1
environment=$2
dnf install ansible -y
pip3.9 install botocore boto3
ansible-pull -i localhost, -U https://github.com/Lingaiahthammisetti/4.10.2.expense-ansible-roles-tf-Infra-Dev.git main-tf.yaml -e component=$component -e env=$environment

