# -----------------------------------------------------------------------------
# SCRIPT CONFIGURATION
# -----------------------------------------------------------------------------

# Default Makefile configuration filename
CONFIG_FILE := Makefile.conf


# Explicitly check for the config file, otherwise make -k will proceed anyway.
ifeq ($(wildcard $(CONFIG_FILE)),)
	$(error $(CONFIG_FILE) not found. See $(CONFIG_FILE).example)
endif

include $(CONFIG_FILE)

# -----------------------------------------------------------------------------
# VARIABLES DEFINITION
# -----------------------------------------------------------------------------

# Default background color definition
ccback=\033[49m

# Foreground colors definition
ccred=\033[0;31m$(ccback)
ccgreen=\033[38;5;112m$(ccback)
ccblue=\033[38;5;33m$(ccback)
ccyellow=\033[0;33m$(ccback)
ccorange=\033[38;5;166m$(ccback)
ccwhite=\033[97m$(ccback)
ccpink=\033[35;40m$(ccback)
ccend=\033[0m

# List of project's components
#
# This variable is used as a target, so that to ease the building of a
# component using make, as shown below, to build the doddy Console, for
# instance:
#
# $ make doddy_console
#
# Imagine you wanna create a new component called 'mycomponent'. You
# should create a folder called 'doddy_mycomponent' at the root of the
# project, and add a 'doddy_mycomponent' target in the component's BUILD.bazel
# file. 
COMPONENTS := $(shell find ./cmd/* -maxdepth 0)
#TEST_COMPONENTS := $(shell find ./doddy_* -maxdepth 0 | xarg test_@?) 

# Build version
BUILD         ?= $(shell git rev-parse --short HEAD)
BUILD_DATE    ?= $(shell git log -1 --format=%ci)
BUILD_BRANCH  ?= $(shell git rev-parse --abbrev-ref HEAD)
BUILD_VERSION ?= $(shell git describe --always --tags)

# Tool configuration files and settings
TOOLING_PATH := ./tools

# Minikube virtual machine name (run on Xhyve on MacOS)
MINIKUBE_VM_NAME := $(PROJECT_NAME)


# -----------------------------------------------------------------------------
# FUNCTIONS DEFINITION
# -----------------------------------------------------------------------------

# Clean up project's binaries and intermediate files
define clean_project
	@rm -rf bazel-* || true
endef

# Visualize project's dependency graph
define visualize_project_dependency_graph
	@bazel query 'deps(//:main)' --output graph > graph.in
	@dot -Tpng < graph.in > graph.png
endef

# Update Golang modules repositories
#
# This command is run each time a new module is added, removed, or modified
# in the require section of the 'go.mod' file.
# In the future, a checksum on 'go.mod' could make the trick and automate
# this process.
define update_golang_repositories
	@gazelle update-repos -from_file=./go.mod -to_macro=./bazel/private/repositories.bzl%proxy_dependencies
endef
# @gazelle update-repos -from_file=./go.mod -build_file_proto_mode=disable_global -to_macro=./bazel/private/repositories.bzl%proxy_dependencies


# -----------------------------------------------------------------------------
# PRIVATE FUNCTIONS
# -----------------------------------------------------------------------------

# Purge dangling Docker images and containers
#
# When designing a Docker image, it is frequent that this process
# crashes, producing intermediate (hence dangling) file system layers.
# This function helps cleaning such 'junks'.
define _purge_docker_dangling_images
	@docker image prune -a
endef

# -----------------------------------------------------------------------------
# TARGETS DEFINITION
# -----------------------------------------------------------------------------

# NOTE:
# .PHONY directive defines targets that are not associated with files. Generally
# all targets which do not produce an output file with the same name as the target
# name should be .PHONY. This typically includes 'all', 'help', 'build', 'clean',
# and so on.

.PHONY: clean purge_docker update_repos

# Get rid of binaries and intermediate files
clean: 
	@echo "$(ccgreen)[INFO]$(ccend) Cleaning project ..."
	$(call clean_project)

# Update Golang repositories (should be run each time 'go.mod' is modified)
update_repos:
	@echo "$(ccgreen)[INFO]$(ccend) Update Golang repositories ..."
	$(call update_golang_repositories)

purge_docker: 
	@echo "$(ccred)[WARN]$(ccend) Purge Docker dangling and unused images ..."
	$(call _purge_docker_dangling_images)
