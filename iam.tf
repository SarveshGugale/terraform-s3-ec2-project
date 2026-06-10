resource "aws_iam_policy" "s3_script_access" {
  name        = "ec2-s3-script-access"
  description = "Allow EC2 to download scripts from S3"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::shells-scripts-pfizer-2027/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-script-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_script_access.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-profile"
  role = aws_iam_role.ec2_role.name
}