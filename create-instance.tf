resource "aws_instance" "instance" {
    ami                        = var.instance_ami
    availability_zone          = "${var.aws_region_az}"
    instance_type               = var.instance_type
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.sg.id]
    subnet_id                   = aws_subnet.subnet.id
    key_name                    = var.key_pair

    root_block_device{
        delete_on_termination   = true
        encrypted               = false
        volume_size             = var.root_device_size
        volume_type             = var.root_device_type
    }

     tags = {
    "Owner"                     =  var.owner
    "Name"                      = "${var.owner}-instance"
    "KeepInstanceRunning"       = "false"
    }

  # Copy in the bash script we want to execute.
  # The source is the location of the bash script
  # on the local linux box you are executing terraform
  # from.  The destination is on the new AWS instance.

  provisioner "file" {
    source                      = "script.sh"
    destination                 = "/tmp/script.sh"
  }

    # Change permissions on bash script and execute from ec2-user.
    provisioner "remote-exec" {
      inline = [
                             "chmod +x /tmp/script.sh",
                             "/tmp/script.sh"
      ]
    }
    
    connection {
      host                      = self.public_ip
      type                      = "ssh"
      user                      = "ec2-user"
      private_key               = file("/Users/shankar.pentyalaibm.com/Downloads/ansible-server.pem")

    }
}