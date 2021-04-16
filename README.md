# edge-proxy

This repository contains a reference implementation of [Envoy's Exth Authz server](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/security/ext_authz_filter#arch-overview-ext-authz) and a set of utilities that you can (and should!) use when building your own ext authz servers.

## WARNINGS

There are currently a couple of issues on this repo which are being worked on...

issue 1 - bazel gazelle breaking the WORKSPACE (see [Issue 1](#issue-1))
issue 2 - building go_binary will result in multiple copies of package passed to linker (see [debug.log](debug.log))

### Issue 1

When running `make update_repos`, this will update the go modules, however, it will also produce a 4-line entry on the WORKSPACE that **MUST** be removed before continuing to run bazel commands. The lines to remove are these and are inserted on lines 136-139:

```bazel
load("//:./bazel/private/repositories.bzl", "proxy_dependencies")

# gazelle:repository_macro ./bazel/private/repositories.bzl%proxy_dependencies
proxy_dependencies()
```

I have not yet been able to figure out why this is happening, but the solution is known.

---

## Requirements

- [Go](https://golang.org/) (v1.16.x)
- [Bazel](https://www.bazel.build/) (v3.7.2)
- [Docker & Docker-Compose](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/download)

---

## Devcontainer

This repo contains a [Devcontainer](https://code.visualstudio.com/docs/remote/containers) (particularly suited to Visual Studio Code Remote Development Plugin) which is a container ready to write Go code (including code-completions) and all the tools and plugins required to work with Go.

Additionally, the Devcontainer is linked to your host Docker daemon, meaning you can run and interact with additional containers on your system.
The Devcontainer configuration can be modified to include additional Docker containers or additional docker-compose files that must start with the Devcontainer.

Start by creating a `devcontainer.json` file inside your local `.devcontainer` directory. You can use the [`devcontainer.json.sample`](.devcontainer/devcontainer.json.sample) file to get started.

---

## Makefile

This repo includes a Makefile which includes all the targets required for both Development as well as building and releasing the Edge Proxy.

**You SHOULD use `make` to perform most of the tasks required**
