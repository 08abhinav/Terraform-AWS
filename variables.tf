variable "cidr_block" {
  description = "cidr block for vpc"
  default = "10.0.0.0/16"
}

variable "subnet_cidr"{
  description = "cidr block for subnet1 inside myvpc"
  default = "10.0.0.0/24"
}

variable "subnet_cidr2"{
  description = "cidr block for subnet1 inside myvpc"
  default = "10.0.1.0/24"
}

variable "az"{
  description = "availability zone for subnet1"
  default = "us-east-1a"
}

variable "az2"{
  description = "avaialbility zone for subnet2"
  default = "us-east-1b"
}

variable "ami_id"{
  description = "amazon machine image"
  default = "ami-0bdd88bd06d16ba03"
}

variable "instance_type"{
  description = "specifying the ram, cpu"
  default = "t2.micro"
}
