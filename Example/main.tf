resource "local_file" "network" {
  filename = "./test.yml"
  content = yamlencode({
    version = 1
    config = [{
      type = "physical"
      name = "eth0"
      mac_address = "00:60:2f:f4:fa:a4"
      subnets = [{
        type            = "static"
        address         = "11.1.0.10/24"
        gateway         = "11.1.0.1"
        dns_nameservers = ["1.1.1.1", "8.8.8.8"]
      }]
    }]
  })
}

output "network" {
  value = local_file.network.content
}