---
title: "Creating bootable images"
linkTitle: "Creating bootable images"
weight: 1
date: 2017-01-05
description: >
  This document describes the requirements to create standard container images that can be used for `cOS` deployments
---


It's possible to create standard container images which are consumable by the vanilla `cOS` images (ISO, Cloud Images, etc.) during the upgrade and deploy phase. 

This allows anyone to create bootable images by just building and publishing a container image with the usual container workflow. The image have to contain parts of the cos-toolkit in order to be bootable, an illustrative example can be:

```
ARG LUET_VERSION=0.16.7

FROM quay.io/luet/base:$LUET_VERSION AS luet

FROM opensuse/leap:15.3
ARG ARCH=amd64
ENV ARCH=${ARCH}
RUN zypper in -y ...

RUN luet install -y \
    toolchain/yip \
    utils/installer \
    system/cos-setup \
    system/immutable-rootfs \
    system/grub-config \
    system/cloud-config \
    utils/k9s \
    utils/nerdctl

...
```

The workflow would be then:

1) `docker build` the image
2) `docker push` the image to some registry
3) `cos-upgrade --docker-image --no-verify $IMAGE` from a cOS machine

You can explore more examples in the [example section](https://github.com/rancher-sandbox/cOS-toolkit/tree/master/examples) on how to create bootable images