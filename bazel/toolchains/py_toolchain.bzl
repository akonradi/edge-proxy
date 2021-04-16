load("@rules_python//python:defs.bzl", "py_runtime", "py_runtime_pair")

def py_runtimes():
    py_runtime(
        name = "py2_runtime",
        interpreter_path = "/usr/bin/python2",
        python_version = "PY2",
    )

    py_runtime(
        name = "py3_runtime",
        interpreter_path = "/usr/bin/python3",
        python_version = "PY3",
    )

    py_runtime_pair(
        name = "py_runtime_pair",
        py2_runtime = ":py2_runtime",
        py3_runtime = ":py3_runtime",
    )

def py_toolchain():
    native.toolchain(
        name = "py_toolchain",
        target_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        toolchain = ":py_runtime_pair",
        toolchain_type = "@rules_python//python:toolchain_type",
    )

def py_register_toolchains():
    native.register_toolchains("//:py_toolchain")