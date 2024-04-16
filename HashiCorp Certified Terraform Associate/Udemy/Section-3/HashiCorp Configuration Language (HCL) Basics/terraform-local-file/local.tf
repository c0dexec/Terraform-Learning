resource "local_file" "pet" {
    filename = "./pets.txt"
    content = "Cheeku is my doggo."
}
