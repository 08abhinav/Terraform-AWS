variable "instance_type"{
  description = "specifying the ram, cpu"
  default = "t2.micro"
}

variable "keyPair"{
  description = "key pair for ssh to remote server"
  default = "shell-practice"
}

variable "bucket_name"{
  description = "Bucket name"
  default = ""
}