terraform {
  backend "s3" {
    bucket = "event-stream-terraform-state-36u5es"
    key            = "production/terraform.tfstate"
    region         = "af-south-1"
    # dynamodb_table = "terraform-state-locks"
    encrypt        = true
    use_lockfile   = true
  }
}