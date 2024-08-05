# CodePipeline
resource "aws_codepipeline" "ministore_api_pipeline" {
  name     = "ministore-api-pipeline"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.ministore_api_codebuild_artifact_bucket.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                = var.github_owner
        Repo                 = var.github_project
        Branch               = var.github_branch
        OAuthToken           = var.github_token
        PollForSourceChanges = "false" # Disable polling, use webhook instead
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.ministore_api_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.ministore_api_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.ministore_api_deployment_group.deployment_group_name
      }
    }
  }

  depends_on = [aws_instance.ministore-api, aws_db_instance.ministore-db]
}

# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_service_role" {
  name = "CodePipelineServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_s3_full_access" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Allows full access to S3
}

resource "aws_iam_role_policy_attachment" "codepipeline_codebuild_dev_access" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess" # Allows full access to S3
}

resource "aws_iam_role_policy_attachment" "codepipeline_codedeploy_full_access" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess" # Allows full access to S3
}