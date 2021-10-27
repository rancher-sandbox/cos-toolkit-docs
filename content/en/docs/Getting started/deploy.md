
---
title: "Deploying"
linkTitle: "Deploying"
weight: 6
date: 2021-10-27
description: >
  How to deploy derivatives images from cOS vanilla images
---


cOS vanilla images, like ISOs, cloud images or raw disks can be used to deploy another derivative image.

## `cos-deploy`

`cos-deploy` can be used to deploy an image to the system. 

It can be either invoked manually with `cos-deploy --docker-image <img-ref>` or used in conjuction with a cloud-init configuration, for example consider the following [cloud-init configuration file](../../reference/cloud_init):


```yaml
name: "Default deployment"
stages:
   rootfs.after:
     - name: "Repart image"
       layout:
         # It will partition a device including the given filesystem label or part label (filesystem label matches first)
         device:
           label: COS_RECOVERY
         add_partitions:
           - fsLabel: COS_STATE
             # 10Gb for COS_STATE, so the disk should have at least 16Gb
             size: 10240
             pLabel: state
           - fsLabel: COS_PERSISTENT
             # unset size or 0 size means all available space
             pLabel: persistent
   network:
     - if: '[ -f "/run/cos/recovery_mode" ]'
       name: "Deploy cos-system"
       commands:
         - |
             # Use `cos-deploy --docker-image <img-ref>` to deploy a custom image
             # By default latest cOS gets deployed
             cos-deploy --docker-image $IMAGE && shutdown -r now
```

The following will first repartition the image after the `rootfs` [stage](../../customizing/stages) and will run `cos-deploy` when booting into [recovery mode](../recovery). RAW vanilla disk images automatically boot by default into recovery, so the first thing upon booting is deploying the system