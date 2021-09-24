---
title: "Configuration persistency"
linkTitle: "Configuration persistency"
weight: 2
date: 2017-01-05
description: >
  Persisting configurations in cOS and derivatives
---

It is possible to install a custom [cloud-init style file](../../reference/cloud_init/) during install with `--config` to `cos-installer` or, it's possible to add more files manually to the `/oem` folder after installation. The file will be placed under `/usr/local/oem` and will persist across reboots.

By default cOS and derivatives, are reading and executing cloud-init files in (lexicopgrahic) sequence present in `/system/oem`, `/usr/local/cloud-config` and `/oem` during boot. It is also possible to run cloud-init file in a different location from boot cmdline by using  the `cos.setup=..` option.

While `/system/oem` is reserved for system configurations, for example to be included in the container image, the `/oem` folder instead is reserved for persistent cloud-init files to be executed in the various stages.

For example, if you want to change `/etc/issue` of the system persistently, you can create `/usr/local/cloud-config/90_after_install.yaml` with the following content:

```yaml
# The following is executed before fs is setted up:
stages:
    fs:
        - name: "After install"
          files:
          - path: /etc/issue
            content: |
                    Welcome, have fun!
            permissions: 0644
            owner: 0
            group: 0
          systemctl:
            disable:
            - wicked
        - name: "After install (second step)"
          files:
          - path: /etc/motd
            content: |
                    Welcome, have more fun!
            permissions: 0644
            owner: 0
            group: 0
```

For more examples you can find `/system/oem` inside cOS vanilla images containing files used to configure on boot a pristine `cOS`. 