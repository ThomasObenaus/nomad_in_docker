# Nomad in Docker

This repo contains code to generate a docker image that contains a running [hashicorp/nomad](https://github.com/hashicorp/nomad) and a running [hashicorp/consul](https://github.com/hashicorp/consul).

**Attention!!:** Since nomad needs docker support we have a docker container within which docker runs. Thats why the containers **have to run in privileged mode**.

## Why

If you need nomad/ consul for integration tests of your application (like [sokar](https://github.com/ThomasObenaus/sokar) does) you can easily spin it up in the right version and run your test.
Furthermore it can be used for local testing/ playing around with different nomad/ consul versions.

## Pull and Run

```bash
# pull image (nomad 0.9.1 + consul 1.5.0)
docker pull thobe/nomad:0.9.1

# run image (nomad 0.9.1 + consul 1.5.0)
docker run --privileged -it -p 8500:8500 -p 4646:4646 thobe/nomad:0.9.1
```

## Build and Run

For some nomad/ consul version combinations there are already make targets defined and those versions can be pulled directly from docker hub as well.

```bash
# build (nomad 0.9.1 + consul 1.5.0)
make build.0.9.1
# run (nomad 0.9.1 + consul 1.5.0)
make run.0.9.1
```

Build and Run a Custom Version

```bash
##### BUILD ###################
# generic
# docker build -t nomad_in_docker -f Dockerfile --build-arg NOMAD_VERSION=<version of nomad> --build-arg CONSUL_VERSION=<version of consul> .
# e.g.
docker build -t nomad_in_docker -f Dockerfile --build-arg NOMAD_VERSION=0.11.1 --build-arg CONSUL_VERSION=1.7.3 .

##### RUN ###################
docker run --privileged -it -p 8500:8500 -p 4646:4646 nomad_in_docker:latest
```

## Nomad and Consul

The default nomad and consul ports are open in order to support interaction with the nomad and consul agents and their UI.
To open the UI go to:

- nomad: http://localhost:4646
- consul: http://localhost:8500
