
---
title: "Documentation"
linkTitle: "Documentation"
weight: 20
menu:
  main:
    weight: 20
---

## What is cOS?

cOS is a toolkit which allows container images to be bootable in VMs, baremetals, embedded devices, and much more.

cOS allows to create meta-Linux derivatives which are configured throughout cloud-init configuration files and are immutable by default.

cOS and derivatives shares a common feature set, can be upgraded in a **OTA-alike*** style, and upgrades are delivered with standard container registries. 

cOS comes also with vanilla images that can be used to boot directly container images built with the toolkit.

{{% alert title="Note" %}}
Note here we refer to "OTA-alike" merely as a method of distributing upgrades. It does not involve any specific setup (either wireless or cabled works) except an network connection to the registry where images are stored. Updates are delivered from one central location (the container registry) which hosts all images available for the clients to pull from.
{{% /alert %}}

## Why cOS? 

cOS allows to create custom OS versions in your cluster with standard container images with a high degree of customization. It can also be used in its vanilla form - cOS enables then everyone to build their own derivative and access it in various formats. 

To build a bootable image is as simple as running `docker build`.

* **What is it good for?**: Embedded, Cloud, Containers, VM, Baremetals, Servers, IoT, Edge

## Design goals

- A Manifest for container-based OS. It contains just the common bits to make a container image bootable and to be upgraded from, with few customization on top
- Everything is an OCI artifact from the ground-up
- Immutable-first, but with a flexible layout
- Cloud-init driven
- Based on systemd
- Built and upgraded from containers - It is a [single image OS](https://quay.io/repository/costoolkit/releases-green)!
- OTA updates
- Easy to customize
- Cryptographically verified
- instant switch from different versions
- recovery mechanism with `cOS` vanilla images (or bring your own)
