---
title: "Creating bootable images"
linkTitle: "Creating bootable images"
weight: 2
date: 2017-01-05
description: >
  This document describes the requirements to create standard container images that can be used for `cOS` deployments
---

![](https://docs.google.com/drawings/d/e/2PACX-1vSmIZ5FTInGjtkGonUOgwhti6DZnSoeexGmWL9CAmbdiIGtBGnzDuGNj80Lj_206hP0MOxQGpEdYFvK/pub?w=1223&h=691)

A derivative is a simple container image which can be processed by the cOS toolkit in order to be bootable and installable. This section describes the requirements to create a container image that can be run by `cOS`.

Bootable images are standard container images, that means the usual `build` and `push` workflow applies, and building images is also a way to persist [oem customizations](../../customizing). 

The base image can be any Linux distribution that is compatible with our flavors.

The only requirement is that the image has to contain parts of the cos-toolkit in order to be bootable, a kernel and an Initrd. An illustrative example can be:

```Dockerfile
ARG LUET_VERSION=0.16.7

FROM quay.io/luet/base:$LUET_VERSION AS luet

FROM opensuse/leap:15.3 # or Fedora, Ubuntu
ARG ARCH=amd64
ENV ARCH=${ARCH}
RUN zypper in -y ... # apt-get, dnf...

# That's where we install the minimal cos-toolkit meta-package (which pulls the minimal packages needed in order to boot)
RUN luet install -y meta/cos-minimal

# Other custom logic. E.g, customize statically the upgrade channel, default users, packages.
...
```

In the example above, the cos-toolkit parts that are **required** are pulled in by `RUN luet install -y meta/cos-minimal`.

{{% alert title="Note" %}}
The image should provide at least `grub`, `systemd`, `dracut`, a kernel and an initrd. Those are the common set of packages between derivatives. See also [package stack](../package_stack). 
By default the initrd is expected to be symlinked to `/boot/initrd` and the kernel to `/boot/vmlinuz`, otherwise you can specify a custom path while [building an iso](../build_iso) and [by customizing grub](../../customizing/configure_grub).
{{% /alert %}}

The workflow would be then:

1) `docker build` the image
2) `docker push` the image to some registry
3) `cos-upgrade --docker-image --no-verify $IMAGE` from a cOS machine ( or `cos-deploy` if bootstrapping a cloud image )

You can explore more examples in the [example section](../../examples/creating_bootable_images) on how to create bootable images.

## What's next?

Now that we have created our derivative container, we can either:

- [Build an iso](../build_iso)
- [Build an Amazon Image](../packer/build_ami)
- [Build a Google Cloud Image](../packer/build_gcp)