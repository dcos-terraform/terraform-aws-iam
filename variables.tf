variable "cluster_name" {
  description = "Name of the DC/OS cluster"
}

variable "aws_s3_bucket" {
  description = "S3 Bucket for External Exhibitor"
  default     = ""
}
