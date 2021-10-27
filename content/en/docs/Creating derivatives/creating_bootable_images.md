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

## Requirements
{{<image_right image="https://docs.google.com/drawings/d/e/2PACX-1vQBfT10W88mD1bbReDmAJIOPF3tWdVHP7QE9w7W7ByOIzoKGOdh2z5YWsKf7wn8csFF_QGrDXgGsPWg/pub?w=478&h=178">}}

Bootable images are standard container images, that means the usual `build` and `push` workflow applies, and building images is also a way to persist [oem customizations](../../customizing). 

The base image can be any Linux distribution that is compatible with our flavors.

The image needs to ship:
- parts of the cos-toolkit (required, see below)
- kernel (required)
- initrd (required)
- grub (required)
- dracut (optional, kernel and initrd can be consumed from the cOS repositories)
- microcode (optional, not required in order to boot, but recomended)

## Example

An illustrative example can be:

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

{{<package package="meta/cos-minimal" >}} is a meta-package that will pull {{<package package="toolchain/luet" >}}, {{<package package="toolchain/yip" >}}, {{<package package="utils/installer" >}}, {{<package package="system/cos-setup" >}}, {{<package package="system/immutable-rootfs" >}}, {{<package package="system/base-dracut-modules" >}}, {{<package package="system/grub2-config" >}}, {{<package package="system/cloud-config" >}}. 

{{% alert title="Note" %}}
{{<package package="system/cloud-config" >}} is optional, but provides `cOS` defaults setting, like default user/password and so on. If you are not installing it directly, an equivalent cloud-config has to be provided in order to properly boot and run a system, see [oem configuration](../../customizing/oem_configuration).
{{% /alert %}}

## Initrd
The image should provide at least `grub`, `systemd`, `dracut`, a kernel and an initrd. Those are the common set of packages between derivatives. See also [package stack](../package_stack). 
By default the initrd is expected to be symlinked to `/boot/initrd` and the kernel to `/boot/vmlinuz`, otherwise you can specify a custom path while [building an iso](../build_iso) and [by customizing grub](../../customizing/configure_grub).

{{<package package="system/base-dracut-modules" >}} is required to be installed with `luet` in case you are building manually the initrd from the Dockerfile and also to run `dracut` to build the initrd, the command might vary depending on the base distro which was chosen.

{{<package package="system/kernel" >}} and {{<package package="system/dracut-initrd" >}} can also be installed if you plan to use kernels and initrd from the `cOS` repositories and don't build them / or install them from the official distro repositories (e.g. with `zypper`, or `dnf` or either `apt-get`...). In this case you don't need to generate initrd on your own, neither install the kernel coming from the base image.

## Building

![](https://docs.google.com/drawings/d/e/2PACX-1vS6eRyjnjdQI7OBO0laYD6vJ2rftosmh5eAog6vk_BVj8QYGGvnZoB0K8C6Qdu7SDz7p2VTxejcZsF6/pub?w=956&h=339)

The workflow would be then:

1) `docker build` the image
2) `docker push` the image to some registry
3) `cos-upgrade --docker-image --no-verify $IMAGE` from a cOS machine ( or `cos-deploy` if bootstrapping a cloud image )

The following can be incorporated in any standard gitops workflow.

You can explore more examples in the [example section](../../examples/creating_bootable_images) on how to create bootable images.

## What's next?

Now that we have created our derivative container, we can either:

- [Build an iso](../build_iso)
- [Build an Amazon Image](../packer/build_ami)
- [Build a Google Cloud Image](../packer/build_gcp)
