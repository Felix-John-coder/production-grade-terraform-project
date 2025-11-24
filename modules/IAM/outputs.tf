output "role_arn" {
  value = aws_iam_role.role.arn
}
output "policy_arn" {
  value = aws_iam_policy.policy.arn
}
output "ec2_profile" {
  value = aws_iam_instance_profile.profile_instance.id
}