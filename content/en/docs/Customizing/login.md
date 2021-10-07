
---
title: "Login"
linkTitle: "Login"
weight: 3
date: 2017-01-05
description: >
  Default login, and how to override it
---

By default you can login with the user `root` and `cos` in a vanilla cOS image, this is also set automatically by the {{<package package="system/cloud-config" >}} package if used by a derivative.

You can change this by overriding `/system/oem/04_accounting.yaml` in the container image if present, or via [cloud-init](../../reference/cloud_init/#stagesstage_idstep_nameusers).

### Examples
- [Changing root password](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/00c0b4abf8225224c1c177f5b3bd818c7b091eaf/packages/sampleOS/build.yaml#L13)
- [Example accounting file](https://github.com/rancher-sandbox/epinio-appliance-demo-sample/blob/master/packages/epinioOS/04_accounting.yaml)
