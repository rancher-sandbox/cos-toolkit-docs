
---
title: "Documentation"
linkTitle: "Documentation"
weight: 20
menu:
  main:
    weight: 20
---

## What is cOS?

cOS is a toolkit for meta-Linux derivatives which is configured throuought cloud-init configuration files. It is immutable and with a strong declarative format.

Allows to ship and maintain cloud-init driven Linux derivatives based on container images with a common featureset. 

It is designed to reduce the maintenance surface, with a flexible approach to provide upgrades from container registries. It is cloud-init driven and also designed to be adaptive-first, allowing easily to build changes on top.

cOS comes also with vanilla images, that can be used to boot directly container images built with the toolkit.

## Why cOS? 

cOS allows to create custom OS versions in your cluster with standard container images with a high degree of customization. It can also be used in its vanilla form - cOS enables everyone to build their own derivative and access it in various formats. It's like "Ventoy" for persistent systems.


To build a bootable image is as simple as running `docker build`.

* **What is it good for?**: Embedded, Cloud, Containers, VM, Baremetals, Servers, IoT, Edge

* **What is it not good for?**: Workstations (?), Gaming, 

## Design goals

- A Manifest for container-based OS. It contains just the common bits to make a container image bootable and to be upgraded from, with few customization on top
- Immutable-first, but with a flexible layout
- Cloud-init driven
- Based on systemd
- Built and upgraded from containers - It is a [single image OS](https://quay.io/repository/costoolkit/releases-opensuse)!
- OTA updates
- Easy to customize
- Cryptographically verified
- instant switch from different versions
- recovery mechanism with `cOS` vanilla images (or bring your own)


## Immutable File system layout

![Partitioning layout](https://docs.google.com/drawings/d/e/2PACX-1vR-I5ZwwB5EjpsymUfcNADRTTKXrNMnlZHgD8RjDpzYhyYiz_JrWJwvpcfMcwfYet1oWCZVWH22aj1k/pub?w=533&h=443)

By default, `cos` derivative will inherit an immutable setup.
A running system will look like as follows:

```
/usr/local - persistent (COS_PERSISTENT)
/oem - persistent (COS_OEM)
/etc - ephemeral
/usr - read only
/ immutable
```

Any changes that are not specified by cloud-init are not persisting across reboots.
