---
title: "Getting Started"
linkTitle: "Getting Started"
weight: 1
description: >
  What does your user need to know to try your project?
---

You can either choose to **build** a cOS derivatives or **run** cOS as-is.

## Download cOS

You can just try out cOS from the vanilla images: they are systems with a minimal package set in order to boot. [Download](../download) (if needed) the appriopriate artifact for your [Booting medium](../booting). cOS can run in: VMs, baremetals and Cloud. The default login username/password is `root/cos`.

### What to do next?

Check out [the customization section](../customizing) to customize `cOS` or [the tutorial section](../tutorials) for some already prepared recipe examples.

## Build cOS derivatives

The starting point to use cos-toolkit is to check out our `examples` folder in `cos`, see also [creating bootable images](../creating_derivatives/creating_bootable_images) or have a look on one of our [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo).

The only requirement to build derivatives with `cos-toolkit` is docker installed, see [Development notes](/docs/dev.md) for more details on how to build `cos` instead.

### What to do next?

Check out [how to create bootable images](../creating-derivatives/creating_bootable_images) and [how to create full blown derivatives](../creating-derivatives/creating_derivatives)
