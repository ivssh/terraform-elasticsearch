resource "null_resource" "elasticsearch-runner" {
  count = "${var.num_of_instances}"

  depends_on = [aws_eip.elasticsearch_eip]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/yulu_assignment.pem")}"
    host = "${element(aws_eip.elasticsearch_eip.*.public_ip, count.index)}"
  }

  provisioner "file" {
    source = "elasticsearch/install_elasticsearch.sh"
    destination = "/home/ubuntu/install_elasticsearch.sh"
  }

  provisioner "file" {
    # If no binary is specified, we'll copy /dev/null (always 0 bytes) to the
    # instance. The "remote-exec" block will then overwrite that. There's no
    # such thing as conditional file copying in Terraform, so we fake it.
    source = "${coalesce(var.elastic_binary, "/dev/null")}"
    destination = "/home/ubuntu/elasticsearch"
  }

  # Install Elasticsearch.
  provisioner "remote-exec" {
    inline = [
      "sudo bash install_elasticsearch.sh"
    ]
  }
}