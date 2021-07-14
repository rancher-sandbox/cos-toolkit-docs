
---
title: "Creating derivatives"
linkTitle: "Creating derivatives"
weight: 4
date: 2017-01-05
description: >
  Documents various methods for creating cOS derivatives
---

All the documentation below imply that the container image generated will be the booting one, there are however several configuration entrypoint that you should keep in mind while building the image which are general across all the implementation:

- Custom persistent runtime configuration has to be provided in `/system/oem` for derivatives.  Everything under `/system/oem` will be loaded during the various stages (boot, network, initramfs). You can check [here](https://github.com/rancher-sandbox/cOS-toolkit/tree/e411d8b3f0044edffc6fafa39f3097b471ef46bc/packages/cloud-config/oem) for the `cOS` defaults. See `00_rootfs.yaml` to customize the booting layout.
- `/etc/cos/bootargs.cfg` contains the booting options required to boot the image with GRUB
- `/etc/cos-upgrade-image` contains the default upgrade configuration for recovery and the booting system image

Derivatives inherits `cOS` defaults, which you can override during the build process.