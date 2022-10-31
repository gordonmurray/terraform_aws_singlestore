data "aws_ami" "singlestore" {
  most_recent = true

  filter {
    name   = "name"
    values = ["singlestore*"]
  }

  owners = [var.aws_account_id]
}

resource "aws_instance" "singlestore" {
  ami                     = data.aws_ami.singlestore.id
  instance_type           = "t3.xlarge"
  key_name                = aws_key_pair.key.key_name
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.singlestore.id]
  disable_api_termination = true

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = "100"
    volume_type           = "gp3"
  }

  user_data = <<EOF
#!/usr/bin/env bash
# Set some values in the cluster file
sed -i "s/xxxxxxxxxx/${var.singlestore_license}/" /home/ubuntu/cluster.yml
sed -i "s/xxx.xxx.xxx.xxx/`ec2metadata --local-ipv4`/" /home/ubuntu/cluster.yml
# Start the cluster
cd /home/ubuntu && sdb-deploy setup-cluster --cluster-file cluster.yml -y
# Start the UI on port 8080
sudo memsql-studio
EOF

  tags = {
    Name = "singlestore"
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

}
