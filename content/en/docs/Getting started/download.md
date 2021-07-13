
---
title: "Download"
linkTitle: "Download"
weight: 1
date: 2017-01-05
description: >
  How to get cOS
---

cOS-toolkit releases consist on container images that can be used to build derived against and the cos source tree itself.

cOS supports different release channels, all the final and cache images used are tagged and pushed regularly [to Quay Container Registry](https://quay.io/repository/costoolkit/releases-opensuse) and can be pulled for inspection from the registry as well.

Those are exactly the same images used during upgrades, and can also be used to build Linux derivatives from cOS.

For example, if you want to see locally what's in a openSUSE cOS version , you can:

```bash
$ docker run -ti --rm quay.io/costoolkit/releases-opensuse:cos-system-$VERSION /bin/bash
```

## Releases
 
We are not releasing artifacts currently on tagging - the cOS CI generates ISO and images artifacts used for testing, so you can also try out cOS by downloading the 
artifact type you are interested into [from the Github Actions page](https://github.com/rancher-sandbox/cOS-toolkit/actions/workflows/build-master.yaml?query=is%3Asuccess) by picking the latest job. The artifacts are listed at the end of the workflow page.
