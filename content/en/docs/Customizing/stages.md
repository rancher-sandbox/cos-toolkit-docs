
---
title: "Stages"
linkTitle: "Stages"
weight: 3
date: 2017-01-05
description: >
  Configure the system in the various stages: boot, initramfs, fs, network, reconcile
---

Cloud-init files in `/system/oem`, `/oem` and `/usr/local/oem` are applied in 5 different phases: `boot`, `network`, `fs`, `initramfs` and `reconcile`. All the available cloud-init keywords can be used in each stage. Additionally, it's possible also to hook before or after a stage has run, each one has a specific stage which is possible to run steps: `boot.after`, `network.before`, `fs.after` etc.

#### initramfs

This is the earliest stage, running before switching root. Here you can apply radical changes to the booting setup of `cOS`.

#### boot

This stage is executed after initramfs has switched root, during the `systemd` bootup process.

#### fs

This stage is executed when fs is mounted and is guaranteed to have access to `COS_STATE` and `COS_PERSISTENT`.

#### network

This stage is executed when network is available

#### reconcile

This stage is executed `5m` after boot and periodically each `60m`.
