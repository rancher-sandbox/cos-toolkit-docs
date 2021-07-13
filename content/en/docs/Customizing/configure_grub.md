---
title: "GRUB"
linkTitle: "GRUB"
weight: 4
date: 2017-01-05
description: >
  GRUB 2 default boot entry setup
---


Each bootable image have a default boot arguments which are defined in `/etc/cos/bootargs.cfg`. This file is used by GRUB to parse the cmdline used to boot the image. 

For example:
```
set kernel=/boot/vmlinuz
if [ -n "$recoverylabel" ]; then
    # Boot arguments when the image is used as recovery
    set kernelcmd="console=tty1 root=live:CDLABEL=$recoverylabel rd.live.dir=/ rd.live.squashimg=$img panic=5"
else
    # Boot arguments when the image is used as active/passive
    set kernelcmd="console=tty1 root=LABEL=$label iso-scan/filename=$img panic=5 security=selinux selinux=1"
fi

set initramfs=/boot/initrd
```

You can tweak that file to suit your needs if you need to specify persistent boot arguments.

## Grub environment variables
cOS (since v0.5.8) makes use of the grub2 environment block which can used to define
persistent grub2 variables across reboots.

The default grub configuration loads the `/grubenv` of any available device
and evaluates on `next_entry` variable and `saved_entry` variable. By default
none is set.

The default boot entry is set to the value of `saved_entry`, in case the variable
is not set grub just defaults to the first menu entry.

`next_entry` variable can be used to overwrite the default boot entry for a single
boot. If `next_entry` variable is set this is only being used once, grub2 will
unset it after reading it for the first time. This is helpful to define the menu entry
to reboot to without having to make any permanent config change.

Use `grub2-editenv` command line utility to define desired values.

For instance use the following command to reboot to recovery system only once:

```bash
> grub2-editenv /oem/grubenv set next_entry=recovery
```

Or to set the default entry to `fallback` system:

```bash
> grub2-editenv /oem/grubenv set default=fallback
```

These examples make of the `COS_OEM` device, however it could use any device
detected by grub2 that includes the file `/grubenv`. First match wins.

