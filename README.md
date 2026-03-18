# Terraform AWS Infrastructure Project

This project demonstrates a complete AWS infrastructure setup using **Terraform** (Infrastructure as Code).

The infrastructure provisions a basic web application environment on AWS that includes networking, compute, storage, and load balancing components.

The main objective is to automate infrastructure provisioning instead of manually creating resources from the AWS console.

In this project, Terraform modules are used to organize resources for better readability and maintainability.

---

# Architecture Components

## 1. Network Module

A separate **network module** is created to manage all networking-related resources.  
This improves project structure and makes the Terraform code easier to understand and reuse.

The network module contains:

- VPC
- Subnets
- Internet Gateway
- Route Table
- Route Table Associations

---

## 2. Virtual Private Cloud (VPC)

- A custom **VPC** is created to logically isolate infrastructure inside AWS.
- It defines the private IP address range using a CIDR block:

```hcl
10.0.0.0/16
```

---

## 3. Subnets

Two **public subnets** are created in different availability zones:

- **Subnet 1 (`mysubnet1`)** → Availability Zone 1  
- **Subnet 2 (`mysubnet2`)** → Availability Zone 2  

Each subnet uses:

```hcl
map_public_ip_on_launch = true
```

This ensures that every EC2 instance launched inside the subnet automatically receives a public IP address.

---

## 4. Internet Gateway and Route Table

- An **Internet Gateway (IGW)** is attached to the VPC to provide internet connectivity.
- A **Route Table** is created and associated with both public subnets.

The route configuration allows internet access:

```hcl
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
```

This makes both subnets publicly accessible.

---

## 5. S3 Bucket

A **S3 bucket** is provisioned for object storage.

It is used for:

- Storing Terraform remote state files
- Keeping infrastructure state centrally managed
- Preventing local state dependency

Example:

```hcl
resource "aws_s3_bucket" "mybucket" {
  bucket = "terraform-aws-demo-bucket"

  tags = {
    Name = "TerraformBucket"
  }
}
```

Terraform backend is configured so the state file is stored remotely inside the S3 bucket.

---

## 6. EC2 Instances

Two **EC2 instances** are launched:

- **webserver1**
- **webserver2**

Each instance is deployed in a different subnet.

Both instances use **user data scripts** to automatically:

- Install Apache
- Start the web server
- Serve a custom HTML page

---

## 7. Security Group

A single security group (`web-sg`) controls traffic for both EC2 instances and the load balancer.

### Inbound Rules

- Port 80 (HTTP) → open to everyone

```hcl
0.0.0.0/0
```

- Port 22 (SSH) → open for remote access

### Outbound Rules

- All outbound traffic allowed

This allows browser access and SSH management.

---

## 8. Load Balancer

An **Application Load Balancer (ALB)** is created to distribute traffic across both EC2 instances.

It provides:

- Better availability
- Fault tolerance
- Traffic distribution

The ALB listens on port 80 and forwards traffic to both EC2 instances through a target group.

---

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