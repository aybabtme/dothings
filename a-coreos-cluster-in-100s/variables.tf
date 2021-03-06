variable "region"         { default = "tor1" }
variable "leader_size"    { default = "2gb" }
variable "leader_count"   { default = 5 }
variable "follower_size"  { default = "16gb" }
variable "follower_count" { default = 10 }

# user provided

variable "ssh_keys" {
    description = <<EOF
Run this command to discover your SSH key IDs:

    doit sshkey list

See: https://github.com/bryanl/doit
EOF
}

variable "discovery_url" {
    description = <<EOF
Run this command to get a discovery URL

    curl -w "\n" 'https://discovery.etcd.io/new?size=${var.leader_size}'

EOF
}
