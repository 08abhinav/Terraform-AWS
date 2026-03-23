variable "instance_type"{
  description = "specifying the ram, cpu"
}

variable "keyPair"{
  description = "key pair for ssh to remote server"
}

variable "backend_bucket"{
  descirption = "separate bucket to store the statefile"
}