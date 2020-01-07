##########IAM ROLE FOR LAMBDA
resource "aws_iam_role" "concou-lambda_role" {
    name = "${var.project_name}-concou-lambda_role"
    tags = {
      Project = "${var.project_name}"
    }
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": "lambda.amazonaws.com"
          },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

##########IAM POLICY FOR LAMBDA
resource "aws_iam_role_policy" "concou-lambda_policy" {
  name = "${var.project_name}-concou-lambda_policy"
  role = "${aws_iam_role.concou-lambda_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:CreateTags",
                "ec2:ModifySnapshotAttribute",
                "ec2:ResetSnapshotAttribute"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
