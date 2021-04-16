workspace(name = "edge-proxy")

# -----------------------------------------------------------------------------
# Global variables
# -----------------------------------------------------------------------------

# Requisite minimal Golang toolchain version
MINIMAL_GOLANG_VERSION = "1.16.3"

# Requisite minimal Bazel version requested to build this project
MINIMAL_BAZEL_VERSION = "3.7.2"

# Requisite minimal Gazelle version compatible with Golang Bazel rules
MINIMAL_GAZELLE_VERSION = "0.23.0"

# Requisite minimal Golang Bazel rules (must be set in accordance with minimal Gazelle version)
#
# @see https://github.com/bazelbuild/bazel-gazelle#compatibility)
MINIMAL_GOLANG_BAZEL_RULES_VERSION = "0.27.0"

MINIMAL_GOLANG_BAZEL_RULES_SHASUM = "69de5c704a05ff37862f7e0f5534d4f479418afc21806c887db544a316f3cb6b"

# -----------------------------------------------------------------------------
# Basic Bazel settings
# -----------------------------------------------------------------------------

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Import Bazel Skylib repository into the workspace
http_archive(
    name = "bazel_skylib",
    sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
    ],
)

load("@bazel_skylib//lib:versions.bzl", "versions")

versions.check(
    minimum_bazel_version = MINIMAL_BAZEL_VERSION,
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

# -----------------------------------------------------------------------------
# Python Toolchain (for Devcontainer)
# -----------------------------------------------------------------------------
http_archive(
    name = "rules_python",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.2.0/rules_python-0.2.0.tar.gz",
)

# -----------------------------------------------------------------------------
# Golang and gRPC tools and external dependencies
# -----------------------------------------------------------------------------

# Fetch Protobuf dependencies
http_archive(
    name = "rules_proto",
    strip_prefix = "rules_proto-6103a187ba73feab10b5c44b52fa093675807d34",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/6103a187ba73feab10b5c44b52fa093675807d34.tar.gz",
        "https://github.com/bazelbuild/rules_proto/archive/6103a187ba73feab10b5c44b52fa093675807d34.tar.gz",
    ],
)

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

# Fetch gRPC and Protobuf dependencies (should be fetched before Go rules)
http_archive(
    name = "build_stack_rules_proto",
    sha256 = "d456a22a6a8d577499440e8408fc64396486291b570963f7b157f775be11823e",
    strip_prefix = "rules_proto-b2913e6340bcbffb46793045ecac928dcf1b34a5",
    urls = ["https://github.com/stackb/rules_proto/archive/b2913e6340bcbffb46793045ecac928dcf1b34a5.tar.gz"],
)

load("@build_stack_rules_proto//go:deps.bzl", "go_proto_library")

go_proto_library(compilers = ["@io_bazel_rules_go//proto:go_grpc"])

go_proto_library()

# Import Golang Bazel repository into the workspace
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "69de5c704a05ff37862f7e0f5534d4f479418afc21806c887db544a316f3cb6b",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
    ],
)

# Fetch Golang dependencies.
#
# The 'go_rules_dependencies()' is a macro that registers external dependencies needed by
# the Go and proto rules in rules_go.
# You can override a dependency declared in go_rules_dependencies by declaring a repository
# rule in WORKSPACE with the same name BEFORE the call to 'go_rules_dependencies()' macro.
#
# You can find the full implementation in repositories.bzl availble at https://github.com/bazelbuild/rules_go/blob/master/go/private/repositories.bzl.
#
# @see: https://github.com/bazelbuild/rules_go/blob/master/go/workspace.rst#id5
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

# NOTE:
# To override dependencies declared in 'go_rules_dependencies' macro, you should
# declare your dependencies here, before invoking 'go_rules_dependencies' macro.

# Fetch external dependencies needed by the Go and proto rules in rules_go, as
# well as some basic Golang packages, such as, for instance, 'golang.org/x/text'
# i18n tool.
go_rules_dependencies()

go_register_toolchains(version = "1.16")

#  go_version = MINIMAL_GOLANG_VERSION,
#)

# -----------------------------------------------------------------------------
# Bazel Gazelle build files generator settings
# -----------------------------------------------------------------------------

# Import Gazelle repository into the workspace
http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)

# Fetch Gazelle dependencies
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

# -----------------------------------------------------------------------------
# Docker Bazel rules dependencies
# -----------------------------------------------------------------------------

# Import the rules_docker repository - be sure the Go rules
# are previously loaded - see above Go rules section in this file
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "95d39fd84ff4474babaf190450ee034d958202043e366b9fc38f438c9e6c3334",
    strip_prefix = "rules_docker-0.16.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.16.0/rules_docker-v0.16.0.tar.gz"],
)

# Load the macro that allows you to customize the docker toolchain configuration.
load(
    "@io_bazel_rules_docker//toolchains/docker:toolchain.bzl",
    docker_toolchain_configure = "toolchain_configure",
)

docker_toolchain_configure(
    name = "docker_config",
    # Replace this with a path to a directory which has a custom docker client
    # config.json. Docker allows you to specify custom authentication credentials
    # in the client configuration JSON file.
    # See https://docs.docker.com/engine/reference/commandline/cli/#configuration-files
    # for more details.
    #
    # IMPORTANT: This path is relative to the sandbox workspace directory
    client_config = "/workspace/tools/docker",
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

# load("@io_bazel_rules_docker//repositories:pip_repositories.bzl", "pip_deps")

# pip_deps()

load(
    "@io_bazel_rules_docker//go:image.bzl",
    _go_image_repos = "repositories",
)

_go_image_repos()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

container_pull(
    name = "go_base_debian10",
    # 'tag' is also supported, but digest is encouraged for reproducibility.
    digest = "sha256:75f63d4edd703030d4312dc7528a349ca34d48bec7bd754652b2d47e5a0b7873",
    registry = "gcr.io",
    repository = "distroless/base-debian10",
)

# # This call should always be present.
# load("@rules_python//python:repositories.bzl", "py_repositories")

# py_repositories()

# -----------------------------------------------------------------------------
# Register the Python toolchains
# -----------------------------------------------------------------------------
# load("//bazel:dependencies.bzl", "proxy_dependencies", "py_register_toolchains")
load("//bazel:dependencies.bzl", "proxy_dependencies")

# py_register_toolchains()

# -----------------------------------------------------------------------------
# Proxy external dependencies
# -----------------------------------------------------------------------------

proxy_dependencies()
