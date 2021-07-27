---
title: "Build ISOs"
linkTitle: "Build ISOs"
weight: 4
date: 2017-01-05
description: >
  Build ISOs from bootable images
---


In order to build an iso at the moment of writing, we first rely on [luet-makeiso](https://github.com/mudler/luet-makeiso). It accepts a YAML file denoting the packages to bundle in an ISO and a list of luet repositories where to download the packages from.

A sample can be found [here](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/master/iso.yaml). 

To build an iso, just run:

```bash
docker run -v $PWD:/cOS -v /var/run:/var/run --entrypoint /usr/bin/luet-makeiso -ti --rm quay.io/costoolkit/toolchain ./iso.yaml --image $IMAGE
```

Where `iso.yaml` is the iso specification file, and `--image $IMAGE` is the container image you want to build the ISO for.

An example of a yaml file using the cos-toolkit opensuse repositories:

```yaml
packages:
  uefi:
  - live/systemd-boot
  - live/boot
  isoimage:
  - live/syslinux
  - live/boot

initramfs:
  kernel_file: "vmlinuz"
  rootfs_file: "initrd"

overlay: true
image_prefix: "distro"
image_date: true
label: "COS_LIVE"

luet:
  repositories:
  - name: cOS
    enable: true
    urls:
      - quay.io/costoolkit/releases-green
    type: docker
```

Below you can find more reference about the yaml file format.

## Syntax

```yaml
packages:
  # (optional) Packages to be installed in the rootfs
  rootfs:
  - ..
  # Packages to be installed in the uefi image
  uefi:
  - live/systemd-boot
  - live/boot
  # Packages to be installed in the isoimage
  isoimage:
  - live/syslinux
  
# Specify initramfs/kernel and avoid generation on-the-fly
# files must be present on /boot folder in the rootfs
initramfs:
  kernel_file: "vmlinuz"
  rootfs_file: "initrd"

overlay: true # Use overlayFS layout

# Specify a container remote image to pull and use for the rootfs in place of packages (optional)
rootfs_image: "ubuntu:latest"

# Image prefix. If Image date is disabled is used as the full title.
image_prefix: "MYOS-0."
image_date: true

# Luet repositories (https://luet-lab.github.io/docs/docs/getting-started/#configuration-in-etcluetreposconfd) to use.
luet:
  repositories:
  - name: cOS
    enable: true
    urls:
      - quay.io/costoolkit/releases-green
    type: docker

```

Flags:
- **local**: Path to local luet repository to use to install packages from
- **image**: Optional image to use as rootfs

## Configuration reference

### `rootfs_image`

A container image reference (e.g. `quay.io/.../...:latest`) that will be used as a rootfs for the ISO.

### `packages.rootfs`

A list of luet packages to install in the rootfs. The rootfs will be squashed to a `rootfs.squashfs` file

### `packages.uefi`

A list of luet packages to be present in the efi ISO sector.

### `packages.isoimage`

A list of luet packages to be present in the ISO image.

### `repository.packages`

A list of package repository (e.g. `repository/mocaccino-extra`) to be installed before `luet install` commands Requirements

### `initramfs.kernel_file`

The kernel file under `/boot/` that is your running  kernel. e.g. `vmlinuz` or `bzImage`

### `initramfs.rootfs_file`

The initrd file under `/boot/` that has all the utils for the initramfs

### `image_prefix`

ISO image prefix to use

### `image_date`

Boolean indicating if the output image name has to contain the date

### `image_name`

A string representing the ISO final image name

### `arch`

A string representing the arch. Defaults to `x86_64`.

### `luet.config`

Path to the luet config to use to install the packages from

## Separate recovery

To make an ISO with a separate recovery image as squashfs, you can either use the default from `cOS`, by adding it in the iso yaml file:


```yaml
packages:
  rootfs:
  ..
  uefi:
  ..
  isoimage:
  ...
  - recovery/cos-img
```

The installer will detect the squashfs file in the iso, and will use it when installing the system. You can customize the recovery image as well by providing your own: see the `recovery/cos-img` package definition as a reference.
