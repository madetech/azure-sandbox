variable "region" {
  type        = string
  description = "The region to create the functions apps in"
}

variable "are_functions_deployed" {
  type        = string
  description = "0 if the function apps haven't been deployed, 1 if they are"
}
