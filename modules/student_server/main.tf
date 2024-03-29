resource "hcloud_ssh_key" "ssh_keys" {
  count      = length(var.ssh_keys)
  name       = "SSH Key ${count.index} of ${var.student_name}"
  public_key = var.ssh_keys[count.index]
}

resource "hcloud_server" "server" {
  name        = "server-of-${var.student_name}"
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = resource.hcloud_ssh_key.ssh_keys[*].id
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "gandi_livedns_record" "a_record" {
  name = "server-of-${var.student_name}.pxl"
  ttl = 10800
  type = "A"
  values = [ resource.hcloud_server.server.ipv4_address ]
  zone = "bjth.xyz"
}

resource "gandi_livedns_record" "aaaa_record" {
  name = "server-of-${var.student_name}.pxl"
  ttl = 10800
  type = "AAAA"
  values = [ resource.hcloud_server.server.ipv6_address ]
  zone = "bjth.xyz"
}
