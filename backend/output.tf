output "bucket_name" {
  value = aws_s3_bucket.s3.bucket
}
output "dynamo" {
  value = aws_dynamodb_table.dynamo.name
}