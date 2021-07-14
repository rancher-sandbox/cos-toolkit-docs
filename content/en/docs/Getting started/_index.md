---
title: "Getting Started"
linkTitle: "Getting Started"
weight: 1
description: >
  What does your user need to know to try your project?
---

### Build cOS Locally

The starting point to use cos-toolkit is to see it in action with our [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo) or check out our `examples` folder, see also [creating bootable images](/docs/creating_bootable_images.md).

The only requirement to build derivatives with `cos-toolkit` is docker installed, see [Development notes](/docs/dev.md) for more details on how to build `cos` instead.

## First steps

The [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo) contains the definitions of a [SampleOS](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/tree/master/packages/sampleOS) boilerplate, which results in an immutable single-image distro and a [simple HTTP service on top](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/tree/master/packages/sampleOSService) that gets started on boot.

To give it a quick shot, it's as simple as cloning the [Github repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo), and running cos-build:

```bash
$ git clone https://github.com/rancher-sandbox/cos-toolkit-sample-repo
$ cd cos-toolkit-sample-repo
$ source .envrc
$ cos-build
```

This command will build a container image which contains the required dependencies to build the custom OS, and will later be used to build the OS itself. The result will be a set of container images and an ISO which you can boot with your environment of choice.  See [Creating derivatives](/docs/creating_derivatives.md) for more details about the process.

If you are looking after only generating a container image that can be used for upgrades from the cOS vanilla images, see [creating bootable images](/docs/creating_bootable_images.md) and see also [how to drive upgrades with Fleet](https://github.com/rancher-sandbox/cos-fleet-upgrades-sample).