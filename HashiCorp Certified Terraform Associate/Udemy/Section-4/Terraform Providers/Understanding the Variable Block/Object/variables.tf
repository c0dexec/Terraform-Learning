variable "bella" {
  type = object({
    name = string
    color = string
    age = number
    food = list(string)
    favorite_pet = bool
  })
  default = {
    name = "Bella"
    color = "Brown"
    age = 1
    food = [ "Fish", "Potato", "Smackos" ]
    favorite_pet = false
  }
}