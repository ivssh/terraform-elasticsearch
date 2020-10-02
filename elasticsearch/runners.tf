resource "null_resource" "elasticsearch-runner" {
  count = "${var.num_of_instances}"

  depends_on = [aws_eip.elasticsearch_eip]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("~/.ssh/yulu_assignment.pem")}"
    host        = "${element(aws_eip.elasticsearch_eip.*.public_ip, count.index)}"
  }

  provisioner "file" {
    source      = "elasticsearch/install_elasticsearch.sh"
    destination = "/home/ubuntu/install_elasticsearch.sh"
  }

  provisioner "file" {
    # If no binary is specified, we'll copy /dev/null (always 0 bytes) to the
    # instance. The "remote-exec" block will then overwrite that. There's no
    # such thing as conditional file copying in Terraform, so we fake it.
    source      = "${coalesce(var.elastic_binary, "/dev/null")}"
    destination = "/home/ubuntu/elasticsearch"
  }

  # Install Elasticsearch.
  provisioner "remote-exec" {
    inline = [
      "sudo bash install_elasticsearch.sh"
    ]
  }
}

resource "null_resource" "elasticsearch-post-runner" {
  count = "${var.num_of_instances}"

  depends_on = [aws_eip.elasticsearch_eip]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("~/.ssh/yulu_assignment.pem")}"
    host        = "${element(aws_eip.elasticsearch_eip.*.public_ip, count.index)}"
  }

  # Install Elasticsearch.
  provisioner "remote-exec" {
    inline = [
      "echo 'node.name: ${element(aws_instance.elasticsearch_instance.*.private_ip, count.index)}' | sudo tee -a /etc/elasticsearch/elasticsearch.yml",
      "echo 'network.host : 0.0.0.0' | sudo tee -a /etc/elasticsearch/elasticsearch.yml",
      "echo  'discovery.seed_hosts:  ${jsonencode(aws_instance.elasticsearch_instance.*.private_ip)}' | sudo tee -a /etc/elasticsearch/elasticsearch.yml",
      "echo 'cluster.name: elasticsearch' | sudo tee -a /etc/elasticsearch/elasticsearch.yml",
      "echo 'xpack.security.enabled: true' | sudo tee -a /etc/elasticsearch/elasticsearch.yml"
    ]
  }
}

resource "null_resource" "security-setup-runner" {
  count = "${var.num_of_instances}"

  depends_on = [aws_eip.elasticsearch_eip]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("~/.ssh/yulu_assignment.pem")}"
    host        = "${element(aws_eip.elasticsearch_eip.*.public_ip, count.index)}"
  }

  # Install Elasticsearch.
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i '22,23 s/^/#/' /etc/elasticsearch/jvm.options",
      "echo '-Xms512m' | sudo tee -a /etc/elasticsearch/jvm.options",
      "echo '-Xmx512m' | sudo tee -a /etc/elasticsearch/jvm.options",
      "cd /usr/share/elasticsearch",
      "echo ${var.elastic_password} | sudo ./bin/elasticsearch-keystore add -xf bootstrap.password",
      "sudo service elasticsearch restart",
      "sudo systemctl enable elasticsearch"
    ]
  }
}