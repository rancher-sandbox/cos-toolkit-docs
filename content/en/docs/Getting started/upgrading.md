
---
title: "Upgrading"
linkTitle: "Upgrading"
weight: 4
date: 2017-01-04
description: >
  How to run upgrades in cOS
---


To upgrade an installed system, just run `cos-upgrade` and reboot.

cOS during installation sets two `.img` images files in the `COS_STATE` partition:
- `/cOS/active.img` labeled `COS_ACTIVE`: Where `cOS` typically boots from
- `/cOS/passive.img` labeled `COS_PASSIVE`: Where `cOS` boots for fallback

Those are used by the upgrade mechanism to prepare and install a pristine `cOS` each time an upgrade is attempted.

To specify a single docker image to upgrade to  instead of the regular upgrade channels, run `cos-upgrade --docker-image image`.

_Note_ by default `cos-upgrade --docker-image` checks images against the notary registry server for valid signatures for the images tag. To disable image verification, run `cos-upgrade --no-verify --docker-image`.

See the [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo#system-upgrades) readme on how to tweak the upgrade channels for the derivative and [a further description is available here](https://github.com/rancher-sandbox/epinio-appliance-demo-sample#images)

## From ISO

The ISO can be also used as a recovery medium: type `cos-upgrade` from a LiveCD. It will then try to upgrade the image of the active partition installed in the system.

## Integration with System Upgrade Controller

If running a kubernetes cluster on the `cOS` system, you can leverage the [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller) to trigger upgrades to specific image versions, for example:

```yaml
---
apiVersion: upgrade.cattle.io/v1
kind: Plan
metadata:
  name: cos-upgrade
  namespace: system-upgrade
  labels:
    k3s-upgrade: server
spec:
  concurrency: 1
  version:  fleet-sample # Image tag
  nodeSelector:
    matchExpressions:
      - {key: k3s.io/hostname, operator: Exists}
  serviceAccountName: system-upgrade
  cordon: true
#  drain:
#    force: true
  upgrade:
    image: quay.io/costoolkit/test-images # Image upgrade reference
    command:
    - "/usr/sbin/suc-upgrade"
```

See also [trigger upgrades with fleet](../tutorials/trigger_upgrades_with_fleet)