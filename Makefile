export HUGO_VERSION?=0.85.0
export HUGO_PLATFORM?=Linux-64bit
export COS_REPO?=https://github.com/rancher-sandbox/cOS-toolkit

export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := build

.PHONY: build
build:
	scripts/build.sh

.PHONY: serve
serve:
	scripts/serve.sh

.PHONY: publish
publish:
	scripts/publish.sh

cos:
	git clone $(COS_REPO) cos

generate-docs: cos
	scripts/generate_packages_docs.sh cos/packages
