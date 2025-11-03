resource "aws_instance" "test-server" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"
  key_name = "test"
  vpc_security_group_ids = ["vpc-01a93eb9b5bae4d14"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./test.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server1"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/finance-project/terraform-files/ansibleplaybook.yml"
     }
  }
