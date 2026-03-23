# Terraform AWS Infrastructure Project

This project demonstrates a complete AWS infrastructure setup using **Terraform** (Infrastructure as Code).

The infrastructure provisions a basic web application environment on AWS that includes networking, compute, storage, and load balancing components.

The main objective is to automate infrastructure provisioning instead of manually creating resources from the AWS console.

In this project, Terraform modules are used to organize resources for better readability and maintainability.

---

# Architecture Components

## 1. Network Module
A separate network module is created to manage all networking-related resources.
The network module contains:
- VPC
- Subnets
- Internet Gateway
- Route Table
- Route Table Associations

---

## 2. Iam Module
A separate iam module is created to manage iam roles and policy attachment.
The iam moudle contains:
- Role creation
- Policy attachement
- Profile creation

---

## 3. s3 Module
A separate s3 module is created to manage s3 Bucket.
The s3 moudle contains:
- Bucket creation
- Bucket ownership control
- Bucket public access block

---

## 4. alb Module
A separate alb module is created to manage application load balaner.
The alb moudle contains:
- Application load balancer creation
- Target group creation

---

## 5. EC2 Instances
Two EC2 instances are launched:

- webserver1
- webserver2

Each instance is deployed in a different subnet.

Both instances use user data scripts to automatically:
- Install Apache
- Start the web server
- Serve a custom HTML page

---

## Checkout: [Medium](https://medium.com/@abhinavnegi101/provisioning-aws-infrastructure-using-terraform-part2-90b011b68e5b)

# How to Deploy

## 1. Initialize Terraform

```bash
terraform init
```

## 2. Validate Configuration

```bash
terraform validate
```

## 3. Preview Infrastructure Changes

```bash
terraform plan
```

## 4. Deploy Infrastructure

```bash
terraform apply
```

Type:

```bash
yes
```

when prompted.

---

# Accessing the Web Application

After successful deployment:

- Copy loadbalancer.dns output from your terminal
- Paste in browser:

```bash
http://<load-balancer-dns>
```

The Apache-hosted web page will load automatically.

---

# Cleanup (Destroy Resources)

To avoid AWS charges:

```bash
terraform destroy
```

Type:

```bash
yes
```

to confirm.

---

# Tools & Technologies Used

- Terraform
- AWS EC2
- AWS VPC
- AWS S3
- AWS ALB
- Bash