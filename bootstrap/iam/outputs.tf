output "terraform_access_key_id" {

  value     = aws_iam_access_key.terraform_user_keys.id
  sensitive = true

}

output "terraform_secret_access_key" {

  value     = aws_iam_access_key.terraform_user_keys.secret
  sensitive = true

}