# Create CodeBuild project
resource "aws_codebuild_project" "ministore_api_build" {
  name          = "ministore-api-build"
  description   = "Build project for the ministore-api Java application"
  service_role  = aws_iam_role.ministore_api_codebuild_role.arn
  build_timeout = 20

  source {
    type                = "GITHUB"
    location            = var.github_repo
    buildspec           = "buildspec.yml"
    git_clone_depth     = 1 # Optional: Limits the clone depth
    report_build_status = true
  }

  artifacts {
    type                   = "S3"
    location               = aws_s3_bucket.ministore_api_codebuild_artifact_bucket.bucket
    packaging              = "ZIP"
    path                   = "artifacts/"
    override_artifact_name = false
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"                           # Choose appropriate compute type
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0" # Managed image with Java
    type         = "LINUX_CONTAINER"
  }

  tags = {
    Name        = "ministore-api-build"
    Environment = "Production"
  }
}

# Create an S3 Bucket for storing build artifacts
resource "aws_s3_bucket" "ministore_api_codebuild_artifact_bucket" {
  bucket_prefix = "ministore-api-codebuild-artifacts"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "ministore-api-artifacts-bucket"
    Environment = "Production"
  }
}

# IAM Role for CodeBuild
resource "aws_iam_role" "ministore_api_codebuild_role" {
  name = "CodeBuildServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to CodeBuild IAM Role
resource "aws_iam_role_policy_attachment" "ministore_api_codebuild_policy_attach" {
  role       = aws_iam_role.ministore_api_codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_logs_policy_attach" {
  role       = aws_iam_role.ministore_api_codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_s3_access" {
  role       = aws_iam_role.ministore_api_codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Allows full access to S3
}