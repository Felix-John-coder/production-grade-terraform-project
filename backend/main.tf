locals {
  bucket_name  = "felix-aws-bucket-terraform"
  dynanmo_name = "dynamo_name_terrafrmlock"
}

#create an s3 bucket
resource "aws_s3_bucket" "s3" {
  bucket = local.bucket_name
  tags = {
    Name = "terraform_tfstate"
  }
}
# creat bucker versioning for safet roller if needed
resource "aws_s3_bucket_versioning" "bucker_versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encript" {
  bucket = aws_s3_bucket.s3.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}
resource "aws_dynamodb_table" "dynamo" {
  name         = local.dynanmo_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  lifecycle {
    prevent_destroy = false
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    key  = "terrform_lock"
    Name = "terraform_lock_file"
  }
}