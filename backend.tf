# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "jm-my-bucket"
    key            = "PROJECT-MAIN-FOLDER/rentzone/terraform.tfstate"
    region         = "us-east-2"
    profile        = "akhil"
    dynamodb_table = "terraform-table"
  }
}