---
title: "General Configuration"
linkTitle: "General Configuration"
weight: 3
date: 2017-01-05
description: >
  Configuring a cOS derivative
---


cOS during installation, reset and upgrade (`cos-installer`, `cos-reset` and `cos-upgrade` respectively) will read a configuration file in order to apply derivative customizations. The configuration files are sourced in precedence order and can be located in the following places:

- `/etc/environment`
- `/etc/os-release`
- `/etc/cos/config`

A typical configuration file might look like this:

{{<githubembed repo="rancher-sandbox/cos-toolkit" file="examples/standard/files/etc/cos/config" lang="bash">}}

## Reference

Here you can find the full reference of the variables that can be set in the cos configuration file:

- `VERIFY`: Disable/enable image verification during upgrades ( default: true )
- `CHANNEL_UPGRADES`: Disable/enable upgrades via release channels instead of container images ( default: true )
- `UPGRADE_IMAGE`: Default container image used for upgrades ( defaults to system/cos with channel `CHANNEL_UPGRADES` enabled ). See also [upgrades](../upgrades)
- `RECOVERY_IMAGE`: Default recovery image to use when upgrading the recovery partition ( defaults to `UPGRADE_IMAGE`, _Note_: by default vanilla cOS images are using `recovery/cos` with channel CHANNEL_UPGRADES enabled )
- `GRUB_ENTRY_NAME`: Default GRUB entry to display on boot ( defaults: cOS ). See also [configure GRUB](../configure_grub)
