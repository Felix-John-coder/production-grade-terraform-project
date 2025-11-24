#create  an iam role 
resource "aws_iam_role" "role" {
  name = var.role_name 
  assume_role_policy = var.the_role_policy
  tags = {
    Name = "${var.environment}_role_${var.role_name}"
  }
}
#create the policy
resource "aws_iam_policy" "policy" {
  name = var.policy_name 
  policy = var.the_policy
  tags = {
    Name = "${var.environment}_policy_${var.policy_name}"
  }
}
# attach the policy and the role
resource "aws_iam_role_policy_attachment" "attach_role_policy" {
  role = aws_iam_role.role.id
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "profile_instance" {
  role = aws_iam_role.role.id
  
}