## **Terraform AWS Infrastructure Project**

### **Overview**

This project demonstrates a complete AWS infrastructure setup using **Terraform** — Infrastructure as Code (IaC).
The setup provisions a **virtual private cloud (VPC)** environment with subnets, internet connectivity, compute instances, storage, and load balancing — all automatically managed by Terraform.

The main goal is to automate the provisioning of a simple web application infrastructure on AWS.

---

## **Architecture Components**

### **1. Virtual Private Cloud (VPC)**

* A custom **VPC** is created to logically isolate our infrastructure within AWS.
* It defines the private IP address range using a CIDR block (e.g., `10.0.0.0/16`).
* All subnets, route tables, and security groups are created inside this VPC.

---

### **2. Subnets**

* Two **public subnets** are created:

  * **Subnet 1** (`mysubnet1`) — in **Availability Zone 1**
  * **Subnet 2** (`mysubnet2`) — in **Availability Zone 2**
* Each subnet is configured with:

  ```hcl
  map_public_ip_on_launch = true
  ```

  This ensures every EC2 instance launched within gets a **public IP address** automatically.

---

### **3. Internet Gateway & Route Table**

* An **Internet Gateway (IGW)** is attached to the VPC to allow internet access.
* A **Route Table** is created and associated with both subnets.
* The route configuration allows all outbound traffic to the Internet via the IGW:

  ```hcl
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  ```
* This setup makes both subnets **publicly accessible**.

---

### **4. S3 Bucket**

* A **S3 bucket** is provisioned for object storage.
* It can be used for:

  * Storing Terraform state files (optional, if remote backend configured)
  * Storing web assets, logs, or any static content.

Example:

```hcl
resource "aws_s3_bucket" "mybucket" {
  bucket = "terraform-aws-demo-bucket"
  acl    = "private"

  tags = {
    Name = "TerraformBucket"
  }
}
```

---

### **5. EC2 Instances**

* Two **EC2 instances** (`webserver1` and `webserver2`) are launched, each in a different subnet.
* Both use **user data scripts** to automatically install Apache and host a custom HTML web page.

**Instance 1** → Displays:

> “Welcome to My First Terraform Project”

**Instance 2** → Displays:

> “Deployed with Terraform — Infrastructure as Code demo”

Each instance is tagged appropriately and accessible via its **public IP address**.

---

### **6. Load Balancer**

* An **Application Load Balancer (ALB)** is created to distribute incoming HTTP traffic across both instances.
* It improves availability and fault tolerance.
* The ALB listens on port 80 and routes traffic to the target group containing both EC2 instances.

Example structure:

```hcl
resource "aws_lb" "myalb" {
  name               = "terraform-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mysg.id]
  subnets            = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
}
```

---

## **Security Group**

A single **security group** (`web-sg`) is used to control inbound and outbound traffic:

* **Inbound**:

  * Port 80 (HTTP) → accessible to everyone (`0.0.0.0/0`)
  * Port 22 (SSH) → accessible to everyone (for management)
* **Outbound**:

  * All traffic allowed to the internet.

This makes it easy to test and view your deployed web pages through the browser.

---

## **How to Deploy**

### **1. Initialize Terraform**

```bash
terraform init
```

### **2. Validate Configuration**

```bash
terraform validate
```

### **3. Preview Infrastructure Changes**

```bash
terraform plan
```

### **4. Deploy Infrastructure**

```bash
terraform apply
```

Type `yes` when prompted.

---

## **Accessing the Web Application**

Once Terraform completes:

* Go to your **AWS EC2 Console**
* Copy the **Public IPv4 address** of either instance (or use the Load Balancer DNS name)
* Paste it into your browser:

  ```
  http://<instance-public-ip>
  ```

You’ll see your HTML page served by Apache automatically.

---

## **Cleanup (Destroy Resources)**

To avoid AWS charges, destroy all resources when done:

```bash
terraform destroy
```

Type `yes` to confirm.

---

## **Tools & Technologies Used**

* **Terraform** → Infrastructure as Code tool
* **AWS EC2** → Virtual servers for running the web apps
* **AWS VPC** → Isolated networking environment
* **AWS S3** → Object storage
* **AWS ALB** → Load balancing between EC2 instances
* **Bash** → EC2 user-data initialization scripts
