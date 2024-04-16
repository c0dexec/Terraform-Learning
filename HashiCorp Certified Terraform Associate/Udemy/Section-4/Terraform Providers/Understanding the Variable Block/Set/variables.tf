variable "prefix" {
    default = ["Mr", "Mrs", "Sir"]
    type = set(string)  
}

variable "fruit" {
  default = ["apple", "orange"]
    type = set(string) 
}

variable "age" {
  default = [15, 16, 17]
  type = set(number)
}

# Sets cannot have duplicate values.