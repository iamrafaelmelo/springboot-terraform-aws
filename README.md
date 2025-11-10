# Spring Boot + Terraform

This repository is a study case for provisioning simple infrastructure with Terraform and deploying basic Spring Boot application on AWS.

## Table of contents

- [Requirements](#requirements)
- [Infrastructure](#infrastructure)
- [Running Locally](#running-locally)
- [Pack app](#pack-app)
- [Build app image](#build-app-image)
- [Preparing entrypoint](#preparing-entrypoint)
- [Creating programmatic user (Terraform)](#creating-programmatic-user-terraform)
- [Configuring AWS CLI](#configuring-aws-cli)
- [Generating SSH Key Pair](#generating-ssh-key-pair)
- [Attach your IP to SSH Rule](#attach-your-ip-to-ssh-rule)
- [Set up Terraform](#set-up-terraform)
- [Formatting and validating file](#formatting-and-validating-file)
- [Planning and provisioning resources](#planning-and-provisioning-resources)
- [Accessing application](#accessing-application)
- [Destroying infrastructure provisioned](#destroying-infrastructure-provisioned)
- [Next Steps with Terraform](#next-steps-with-terraform)
- [Links references](#links-references)

## Requirements

- [OpenJdk v21](https://openjdk.org/install)
- [Apache Maven](https://maven.apache.org/install.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Make (optional)

## Infrastructure

- EC2 Instance
- Key pair for SSH access
- Security Groups
    - Allow Http
    - Allow Https
    - Allow SSH access to EC2 (from a IPs list)
- User data file to prepare and run our application

## Running locally

```sh
./mvnw spring-boot:run
```

```sh
curl -i http://localhost:8080
```

Accessing the application url, must be possible see the instant datetime.

```json
{"datetime": "2025-11-09T00:00:00"}
```

## Pack app

In root path, run the following command:

```sh
make pack-app
```

## Build app image

```sh
make build-image
```

```sh
# before push image, do login
docker login ...

make push-image
```

## Preparing entrypoint

In `infra/userdata.sh` replace `<docker-username>` to your real docker username.

## Creating a programmatic user (Terraform)

1. Access the [AWS Console](https://console.aws.amazon.com)
2. Go to `IAM` section.
3. In left sidebar click on `User Groups` and click on Create User Group.
4. In create user group page, give a name to group of user.
5. In persmission section, select only `AmazonEC2FullAccess` and click on create user group.
6. In left sidebar click on `Users` and click on Create User.
7. In create user page, give a name to new user and click on next.
8. In permissions page keep selected `Add user to group`, select the group of user created previously and click on next and finally, Create User.
9. With user create, click on him to see details and following click on Create Access Key.
10. In access key page, select the use case, something like `Local Code` or `CLI`, mark confirmation checkbox, click on next and finally Create Access Key.

## Configuring AWS CLI

1. With the keys of access and secret, run `aws configure` in tyour terminal
2. Provide access key of programmatic user, press enter
3. Provide secret key of programmatic user, press enter
4. Provide a region where the resources are been created
5. Ignore output, press enter

## Generating SSH Key Pair

```sh
ssh-keygen -t rsa -b 4096 -C "EC2 Instance"
```

If you save out of default path or with another name, you must be change the ssh key path/name on `infra/main.tf` file.

## Attach your IP to SSH Rule

In the `infra/main.tf` just replace all occurrences of `<your-ip>` by your real IP.

## Set up Terraform

> From this section onwards, all commands must be executed in the `infra` folder.

With Terraform installed run the following command in root path of this project, to set up terraform with AWS.

```sh
terraform init
```

## Formatting and validating file

```sh
# format the file
terraform fmt

# check for errors of syntax and etc.
terraform validate
```

## Planning and provisioning resources

```sh
# visualize the Terraform plan before to applying
terraform plan

# provision resources on cloud provider
terraform apply
```

## Accessing application

In EC2 page, click on EC2 instance created by Terraform, search by `Public IPV4 address` and click on it, to access the application.

> The app url must be access without https, because is not fully configured.

## Accessing EC2 instance via SSH

```sh
ssh -i \
    ~/.ssh/id_rsa \ # private ssh key path
    ec2-user@<public-ip-instance>
```

## Destroying infrastructure provisioned

```sh
terraform destroy
```

## Next Steps with Terraform

- [ ] Store the Terraform state in a private AWS S3 Bucket (automatically)
- [ ] Create a specficic user to IAC (Terraform) and used it to provision infra
- [ ] Provision ECR private repository to store all app images instead store on Docker Hub

## Links references

- [AWS Documentation](https://docs.aws.amazon.com)
- [Amazon Corretto Images](https://hub.docker.com/_/amazoncorretto)
- [Terraform Registry Documentation](https://registry.terraform.io/browse/providers)

## License

This project is under [MIT License](./LICENSE).
