
---
title: "Booting"
linkTitle: "Booting"
weight: 2
date: 2017-01-05
description: >
  Documents various methods for booting cOS vanilla images
---

## ISO

ISO images are shipping a cOS vanilla image and they have an installer to perform an automated installation. They can be used to burn USB sticks or CD/DVD used to boot baremetals. 

## Virtual machines

For booting into Virtual machines we offer QCOW2, OVA, and raw disk recovery images.

### QCOW2

QCOW2 images contains a pre-installed cOS vanilla system which can be booted via QEMU, e.g:

```bash
qemu-system-x86_64 -m 2048 -hda <cos-disk-image>.raw -bios /usr/share/qemu/ovmf-x86_64.bin
```

### OVA

OVA images contains a pre-installed cOS vanilla system that can be imported in Virtualbox, Vsphere and used also imported as AMI images.

### Vagrant

Download the vagrant box, and run:

```bash
vagrant box add cos <cos-box-image>
vagrant init cos
vagrant up
```

### RAW disk images

RAW disk images contains only the `cOS` recovery system. Those are typically used when creating derivatives images based on top of `cOS`.

They can be run with QEMU with:

```bash
qemu-system-x86_64 -m 2048 -hda <cos-disk-image>.raw -bios /usr/share/qemu/ovmf-x86_64.bin
```

## Cloud Images

At the moment we support Azure and AWS images among our artifacts. We publish also AWS images that can be re-used in packer templates for creating customized AMI images. 

### Import an AWS image manually

1. Upload the raw image to an S3 bucket
```
aws s3 cp <cos-raw-image> s3://<your_s3_bucket>
```

2. Created the disk container JSON (`container.json` file) as:

```
{
  "Description": "cOS Testing image in RAW format",
  "Format": "raw",
  "UserBucket": {
    "S3Bucket": "<your_s3_bucket>",
    "S3Key": "<cos-raw-image>"
  }
}
```

3. Import the disk as snapshot

```
aws ec2 import-snapshot --description "cOS PoC" --disk-container file://container.json
```

4. Followed the procedure described in [AWS docs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html#creating-launching-ami-from-snapshot) to register an AMI from snapshot. Used all default settings unless for the firmware, set to force to UEFI boot.

5. Launch instance with this simple userdata with at least a 16Gb boot disk:
```
name: "Default deployment"
stages:
   rootfs.after:
     - name: "Repart image"
       layout:
         # It will partition a device including the given filesystem label or part label (filesystem label matches first)
         device:
           label: COS_RECOVERY
         # Only last partition can be expanded
         # expand_partition:
         #   size: 4096
         add_partitions:
           - fsLabel: COS_STATE
             size: 8192
             pLabel: state
           - fsLabel: COS_PERSISTENT
             # unset size or 0 size means all available space
             # size: 0 
             # default filesystem is ext2 when omitted
             # filesystem: ext4
             pLabel: persistent
   network:
     - if: '[ -f "/run/cos/recovery_mode" ]'
       name: "Deploy cos-system"
       commands:                                                                 
         - |
             # Use `cos-deploy --docker-image <img-ref>` to deploy a custom image
             # By default latest cOS gets deployed
             cos-deploy && shutdown -r +1

```


### Importing a Google Cloud image manually

1. Upload the Google Cloud compressed disk to your bucket

```bash
gsutil cp <cos-gce-image> gs://<your_bucket>/
```

2. Import the disk as an image

```bash
gcloud compute images create <new_image_name> --source-uri=<your_bucket>/<cos-gce-image> --guest-os-features=UEFI_COMPATIBLE
```

3. Launch instance with this simple userdata with at least a 16Gb boot disk:

HINT: See [here](https://cloud.google.com/container-optimized-os/docs/how-to/create-configure-instance#using_cloud-init_with_the_cloud_config_format) on how to add user-data to an instance

```yaml
name: "Default deployment"
stages:
   rootfs.after:
     - name: "Repart image"
       layout:
         # It will partition a device including the given filesystem label or part label (filesystem label matches first)
         device:
           label: COS_RECOVERY
         # Only last partition can be expanded
         # expand_partition:
         #   size: 4096
         add_partitions:
           - fsLabel: COS_STATE
             size: 8192
             pLabel: state
           - fsLabel: COS_PERSISTENT
             # unset size or 0 size means all available space
             # size: 0 
             # default filesystem is ext2 when omitted
             # filesystem: ext4
             pLabel: persistent
   network:
     - if: '[ -f "/run/cos/recovery_mode" ]'
       name: "Deploy cos-system"
       commands:                                                                 
         - |
             # Use `cos-deploy --docker-image <img-ref>` to deploy a custom image
             # By default latest cOS gets deployed
             cos-deploy && shutdown -r +1
```

## Login

By default you can login with the user `root` and password `cos`.

See the [customization section](../customizing/login) for examples on how to persist username and password changes after installation.
