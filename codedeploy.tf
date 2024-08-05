resource "aws_codedeploy_app" "ministore_api_app" {
  name = "ministore-api-application"
}

resource "aws_codedeploy_deployment_group" "ministore_api_deployment_group" {
  app_name              = aws_codedeploy_app.ministore_api_app.name
  deployment_group_name = "ministore-api-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  ec2_tag_filter {
    key   = "Name"
    value = "ministore-api-ec2"
    type  = "KEY_AND_VALUE"
  }

  ec2_tag_filter {
    key   = "DeploymentState"
    value = "Active"
    type  = "KEY_AND_VALUE"
  }
}

resource "aws_iam_role" "codedeploy_service_role" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AWSCodeDeployRole managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "codedeploy_role_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}