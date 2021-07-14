---
title: "OEM configuration"
linkTitle: "OEM configuration"
weight: 3
date: 2017-01-05
description: >
  OEM configuration reserved to cOS and derivatives
---

Derivatives that wish to override default configurations can do that by placing extra cloud-init file, or overriding completely `/system/oem` in the target image.

This is to setup for example, the default root password or the prefered upgrade channel. 

```
/system/oem/00_rootfs.yaml - defines the rootfs mountpoint layout setting
/system/oem/01_defaults.yaml - systemd defaults (keyboard layout, timezone)
/system/oem/02_upgrades.yaml - Settings for channel upgrades
/system/oem/03_branding.yaml - Branding setting, Derivative name, /etc/issue content
/system/oem/04_accounting.yaml - Default user/pass
/system/oem/05_network.yaml - Default network setup
/system/oem/06_recovery.yaml - Executes additional commands when booting in recovery mode
```

If you are building a cOS derivative, and plan to release upgrades, you must override (or create a new file under `/system/oem`) the `/system/oem/02_upgrades.yaml` pointing to the docker registry used to deliver upgrades.

[See also the example appliance](https://github.com/rancher-sandbox/epinio-appliance-demo-sample#images)