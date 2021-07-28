---
title: "Getting Started"
linkTitle: "Getting Started"
weight: 1
description: >
  Getting started with cOS
---

You can either choose to **build** a cOS derivatives or **run** cOS as-is.

cOS vanilla images are published to allow further customization for derivatives. The assets can be used to either boostrap and customize furthermore a derivative, or drive unattended deployments that can be later turned to a custom derivative flavor ( for example, with an ISO ).

## Download cOS

You can just try out cOS from the vanilla images and use it to bootstrap your derivative: those are minimal system with a small package set in order to boot and deploy a container. [Download](../getting-started/download) (if needed) the appriopriate artifact for your [Booting medium](../getting-started/booting). cOS can run in: VMs, baremetals and Cloud. The default login username/password is `root/cos`.

### Install

To install run `cos-installer <device>` to start the installation process. Remove the ISO/medium and reboot.

_Note_: `cos-installer` supports other options as well. Run `cos-installer --help` to see a complete help.

### What to do next?

Check out [the customization section](../customizing) to customize `cOS` or [the tutorial section](../tutorials) for some already prepared recipe examples.

## Build cOS derivatives

The starting point to use cos-toolkit is to check out our `examples` folder in `cos`, see also [creating bootable images](../creating-derivatives/creating_bootable_images) or have a look on one of our [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo).

The only requirement to build derivatives with `cos-toolkit` is docker installed, see [Development notes](../development) for more details on how to build `cos` instead.

### What to do next?

Check out [how to create bootable images](../creating-derivatives/creating_bootable_images) and [how to create full blown derivatives](../examples/creating_derivatives)
