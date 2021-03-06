log_level = "WARN"
enable_debug = false
datacenter = "testing"
data_dir = "/tmp/nomad"

name = "nomad-devagent"

bind_addr = "0.0.0.0"

client {
  enabled = true
  servers = ["{{host_ip_address}}:4647"]
  options = {
    "driver.raw_exec.enable" = "1"
  }
}

server {
  enabled          = true
  bootstrap_expect = 1
  num_schedulers   = 1
}

consul {
  address = "{{host_ip_address}}:8500"
}
