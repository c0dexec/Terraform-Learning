variable "filename-set" {
  type = set(string) # Is string because either set of string or map is supported by "for_each"
  default = [
    "./catto.txt",
    "./diggididAWGS.txt"
  ]
}

variable "filename-list" {
  default = [
    "./Cheeku.txt", # if removed refer to tablen in notes for Meta-Arguments.
    "./cheeks.txt"
  ]
}