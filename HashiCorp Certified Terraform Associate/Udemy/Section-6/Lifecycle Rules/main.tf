resource "local_file" "pet" {
  filename = "./dog.txt"
  content = "Mah dog."
  file_permission = "0740" #Changed from "0700" caused recreation of file. Because a change has occured in the resource.

  lifecycle { # Added lifecycle rule to ensure that file creation occurs before destruction takes place.
    create_before_destroy = true # When ever the "content" field is updated a new file gets created in location of "filename", then subsequently the file gets deleted right after, causing no file to exist at all.
    ignore_changes = [ content,filename ] # Doens't recreate the resoruce if changes to "content" or "filename" are made.
    prevent_destroy = true # Prevents resource to be destroyed.
  }
}