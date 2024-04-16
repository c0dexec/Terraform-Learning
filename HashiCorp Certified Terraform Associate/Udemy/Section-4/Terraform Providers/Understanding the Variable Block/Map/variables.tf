variable "file-content" {
  type = map() # As string type values are being used one can also write map(string)
  default = {
    "statement1" = "We love pets!"
    "statement2" = "We love animals!"
  }
}