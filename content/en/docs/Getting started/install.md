
---
title: "Installing"
linkTitle: "Installing"
weight: 2
date: 2021-11-04
description: >
  Installing cOS or a derivative locally
---


cOS (or any cOS derivative built with cos-toolkit) can be installed with `cos-installer`, or `cos install`:

```bash
cos-installer [options] <device>
```

| Option             | Description                                                                                                  |
|--------------------|--------------------------------------------------------------------------------------------------------------|
| --force-efi        | Forces an EFI installation                                                                                   |
| --force-gpt        | Forces a GPT partition table                                                                                 |
| --iso              | Performs an installation from the ISO url                                                                    |
| --debug            | Enables debugging information                                                                                |
| --poweroff         | Shutdown the system after install                                                                            |
| --no-format        | Don't format disks. It is implied that COS_STATE, COS_RECOVERY, COS_PERSISTENT, COS_OEM are already existing |
| --config           | Cloud-init config file (see below)                                                                           |
| --partition-layout | Partitioning layout file (see below)                                                                         |
| --docker-image     | Install a specified container image                                                                          |
| --no-verify        | Disable mtree checksum verification (requires images manifests generated with mtree separately)              |
| --no-cosign        | Disable cosign verification (requires images with signatures)                                                |

### Custom OEM configuration

During installation it can be specified a [cloud-init config file](../../reference/cloud_init), that will be installed and persist in the system after installation:

```bash
cos-installer --config [url|path] <device>
```

### Custom partitioning layout

When installing with GPT or EFI it's possible to specify a custom partitioning layout via specific config file, e.g.:

```yaml
stages:
   partitioning:
     - name: "Repart disk"
       layout:
         device:
           path: /dev/sda
         add_partitions:
           - fsLabel: COS_STATE
             size: 8192
             pLabel: state
           - fsLabel: COS_OEM
             size: 10
             pLabel: oem
           - fsLabel: COS_RECOVERY
             # default filesystem is ext2 if omitted
             filesystem: ext4
             size: 40000
             pLabel: recovery
           - fsLabel: COS_PERSISTENT
             pLabel: persistent
             # default filesystem is ext2 if omitted
             filesystem: ext4
             size: 40000
```

Refer to the [cloud-init config file reference](../../reference/cloud_init) about the `layout` section.

It can be also used to create additional partitions, or either create partitions into a different device, etc..

Run the installer with 

```bash

cos-installer --partition-layout <file> <device>

```

{{% alert title="Note" %}}
While specifying a custom layout it is necessary to at least create 4 partitions: `COS_OEM`, `COS_STATE`, `COS_RECOVERY`, `COS_PERSISTENT`. Keep in mind the following while adjusting the partition sizes manually:

- `COS_OEM` typically is used to store cloud-init files, so it can be also small. 
- `COS_STATE` is used to store all the system images, which by default are set to `3GB`. This value is customizable [in our configuration file](../../customizing/general_configuration). A system may contain 2 images (Active/Passive), plus additional space for a third transitioning image which will be created during upgrades.
- `COS_RECOVERY` contains the recovery image, and additional space for a transition image during upgrades
- `COS_PERSISTENT` is the persistent partition that is mounted over `/usr/local`. Typically is set to take all the free space left.
{{% /alert %}}

### Installation from 3rd party LiveCD or rescue mediums

The installer can be used to perform installations also from outside the cOS or standard derivative ISOs.

For instance, it is possible to install cOS (or any derivative) with the installer from another bootable medium, or a rescue mode which is booting from RAM, given there is enough free RAM available. 

#### With Docker

If in the rescue system, or LiveCD you have docker available, it can be used to perform an installation

```bash
docker run --privileged -v $DEVICE:$DEVICE -ti quay.io/costoolkit/releases-green:cos-system-0.7.4-2 cos-installer --docker-image $IMAGE $DEVICE
```

Where `$IMAGE` is the container image that we want to install (e.g. `quay.io/costoolkit/releases-green:cos-system-0.7.4-2` ), and `$DEVICE` is the the device where to perform the installation to (e.g. /dev/sda).

Note, we used the `quay.io/costoolkit/releases-green:cos-system-0.7.4-2` image which contains the installer and the dependencies, similarly another derivative or another cos-system version can be used.


#### By using manually the installer

Similarly, the same mechanism can be used without docker. The [installer](https://raw.githubusercontent.com/rancher-sandbox/cOS-toolkit/master/packages/installer/cos.sh) can be used standalone:

```
GRUBCONFIG=<grub.cfg> ./cos.sh install [options]
```

An example grub config file can be found [here](https://raw.githubusercontent.com/rancher-sandbox/cOS-toolkit/master/packages/grub2/config/grub.cfg)