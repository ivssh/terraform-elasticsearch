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
#### Some answers we are looking:
1. What did you choose to automate the provisioning and bootstrapping of the instance? Why?
A. For provisioning and automating, I choose Terraform. Terraform is an excellent infrastructure provisioner coupled with configuration management as well. I would have gone with using Packer + Terraform OR Terraform + Ansible, but given the time contrainsts and possibility of running into rabbit hole issues I stuck to only Terraform

2. How did you choose to secure ElasticSearch? Why?
Choose to secure Elasticsearch using the bootstrap password on can supply using the keystore API. This step could also be automated in bash. Other things not considered in this assignment are securing the Elasticsearch with generating certs using the certutil, all because I couldn't figure out how to automate this stuff. Can do it by manually sshing into the instance.

3. How would you monitor this instance? What metrics would you monitor?
You can monitor the instance using the stack monitoring provided by elasticsearch OR by pushing the elasticsearch logs and syslogs to Prometheus + Grafana. Some metrics I'll monitor are Java Heap space utilization, CPU utilization, Threadpool size, Queries per second, Slow queries logs, Network IO.

4. Could you extend your solution to launch a secure cluster of ElasticSearch nodes? What
would need to change to support this use case?
The solution already launches a secure cluster of Elasticsearch nodes, although the communication between the nodes isn't encrypted. For that I'll have to generate certs and propogate it to every node in the cluster at the /etc/elasticsearch directory.

5. Could you extend your solution to replace a running ElasticSearch instance with little or no
downtime? How?
Changes to infrastructure like bumping up the RAM, etc will have some downtime that terraform takes to change the state. Its of the order of ~5 minutes. For no downtime, I would have a backup instance spawned and only then do changes to the existing instance. If we are talking about a cluster then we change the node configs one at a time to ensure availability and also ensure that we don't encounter split brain situation.

6. Was it a priority to make your code well structured, extensible, and reusable?
Yes, I have broken down the code into modules so that individual modules can be reused.

7. What sacrifices did you make due to time?
Wanted to pick a more robust stack to implement this solution maybe by including ansible. Also haven't implemented the certificates part of the security because generating certificates requires responding to prompts, didn't have an elegant solution to automate it.

## References
- https://github.com/pelias/terraform-elasticsearch
- Terraform module registry
- Terraform documentaion

## License
This project is distributed under the Apache License Version 2.0