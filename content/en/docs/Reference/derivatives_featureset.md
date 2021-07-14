---
title: "Derivatives featureset"
linkTitle: "Derivatives featureset"
weight: 3
date: 2021-01-05
description: >
  Features inherited by cOS derivatives that are also available in the cOS vanilla images
---


This document describes the shared featureset between derivatives that directly depend on `system/cos`.

Every derivative share a common configuration layer, along few packages by default in the stack.

## Package stack

When building a `cos-toolkit` derivative, a common set of packages are provided already with a common default configuration. Some of the most notably are:

- systemd as init system
- grub for boot loader
- dracut for initramfs

Each `cos-toolkit` flavor (opensuse, ubuntu, fedora) ships their own set of base packages depending on the distribution they are based against. You can find the list of packages in the `packages` keyword in the corresponding [values file for each flavor](https://github.com/rancher-sandbox/cOS-toolkit/tree/master/values)

## Login

By default you can login with the user `root` and `cos`.

You can change this by overriding `/system/oem/04_accounting.yaml` in the derivative spec file.

### Examples
- [Changing root password](https://github.com/rancher-sandbox/cos-toolkit-sample-repo/blob/00c0b4abf8225224c1c177f5b3bd818c7b091eaf/packages/sampleOS/build.yaml#L13)
- [Example accounting file](https://github.com/rancher-sandbox/epinio-appliance-demo-sample/blob/master/packages/epinioOS/04_accounting.yaml)

## Install

To install run `cos-installer <device>` to start the installation process. Remove the ISO and reboot.

_Note_: `cos-installer` supports other options as well. Run `cos-installer --help` to see a complete help.

## Upgrades

To upgrade an installed system, just run `cos-upgrade` and reboot.

cOS during installation sets two `.img` images files in the `COS_STATE` partition:
- `/cOS/active.img` labeled `COS_ACTIVE`: Where `cOS` typically boots from
- `/cOS/passive.img` labeled `COS_PASSIVE`: Where `cOS` boots for fallback

Those are used by the upgrade mechanism to prepare and install a pristine `cOS` each time an upgrade is attempted.

To specify a single docker image to upgrade to  instead of the regular upgrade channels, run `cos-upgrade --docker-image image`.

_Note_ by default `cos-upgrade --docker-image` checks images against the notary registry server for valid signatures for the images tag. To disable image verification, run `cos-upgrade --no-verify --docker-image`.

See the [sample repository](https://github.com/rancher-sandbox/cos-toolkit-sample-repo#system-upgrades) readme on how to tweak the upgrade channels for the derivative and [a further description is available here](https://github.com/rancher-sandbox/epinio-appliance-demo-sample#images)

## Reset state

cOS derivatives have a recovery mechanism built-in which can be leveraged to restore the system to a known point. At installation time, the recovery partition is created from the installation medium.

### Recovery partition

A derivative can be recovered anytime by booting into the ` recovery` partition and by running `cos-reset` from it. 

This command will regenerate the bootloader and the images in the `COS_STATE` partition by using the recovery image.

### Upgrading the recovery partition

The recovery partition can also be upgraded by running 

```bash
cos-upgrade --recovery
``` 

It also supports to specify docker images directly:

```bash
cos-upgrade --recovery --docker-image <image>
```

*Note*: the command has to be run in the standard partitions used for boot (Active or Fallback).

### From ISO
The ISO can be also used as a recovery medium: type `cos-upgrade` from a LiveCD. It will then try to upgrade the image of the active partition installed in the system.

## File system layout

![Partitioning layout](https://docs.google.com/drawings/d/e/2PACX-1vR-I5ZwwB5EjpsymUfcNADRTTKXrNMnlZHgD8RjDpzYhyYiz_JrWJwvpcfMcwfYet1oWCZVWH22aj1k/pub?w=533&h=443)

By default, `cos` derivative will inherit an immutable setup.
A running system will look like as follows:

```
/usr/local - persistent (COS_PERSISTENT)
/oem - persistent (COS_OEM)
/etc - ephemeral
/usr - read only
/ immutable
```

Any changes that are not specified by cloud-init are not persisting across reboots.



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

## Configuration reference

Below is a reference of all keys available in the cloud-init style files.

```yaml
stages:
   # "network" is the stage where network is expected to be up
   # It is called internally when network is available from 
   # the cos-setup-network unit.
   network:
     # Here there are a list of 
     # steps to be run in the network stage
     - name: "Some setup happening"
       files:
        - path: /tmp/foo
          content: |
                    test
          permissions: 0777
          owner: 1000
          group: 100
       commands:
        - echo "test"
       modules:
       - nvidia
       environment:
         FOO: "bar"
       systctl:
         debug.exception-trace: "0"
       hostname: "foo"
       systemctl:
         enable:
         - foo
         disable:
         - bar
         start:
         - baz
         mask:
         - foobar
       authorized_keys:
          user:
          - "github:mudler"
          - "ssh-rsa ...."
       dns:
         path: /etc/resolv.conf
         nameservers:
         - 8.8.8.8
       ensure_entities:
       -  path: /etc/passwd
          entity: |
                  kind: "user"
                  username: "foo"
                  password: "pass"
                  uid: 0
                  gid: 0
                  info: "Foo!"
                  homedir: "/home/foo"
                  shell: "/bin/bash"
       delete_entities:
       -  path: /etc/passwd
          entity: |
                  kind: "user"
                  username: "foo"
                  password: "pass"
                  uid: 0
                  gid: 0
                  info: "Foo!"
                  homedir: "/home/foo"
                  shell: "/bin/bash"
       datasource:
         providers:
         - "aws"
         - "digitalocean"
         path: "/etc/cloud-data"
```

The default cloud-config format is split into *stages* (*initramfs*, *boot*, *network*, *initramfs*, *reconcile*, called generically **STAGE_ID** below) that are emitted internally during the various phases by calling `cos-setup STAGE_ID` and *steps* (**STEP_NAME** below) defined for each stage that are executed in order.

Each cloud-config file is loaded and executed only at the apprioriate stage.

This allows further components to emit their own stages at the desired time.

### Compatibility with Cloud Init format

A subset of the official [cloud-config spec](http://cloudinit.readthedocs.org/en/latest/topics/format.html#cloud-config-data) is implemented. 

If a yaml file starts with `#cloud-config` it is parsed as a standard cloud-init and automatically associated it to the `boot` stage. For example:

```yaml
#cloud-config
users:
- name: "bar"
  passwd: "foo"
  groups: "users"
  ssh_authorized_keys:
  - faaapploo
ssh_authorized_keys:
  - asdd
runcmd:
- foo
hostname: "bar"
write_files:
- encoding: b64
  content: CiMgVGhpcyBmaWxlIGNvbnRyb2xzIHRoZSBzdGF0ZSBvZiBTRUxpbnV4
  path: /foo/bar
  permissions: "0644"
  owner: "bar"
```

Is executed at boot, by using the standard `cloud-config` format.

### `stages.STAGE_ID.STEP_NAME.name`

A description of the stage step. Used only when printing output to console.

### `stages.STAGE_ID.STEP_NAME.files`

A list of files to write to disk.

```yaml
stages:
   default:
     - files:
        - path: /tmp/bar
          content: |
                    #!/bin/sh
                    echo "test"
          permissions: 0777
          owner: 1000
          group: 100
```

### `stages.STAGE_ID.STEP_NAME.directories`

A list of directories to be created on disk. Runs before `files`.

```yaml
stages:
   default:
     - name: "Setup folders"
       directories:
       - path: "/etc/foo"
         permissions: 0600
         owner: 0
         group: 0
```

### `stages.STAGE_ID.STEP_NAME.dns`

A way to configure the `/etc/resolv.conf` file.

```yaml
stages:
   default:
     - name: "Setup dns"
       dns:
         nameservers:
         - 8.8.8.8
         - 1.1.1.1
         search:
         - foo.bar
         options:
         - ..
         path: "/etc/resolv.conf.bak"
```
### `stages.STAGE_ID.STEP_NAME.hostname`

A string representing the machine hostname. It sets it in the running system, updates `/etc/hostname` and adds the new hostname to `/etc/hosts`.

```yaml
stages:
   default:
     - name: "Setup hostname"
       hostname: "foo"
```
### `stages.STAGE_ID.STEP_NAME.sysctl`

Kernel configuration. It sets `/proc/sys/<key>` accordingly, similarly to `sysctl`.

```yaml
stages:
   default:
     - name: "Setup exception trace"
       systctl:
         debug.exception-trace: "0"
```

### `stages.STAGE_ID.STEP_NAME.authorized_keys`

A list of SSH authorized keys that should be added for each user.
SSH keys can be obtained from GitHub user accounts by using the format github:${USERNAME},  similarly for Gitlab with gitlab:${USERNAME}.

```yaml
stages:
   default:
     - name: "Setup exception trace"
       authorized_keys:
         mudler:
         - github:mudler
         - ssh-rsa: ...
```

### `stages.STAGE_ID.STEP_NAME.node`

If defined, the node hostname where this stage has to run, otherwise it skips the execution. The node can be also a regexp in the Golang format.

```yaml
stages:
   default:
     - name: "Setup logging"
       node: "bastion"
```

### `stages.STAGE_ID.STEP_NAME.users`

A map of users and user info to set. Passwords can be also encrypted.

The `users` parameter adds or modifies the specified list of users. Each user is an object which consists of the following fields. Each field is optional and of type string unless otherwise noted.
In case the user is already existing, the entry is ignored.

- **name**: Required. Login name of user
- **gecos**: GECOS comment of user
- **passwd**: Hash of the password to use for this user. Unencrypted strings are supported too.
- **homedir**: User's home directory. Defaults to /home/*name*
- **no-create-home**: Boolean. Skip home directory creation.
- **primary-group**: Default group for the user. Defaults to a new group created named after the user.
- **groups**: Add user to these additional groups
- **no-user-group**: Boolean. Skip default group creation.
- **ssh-authorized-keys**: List of public SSH keys to authorize for this user
- **system**: Create the user as a system user. No home directory will be created.
- **no-log-init**: Boolean. Skip initialization of lastlog and faillog databases.
- **shell**: User's login shell.

```yaml
stages:
   default:
     - name: "Setup users"
       users: 
          bastion: 
            passwd: "strongpassword"
            homedir: "/home/foo
```

### `stages.STAGE_ID.STEP_NAME.ensure_entities`

A `user` or a `group` in the [entity](https://github.com/mudler/entities) format to be configured in the system

```yaml
stages:
   default:
     - name: "Setup users"
       ensure_entities:
       -  path: /etc/passwd
          entity: |
                  kind: "user"
                  username: "foo"
                  password: "x"
                  uid: 0
                  gid: 0
                  info: "Foo!"
                  homedir: "/home/foo"
                  shell: "/bin/bash"
```
### `stages.STAGE_ID.STEP_NAME.delete_entities`

A `user` or a `group` in the [entity](https://github.com/mudler/entities) format to be pruned from the system

```yaml
stages:
   default:
     - name: "Setup users"
       delete_entities:
       -  path: /etc/passwd
          entity: |
                  kind: "user"
                  username: "foo"
                  password: "x"
                  uid: 0
                  gid: 0
                  info: "Foo!"
                  homedir: "/home/foo"
                  shell: "/bin/bash"
```
### `stages.STAGE_ID.STEP_NAME.modules`

A list of kernel modules to load.

```yaml
stages:
   default:
     - name: "Setup users"
       modules:
       - nvidia
```
### `stages.STAGE_ID.STEP_NAME.systemctl`

A list of systemd services to `enable`, `disable`, `mask` or `start`.

```yaml
stages:
   default:
     - name: "Setup users"
       systemctl:
         enable:
          - systemd-timesyncd
          - cronie
         mask:
          - purge-kernels
         disable:
          - crond
         start:
          - cronie
```
### `stages.STAGE_ID.STEP_NAME.environment`

A map of variables to write in `/etc/environment`, or otherwise specified in `environment_file`

```yaml
stages:
   default:
     - name: "Setup users"
       environment:
         FOO: "bar"
```
### `stages.STAGE_ID.STEP_NAME.environment_file`

A string to specify where to set the environment file

```yaml
stages:
   default:
     - name: "Setup users"
       environment_file: "/home/user/.envrc"
       environment:
         FOO: "bar"
```
### `stages.STAGE_ID.STEP_NAME.timesyncd`

Sets the `systemd-timesyncd` daemon file (`/etc/system/timesyncd.conf`) file accordingly. The documentation for `timesyncd` and all the options can be found [here](https://www.freedesktop.org/software/systemd/man/timesyncd.conf.html).

```yaml
stages:
   default:
     - name: "Setup NTP"
       systemctl:
         enable:
         - systemd-timesyncd
       timesyncd:
          NTP: "0.pool.org foo.pool.org"
          FallbackNTP: ""
          ...
```

### `stages.STAGE_ID.STEP_NAME.commands`

A list of arbitrary commands to run after file writes and directory creation.

```yaml
stages:
   default:
     - name: "Setup something"
       commands:
         - echo 1 > /bar
```

### `stages.STAGE_ID.STEP_NAME.datasource`

Sets to fetch user data from the specified cloud providers. It populates
provider specific data into `/run/config` folder and the custom user data
is stored into the provided path.


```yaml
stages:
   default:
     - name: "Fetch cloud provider's user data"
       datasource:
         providers:
         - "aws"
         - "digitalocean"
         path: "/etc/cloud-data"
```
