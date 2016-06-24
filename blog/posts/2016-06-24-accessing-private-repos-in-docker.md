---
title:  Cloning private repositories inside docker
---

**tldr;** The unix socket created by the `ssh-agent` can be mounted in
  the docker container. This gives the user access to the keys on the
  host, making it possible to clone private repositories (that rely on
  ssh keys to grant access) inside the container.

## Problem

Docker is a linux container technology which makes it really easy to
package and deploy code. Just like with other container
technologies, you can use it to package the environment / execution
context along with the code i.e:

**code + execution context = artifact**

For example, if your project requires python 2.7, then you
should package python 2.7 along with the code that you ship instead of
relying on the host to provide those packages for you. This way you
can ensure that no matter where the code runs; during development on
the local machine, testing on travis, running in production etc, it
will always run consistently or break in the same way. The same goes
for configurations required for the code. However, we shouldn't always
package everything within the artifact e.g. secrets and keys should
stay out of the artifact. This limitation comes with its own set of
challenges..

Recently I was working on a **project that depended on some private
repositories and I couldn't clone inside the docker container since I
had no access to the keys that were present on the host machine**. I
solved this by sharing my `ssh-agent` session with the docker
container.

## SSH Agent

`ssh-agent` is a utility that keep manages the private keys for the
user when using `ssh`. It comes with the `openssh-client` package.

If the `ssh-agent` is already running, you can find the environment
variable related to `ssh` as follows:

```
$ printenv | grep SSH
SSH_AGENT_PID=3010
SSH_AUTH_SOCK=/tmp/ssh-5ymZpLJEA5Kq/agent.2946
SSH_ASKPASS=/usr/bin/ssh-askpass
```

The `SSH_AUTH_SOCK` variable tells us that the agent is using a unix
socket created in the `/tmp/ssh-*/` directory. Anyone having access to
that socket can use the keys that are being held by the agent.

## Using the ssh-agent session inside the container

You can run the `ssh-agent` inside the docker container but that would
create a new session and will use another socket. Since unix sockets
can be mapped as files, the container can be configured to reuse the
agent running on the host machine, hence, getting access to the keys
on the host machine.

Here is how a sample `docker-composer.json` file can be setup:

```
app:
  image: debian:jessie
  volumes:
    - $SSH_AUTH_SOCK:/ssh-agent
  environment:
    SSH_AUTH_SOCK: /ssh-agent
```

In order to verify that you can use your keys from the container,
follow these steps:

```
 $ docker-compose run app
 root@xxxx :/# apt-get update
 root@xxxx :/# apt-get install openssh-client
 root@xxxx :/# ssh your-server-with-public-key.com # You're in !!
```

## Testing the Setup

I usually test my setup by trying to access `github.com` (since that's
one service I am sure of which has my public key setup properly):

```
 root@xxxx :/# ssh -T git@github.com
 [omitted for brevity]
 Hi ahmadnazir! You've successfully authenticated, but GitHub does not provide shell access.
```
