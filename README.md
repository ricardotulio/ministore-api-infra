# Infrastructure as Code with Terraform

This repository contains Terraform configuration files to set up a comprehensive infrastructure on AWS. The infrastructure includes:

- **Amazon EC2 Instance**
- **Amazon RDS (PostgreSQL)**
- **VPC with Public and Private Subnets**
- **Security Groups**
- **SSM Parameter Store for Sensitive Information**

## Prerequisites

Before you start, ensure you have the following installed and configured:

### 1. **Terraform**

Terraform is used for infrastructure as code. Follow the official [Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli) for installation instructions.

### 2. **AWS CLI**

The AWS CLI is required to interact with AWS services. Follow the official [AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) for installation instructions.

### 3. **AWS Credentials**

You need to set your AWS credentials as environment variables. Export the following variables in your terminal session:

```sh
$ export AWS_ACCESS_KEY_ID="your_access_key_id"
$ export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
```

Replace `"your_access_key_id"`, `"your_secret_access_key"`, and `"your_default_region"` with your actual AWS credentials and preferred region.

### 4. **Configure Environment Variables Permanently**

To make these environment variables available in all terminal sessions, add the export commands to your shell configuration file. For `bash` users, add them to `~/.bashrc`:

```sh
$ echo 'export AWS_ACCESS_KEY_ID="your_access_key_id"' >> ~/.bashrc
$ echo 'export AWS_SECRET_ACCESS_KEY="your_secret_access_key"' >> ~/.bashrc
$ echo 'export AWS_DEFAULT_REGION="your_default_region"' >> ~/.bashrc
$ source ~/.bashrc
```

## Setting Up Terraform Variables

To configure Terraform for your environment, you'll need to provide certain variables in the terraform.tfvars file. This file should be created in the root of your Terraform configuration directory.
Steps to Configure terraform.tfvars

1. **Create the terraform.tfvars file:**

If it does not already exist, create a file named terraform.tfvars in the root directory of your Terraform project, or create a copy from `terraform.tvars.example`.

2. **Add the required variables:**

Open the terraform.tfvars file and add the following variables. Make sure to replace any placeholder values with your actual values as needed.

```hcl
ssh_user                = "your-user"
ssh_private_key_path    = "/path/to/id_rsa"
ssh_public_key_path     = "/path/to/id_rsa.pub"
ec2_home_path           = "/home/ec2-user"
db_name                 = "your db name here"
db_username             = "your db user here"
github_owner            = "your github account here"
github_project          = "your github project here"
github_repo             = "your github repo here (e.g.: https://github.com/ricardotulio/ministore-api/)"
github_branch           = "master"
github_token            = "your github token here"
```

These variables are used to configure the database settings for your infrastructure.

## GitHub Access Token

To enable CodePipeline to access your GitHub repository and trigger builds, you need to provide a GitHub personal access token. This token is used by Terraform to configure CodePipeline.
Steps to Add the GitHub Access Token

1. **Generate a GitHub Access Token:**
Follow the instructions in the GitHub Personal Access Tokens documentation to generate a new token.

2. **Add the GitHub Token to terraform.tfvars:**
Open your terraform.tfvars file, or create one if it does not exist.
Add the following entry to the file:

```hcl
github_token = "your_github_token_here"
```

Replace your_github_token_here with the token you obtained.

## Generate SSH Key Pair

You need to generate an SSH key pair to access your EC2 instance. Follow these steps:

1. **Generate the SSH Key Pair**

Use the following command to generate a new SSH key pair:

```sh
$ ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
```

This command will create two files:

```sh
~/.ssh/id_rsa (private key)
~/.ssh/id_rsa.pub (public key)
```

## IAM Permissions

To successfully deploy and manage the infrastructure defined in this repository, ensure that your IAM user or role has the following permissions:

- **AmazonEC2FullAccess**: Allows full access to Amazon EC2 resources.
- **AmazonRDSFullAccess**: Allows full access to Amazon RDS resources.
- **AmazonS3FullAccess**: Allows full access to Amazon S3 resources.
- **AmazonSSMFullAccess**: Allows full access to AWS Systems Manager (SSM) resources.
- **AWSCodeBuildAdminAccess**: aLLOWS full access to AWS CodeBuild via the AWS Management Console.
- **IAMFullAccess**: Allows full access to IAM via the AWS Management Console.

These permissions are needed to create, modify, and manage EC2 instances, RDS instances, S3 buckets, and SSM parameters.

## Usage

### 1. **Clone the Repository**

First, clone the repository to your local machine:

```sh
$ git clone https://github.com/ricardotulio/ministore-api-infraestructure
$ cd ministore-api-infraestructure
```

### 2. **Initialize Terraform**

Initialize Terraform to download the necessary providers and set up the backend:

```sh
$ terraform init
```

### 3. **Review the Configuration**

Before applying changes, review the Terraform configuration files in the repository. Key files include:

- **`providers.tf`**: Defines the providers used in the configuration, including AWS settings.
- **`variables.tf`**: Contains the input variables required for the Terraform configuration.
- **`network.tf`**: Configures the VPC, subnets, and internet gateway for network setup.
- **`db_subnet_group.tf`**: Configures the RDS subnet group for database instance network placement.
- **`security_groups.tf`**: Sets up the security groups to control access to EC2 instances and RDS.
- **`ssh-key.tf`**: Manages the SSH key pairs used to access EC2 instances.
- **`ec2.tf`**: Defines the EC2 instances and their configurations, including security groups and subnets.
- **`rds.tf`**: Configures the RDS instance, specifying database engine, instance class, and subnet group.

### 4. **Plan the Changes**

Generate an execution plan to see what changes will be made:

```sh
$ terraform plan
```

### 5. **Apply the Changes**

Apply the configuration to create the infrastructure:

```sh
$ terraform apply
```

You will be prompted to confirm that you want to make these changes. Type `yes` to proceed.

### 6. **Destroy the Infrastructure**

To destroy all resources created by this configuration, run:

```sh
$ terraform destroy
```

You will be prompted to confirm that you want to destroy these resources. Type `yes` to proceed.

## Configuration Files

- **`variables.tf`**: Contains all the variables used in the configuration.
- **`terraform.tfvars`**: (Optional) Place your variable values here. This file is not included in the repository for security reasons.

## Security Considerations

- **Sensitive Information**: The repository uses AWS SSM Parameter Store to manage sensitive information like database passwords. Ensure that you have the correct IAM permissions for SSM operations.
- **IAM Policies**: Make sure that your IAM user or role has the necessary permissions to create and manage the resources defined in the Terraform configuration.

## Contributing

Feel free to open issues and submit pull requests. For substantial changes, please discuss them with the maintainers first.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please contact [ledo.tulio@gmail.com].