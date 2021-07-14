
---
title: "Immutable File system layout"
linkTitle: "Immutable File system layout"
weight: 2
date: 2017-01-05
description: >
  cOS has an Immutable File system layout, let's dive in the internal structure of cOS and derivatives
---

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
