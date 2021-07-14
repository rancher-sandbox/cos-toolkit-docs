
---
title: "Recovery"
linkTitle: "Recovery"
weight: 5
date: 2017-01-04
description: >
  Show your user how to work through some end to end examples.
---


cOS derivatives have a recovery mechanism built-in which can be leveraged to restore the system to a known point. At installation time, the recovery partition is created from the installation medium.

### Recovery partition

A derivative can be recovered anytime by booting into the ` recovery` partition and by running `cos-reset` from it. 

This command will regenerate the bootloader and the images in the `COS_STATE` partition by using the recovery image.

### Upgrading the recovery partition

The recovery partition can also be upgraded by running 

```bash
cos-upgrade --recovery
``` 

from either the active or passive partition.

It also supports to specify docker images directly:

```bash
cos-upgrade --recovery --docker-image <image>
```

*Note*: the command has to be run in the standard partitions used for boot (Active or Fallback).

### Upgrading from the recovery partition

The recovery partition can upgrade also the active system by running `cos-upgrade`, and it also supports to specify docker images directly:

```bash
cos-upgrade --recovery --docker-image <image>
```

