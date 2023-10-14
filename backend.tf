# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "my-green-bucket"
    key            = "PROJECT-MAIN-FOLDER/rentzone/terraform.tfstate"
    region         = "ap-south-1"
    profile        = "mounika"
    # dynamodb_table = "terraform-table"
  }
}