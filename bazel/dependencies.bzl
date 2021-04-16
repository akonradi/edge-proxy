load(
    "//bazel/private:repositories.bzl",
    _dependencies = "proxy_dependencies",
)
load(
    "//bazel/toolchains:py_toolchain.bzl",
    _py_runtimes = "py_runtimes",
    _py_toolchain = "py_toolchain",
    _py_register_toolchains = "py_register_toolchains",
)

proxy_dependencies = _dependencies

py_runtimes = _py_runtimes
py_toolchain = _py_toolchain
py_register_toolchains = _py_register_toolchains
