---
title: "Upgrades"
linkTitle: "Upgrades"
weight: 3
date: 2017-01-05
description: >
  Customizing the default upgrade channel
---

`cOS` vanilla images by default are picking upgrades by the standard upgrade channel. It means it will always get the latest published `cOS` version by our CI.

However, it's possible to tweak the default behavior of `cos-upgrade` to point to a specific docker image/tag, or a different release channel.


By default, `cos` derivatives if not specified will point to latest `cos-toolkit`. To override, you need to or overwrite the content of `/system/oem/02_upgrades.yaml` or supply an additional one, e.g. `/system/oem/03_upgrades.yaml` in the final image, see [an example here](https://github.com/rancher-sandbox/epinio-appliance-demo-sample/blob/master/packages/epinioOS/02_upgrades.yaml).

## `/etc/cos-upgrade-image`

This file is read from `cos-upgrade` during start and allows to tweak the following:

```bash
# Tweak the package to upgrade to, or the docker image (full reference)
UPGRADE_IMAGE=system/cos
# Turn on/off channel upgrades. If disabled, UPGRADE_IMAGE should be a full reference to a container image
CHANNEL_UPGRADES=true
# Turn on/off image signature checking. This is enabled by default when receiving upgrades from official channel
VERIFY=false
# Specify a separate recovery image (defaults to UPGRADE_IMAGE)
RECOVERY_IMAGE=recovery/cos
```

- **UPGRADE_IMAGE**: A container image reference ( e.g. `registry.io/org/image:tag` ) or a `luet` package ( e.g. `system/cos` )
- **CHANNEL_UPGRADES**: Boolean indicating wether to use channel upgrades or not. If it is disabled **UPGRADE_IMAGE** should refer to a container image, e.g. `registry.io/org/image:tag`
- **VERIFY**: Turns on and off image verification. Currently available for official `cOS` release channels
- **RECOVERY_IMAGE**: Allows to specify a different image for the recovery partition. Similarly to **UPGRADE_IMAGE** needs to be either an image reference or a package.

An example on how to tweak this file via cloud-init is available [here](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/7355876847367b75485873987e1217f1e1fe6254/packages/sampleOS/02_upgrades.yaml#L41)

## Changing the default release channel

Release channels are standard luet repositories. To change the default release channel, create a `/etc/luet/luet.yaml` configuration file pointing to a valid luet repository:

```yaml
# For a full reference, see:
# https://luet-lab.github.io/docs/docs/getting-started/#configuration
logging:
  color: false
  enable_emoji: false
general:
    debug: false
    spinner_charset: 9
repositories:
- name: "sampleos"
  description: "sampleOS"
  type: "docker"
  enable: true
  cached: true
  priority: 1
  verify: false
  urls:
  - "quay.io/costoolkit/releases-green"
```

An example on how to tweak this file via cloud-init is available [here](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/7355876847367b75485873987e1217f1e1fe6254/packages/sampleOS/02_upgrades.yaml#L11)

## References

- [complete example and documentation](https://github.com/rancher-sandbox/epinio-appliance-demo-sample#images).
