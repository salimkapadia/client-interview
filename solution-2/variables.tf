variable "repository_name" {
  default     = "REALLY-COOLO-S3-BUCKET-NAME"
  description = "This will be the name that is prefixed with the workspace in question"
  type        = string
}

variable "region" {
  default     = "us-east-1"
  description = "The region in which to associate resources too"
  type        = string
}


variable "tags" {
  default     = {}
  description = "The tags to apply to all resources"
  type        = map(string)
}
