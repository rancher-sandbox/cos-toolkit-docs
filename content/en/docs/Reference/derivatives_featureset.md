---
title: "Derivatives featureset"
linkTitle: "Derivatives featureset"
weight: 3
date: 2021-01-05
description: >
  Features inherited by cOS derivatives that are also available in the cOS vanilla images
---

## Runtime features

There are present default cloud-init configurations files  available under `/system/features` for example purposes, and to quickly enable testing features.

Features are simply cloud-config yaml files in the above folder and can be enabled/disabled with `cos-feature`. For example, after install, to enable `k3s` it's sufficient to type `cos-feature enable k3s` and reboot. Similarly, by adding a yaml file in the above folder will make it available for listing/enable/disable.

See `cos-feature list` for the available features.


```
$> cos-feature list

====================
cOS features list

To enable, run: cos-feature enable <feature>
To disable, run: cos-feature disable <feature>
====================

- carrier
- harvester
- k3s
- vagrant (enabled)
...
```

## SELinux policy

By default, derivatives have `SELinux` enabled in permissive mode. You can use the [cos-toolkit](https://github.com/rancher-sandbox/cOS-toolkit/tree/master/packages/selinux-policies) default policy as a kickstart to customize on top. 

Copy the package (create a new folder with `build.yaml`, `definition.yaml` and `cOS.te`) into the derivative tree and customize to suit your needs, and add it as a build requirement to your OS package.

_Note_: the [cOS.te](https://github.com/rancher-sandbox/cOS-toolkit/blob/master/packages/selinux-policies/cOS.te) sample policy was created using the utility `audit2allow` after running some
basic operations in permissive mode using system default policies. `allow2audit`
translates audit messages into allow/dontaudit SELinux policies which can be later
compiled as a SELinux module. This is the approach used in this illustration
example and mostly follows `audit2allow` [man pages](https://linux.die.net/man/1/audit2allow).
