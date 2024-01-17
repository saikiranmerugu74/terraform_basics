variable "aws_vpc" {
  description = "Value of the Name tag for the VPC"
  type        = string
  default     = "VPC1"
}

variable "aws_subnet" {
  description = "Value of the Name tag for the subnet"
  type        = string
  default     = "subnet1"
}

variable "aws_instance" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}


