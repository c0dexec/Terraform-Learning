variable "prefix" {
  default = ["Mr", "Mrs", "Sir"] # Index value for "Mr" is 0, "Mrs" is 1, "Sir" is 3
  type = list() # Can also be written as list(string) if we intend to only use strings.
}