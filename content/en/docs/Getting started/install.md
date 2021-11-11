
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

