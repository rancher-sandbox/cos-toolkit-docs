---
title: "Derivatives featureset"
linkTitle: "Derivatives featureset"
weight: 3
date: 2021-01-05
description: >
  Features inherited by cOS derivatives that are also available in the cOS vanilla images
---


This document describes the shared featureset between derivatives that directly depend on `system/cos`.

Every derivative share a common configuration layer, along few packages by default in the stack.

## Package stack

When building a `cos-toolkit` derivative, a common set of packages are provided already with a common default configuration. Some of the most notably are:

- systemd as init system
- grub for boot loader
- dracut for initramfs

Each `cos-toolkit` flavor (opensuse, ubuntu, fedora) ships their own set of base packages depending on the distribution they are based against. You can find the list of packages in the `packages` keyword in the corresponding [values file for each flavor](https://github.com/rancher-sandbox/cOS-toolkit/tree/master/values)

## Login

By default you can login with the user `root` and `cos`.

You can change this by overriding `/system/oem/04_accounting.yaml` in the derivative spec file.

### Examples
- [Changing root password](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/00c0b4abf8225224c1c177f5b3bd818c7b091eaf/packages/sampleOS/build.yaml#L13)
- [Example accounting file](https://github.com/rancher-sandbox/epinio-appliance-demo-sample/blob/master/packages/epinioOS/04_accounting.yaml)

## Install

To install run `cos-installer <device>` to start the installation process. Remove the ISO and reboot.

_Note_: `cos-installer` supports other options as well. Run `cos-installer --help` to see a complete help.

## Upgrades

To upgrade an installed system, just run `cos-upgrade` and reboot.

cOS during installation sets two `.img` images files in the `COS_STATE` partition:
- `/cOS/active.img` labeled `COS_ACTIVE`: Where `cOS` typically boots from
- `/cOS/passive.img` labeled `COS_PASSIVE`: Where `cOS` boots for fallback

Those are used by the upgrade mechanism to prepare and install a pristine `cOS` each time an upgrade is attempted.

To specify a single docker image to upgrade to  instead of the regular upgrade channels, run `cos-upgrade --docker-image image`.

_Note_ by default `cos-upgrade --docker-image` checks images against the notary registry server for valid signatures for the images tag. To disable image verification, run `cos-upgrade --no-verify --docker-image`.

See the [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo#system-upgrades) readme on how to tweak the upgrade channels for the derivative and [a further description is available here](https://github.com/rancher-sandbox/epinio-appliance-demo-sample#images)

## Reset state

cOS derivatives have a recovery mechanism built-in which can be leveraged to restore the system to a known point. At installation time, the recovery partition is created from the installation medium.

### Recovery partition

A derivative can be recovered anytime by booting into the ` recovery` partition and by running `cos-reset` from it. 

This command will regenerate the bootloader and the images in the `COS_STATE` partition by using the recovery image.

### Upgrading the recovery partition

The recovery partition can also be upgraded by running 

```bash
cos-upgrade --recovery
``` 

It also supports to specify docker images directly:

```bash
cos-upgrade --recovery --docker-image <image>
```

*Note*: the command has to be run in the standard partitions used for boot (Active or Fallback).

### From ISO
The ISO can be also used as a recovery medium: type `cos-upgrade` from a LiveCD. It will then try to upgrade the image of the active partition installed in the system.

## File system layout

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



## Runtime features

There are present default cloud-init configurations files  available under `/system/features` for example purposes, and to quickly enable testing features.

Features are simply cloud-config yaml files in the above folder and can be enabled/disabled with `cos-feature`. For example, after install, to enable `k3s` it's sufficient to type `cos-feature enable k3s` and reboot. Similarly, by adding a yaml file in the above folder will make it available for listing/enable/disable.

See `cos-feature list` for the available features.


```
$> cos-feature list

====================
cOS features list

To enable, run: cos-feature enable <feature>
To disable, run: cos-feature disable <feature>
====================

- carrier
- harvester
- k3s
- vagrant (enabled)
...
```

## SELinux policy

By default, derivatives have `SELinux` enabled in permissive mode. You can use the [cos-toolkit](https://github.com/rancher-sandbox/cOS-toolkit/tree/master/packages/selinux-policies) default policy as a kickstart to customize on top. 

Copy the package (create a new folder with `build.yaml`, `definition.yaml` and `cOS.te`) into the derivative tree and customize to suit your needs, and add it as a build requirement to your OS package.

_Note_: the [cOS.te](https://github.com/rancher-sandbox/cOS-toolkit/blob/master/packages/selinux-policies/cOS.te) sample policy was created using the utility `audit2allow` after running some
basic operations in permissive mode using system default policies. `allow2audit`
translates audit messages into allow/dontaudit SELinux policies which can be later
compiled as a SELinux module. This is the approach used in this illustration
example and mostly follows `audit2allow` [man pages](https://linux.die.net/man/1/audit2allow).
