---
title: "Getting Started"
linkTitle: "Getting Started"
weight: 1
description: >
  Getting started with cOS
---

![](https://docs.google.com/drawings/d/e/2PACX-1vRSuocC4_2rHeJAWW2vqinw_EZeZxTzJFo5ZwnJaL_sdKab_R_OsCTLT_LFh1_L5fUcA_2i9FIe-k69/pub?w=1223&h=691)

cOS provides a runtime and buildtime framework for containers in order to boot them in VMs, Baremetals and Cloud.

You can either choose to **build** a cOS derivative or **run** cOS to boostrap a new system.

cOS vanilla images are published to allow further customization when building derivatives. Derivatives can be built just with Container images, and cOS is designed to run, deploy and upgrade those. cOS assets can be used to either drive unattended deployments of a derivative or used to create custom images (with packer).

## Build cOS derivatives

The starting point to use cos-toolkit is to check out our [examples](https://github.com/rancher-sandbox/cOS-toolkit/tree/master/examples), see also [creating bootable images](../creating-derivatives/creating_bootable_images) or have a look on one of our [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo).

The only requirement to build derivatives with `cos-toolkit` is docker installed, see [Development notes](../development) for more details on how to build `cOS` itself instead.

### What to do next?

Check out [how to create bootable images](../creating-derivatives/creating_bootable_images) or [download the cOS vanilla images](../getting-started/download) to give cOS a try!
