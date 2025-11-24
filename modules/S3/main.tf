#create bucket 
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  lifecycle {
    prevent_destroy = false
  }
  tags ={
    Name = "${var.environment}_bucket_${var.bucket_name}"
  }
}

#versioning bucket 
resource "aws_s3_bucket_versioning" "V_bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

#encrypt 
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}