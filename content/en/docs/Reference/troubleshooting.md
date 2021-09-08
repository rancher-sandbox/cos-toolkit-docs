---
title: "Troubleshooting"
linkTitle: "Troubleshooting"
weight: 5
date: 2021-09-08
description: >
  Stuff can go wrong. This document tries to make them right with some useful tips
---

{{% pageinfo color="warning"%}}
Section under construction.
{{% /pageinfo %}}

While building a derivative, or on a running system things can go really wrong, the guide is aimed to give tips while building derivatives and also debugging running systems.

Don't forget tocheck the known issues for the [release you're using](https://github.com/rancher-sandbox/cOS-toolkit/issues).

## Kernel parameters

Before booting, several kernel parameters can be used to help during debugging (also when booting an ISO). Those are meant to be used only while debugging, and they might
defeat the concept of immutability.

- `rd.cos.debugrw`: disables read only mode. It might be useful while testing changes in the [Immutable setup](../immutable_rootfs).
- `rd.break=pre-mount rd.shell`: Drop a shell before setting up mount points
- `rd.break=pre-pivot rd.shell`: Drop a shell before switch-root

## Recovery partition

If you can boot into the system, the recovery partition can be used to reset the state of the active/passive, but can also be used to upgrade to specific images. Be sure to read the [Recovery section in the docs](../../getting-started/recovery).

## References
- https://fedoraproject.org/wiki/How_to_debug_Dracut_problems