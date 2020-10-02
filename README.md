# Terraform Elasticsearch

Spin a single instance or cluster of elasticseach nodes on AWS EC2. Also provisions supporting infrasturcture like VPC, Gateways, etc.

### What's possible

  - Spin up **secure** elasticsearch cluster
  - Both in public subnet and private subnet
  - One time config of Elasticsearch nodes

### Pre-requisites

  - Terraform installed
  - AWS CLI installed and configured with access key and secret
  - Ensure the **pem file** is in `~/.ssh`
  - Add the public key of the corresponding pem file to `main.tf` in `"aws_key_pair" "deployment"` resource

## Steps to launch a Elasticsearch cluster

#### Single node with default password
```sh
$ terraform init
$ terraform plan -out=elastic_cluster.tfplan
$ terraform apply "elastic_cluster.tfplan"
```

#### Variable number of instances
```sh
$ terraform init
$ terraform plan -out=elastic_cluster.tfplan
$ terraform apply -var 'num_of_instaces=<any_integer>' "cockroach_cluster.tfplan"
```

#### Variable number of instances and Custom password
```sh
$ terraform init
$ terraform plan -out=elastic_cluster.tfplan
$ terraform apply -var 'num_of_instaces=<any_integer>' -var 'elastic_password=<any-string>' "cockroach_cluster.tfplan"
```

#### Testing the infrastructure

Elastic instance without password
```sh
$ curl http://<public-ip-of-any-Elastic-instance>:9200
```

Elastic instance without password
```sh
$ curl http://elastic:<password>@<public-ip-of-any-Elastic-instance>:9200
```
## References
- https://github.com/pelias/terraform-elasticsearch
- Terraform module registry
- Terraform documentaion

## License
This project is distributed under the Apache License Version 2.0