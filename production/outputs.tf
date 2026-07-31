output "public_ip" {

  value = aws_eip.webrtc_ip.public_ip
}

output "instance_id" {

  value = aws_instance.webrtc_server.id
}