# Nomad Jobs

## Fabio

With `nomad run fabio.nomad` the [fabio loadbalancer](https://fabiolb.net/) will be deployed to nomad.

The deployed fabio will be reachable at http://localhost:9999 and its UI at http://localhost:9998. Hence the **according ports have to be mapped in the docker-call to start the nomad in docker**.

`docker run --privileged -it -p 8500:8500 -p 4646:4646 -p 9999:9999 -p 9998:9998 thobe/nomad:0.11.2`

### Prerequisites

Beforehand the job file has to be adjusted. The `{{host_ip}}` has to be replaced with the ip of the host.the nomad in docker is running on.
One can determine the host ip by running `ifconfig`

Example:

```bash
ifconfig

# output
wlp3s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.45.118  netmask 255.255.255.0  broadcast 192.168.45.255
        inet6 fe80::f96c:cbd0:edf9:dcd0  prefixlen 64  scopeid 0x20<link>
        ether 0c:8b:fd:01:4f:46  txqueuelen 1000  (Ethernet)
        RX packets 232661  bytes 305711003 (305.7 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 63876  bytes 6900393 (6.9 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

So here the host ip is `192.168.45.118`. Hence the adjusted part in the file `fabio.nomad` will look like this

```yaml
[...]
template {
data = <<EOH
registry.consul.addr = 192.168.45.118:8500
EOH
destination = "local/fabio.properties"
change_mode = "noop"
}
[...]
```

## Docker Registry

With `nomad run creg.nomad` a [local docker registry](https://hub.docker.com/_/registry/) will be deployed to nomad.

The deployed registry will be reachable at http://localhost:5000. Hence the **according ports have to be mapped in the docker-call to start the nomad in docker**.

`docker run --privileged -it -p 8500:8500 -p 4646:4646 -p 5000:5000 thobe/nomad:0.11.2`

### Setup

#### Linux

1. Configuration have to be done at: `/etc/docker/daemon.json`:

   ```json
   {
     "insecure-registries": ["localhost:5000"]
   }
   ```

1. Restart the docker daemon.

#### MacOS

Using the "Docker Desktop" just check out the "Preferences/Daemon" section and
add the local Docker registry `localhost:5000` at "Insecure registries".

### Usage

#### Pushing to Docker Registry

```bash
docker build -t samplejob .
docker tag samplejob:latest localhost:5000/samplejob:latest
docker push localhost:5000/samplejob:latest
```

##### Using with nomad

```hcl
job "samplejob" {
  datacenters = [ "testing" ]
  ...

  group "server" {
    count = 1

    task "registry" {
      driver = "docker"

      config {
        image = "localhost:5000/samplejob:latest"
        ...
      }
    }
  }
}
```
