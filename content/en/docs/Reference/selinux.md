---
title: "SELinux"
linkTitle: "SELinux"
weight: 3
date: 2021-01-05
description: >
  Build SELinux policies with cOS
---

You can use the [cos-toolkit sample](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/tree/master/packages/selinux-policies) policy as a kickstart to customize on top. 

Copy the package (create a new folder with `build.yaml`, `definition.yaml` and `cOS.te`) into cOS or use it as a base while creating a derivative and customize to suit your needs.

_Note_: the [cOS.te](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/master/packages/selinux-policies/cOS.te) sample policy was created using the utility `audit2allow` after running some
basic operations in permissive mode using system default policies. `allow2audit`
translates audit messages into allow/dontaudit SELinux policies which can be later
compiled as a SELinux module. This is the approach used in this illustration
example and mostly follows `audit2allow` [man pages](https://linux.die.net/man/1/audit2allow).
