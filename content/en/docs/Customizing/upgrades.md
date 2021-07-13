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

An example on how to tweak this file via cloud-init is available [here](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/7355876847367b75485873987e1217f1e1fe6254/packages/sampleOS/02_upgrades.yaml#L41)

## Changing the default release channel

To change the default release channel, set a `/etc/luet/luet.yaml` configuration file pointing to a valid luet repository:

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
  - "quay.io/costoolkit/releases-opensuse"
```

An example on how to tweak this file via cloud-init is available [here](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/7355876847367b75485873987e1217f1e1fe6254/packages/sampleOS/02_upgrades.yaml#L11)