---
title: "Build Google Cloud images"
linkTitle: "Build Google Cloud images"
weight: 4
date: 2017-01-05
description: >
  This section documents the procedure to deploy cOS images
  to Google Cloud provider from scratch.
---


Requirements:

* cOS-toolkit source
* Google Cloud access keys with the appropriate roles and permissions
* [gsutil](https://cloud.google.com/storage/docs/gsutil) and [gcloud](https://cloud.google.com/sdk) tools

The suggested approach high level view is building cOS packages and generating a RAW image from
them. That would allow us to transform that RAW image in a valid Google Cloud blob that can be transformed into a VM image ready
to be launched.

This generates a `vanilla` image that boots into [recovery mode](../../getting-started/recovery) and can be used to deploy
whatever image you want to the VM. Then you can snapshot that VM into a VM image ready to deploy with the default cOS
system or your derivative.

## Building the packages

We need to have the packages built locally in order to generate a proper RAW image. Just run:

```bash
sudo make build
```

All the artifacts will be generated under the `build` directory.


See also the [dedicated section in the docs](../../development/) for more information about building cOS.

## Building the RAW image

The RAW image is just a RAW disk image that contains the recovery, so once launched is ready to be used for installing
whatever cOS or derivative that you want into the VM disks. This allows us to have a barebones base image that can be
used for provisioning whatever cOS you want.

Building the RAW image is as simple as running:

```bash
sudo make raw_disk
```

This will output a `disk.raw` fiel in the current directory which we will modify to make it work with Google Cloud.

{{% info %}}You can use this `disk.raw` locally as a disk for qemu if you want to check that it boots properly.{{% /info %}}

## Transform the RAW image into a compatible Google Cloud blob

Currently importing images from storage blobs on Google Cloud have a [few requirements](https://cloud.google.com/compute/docs/import/import-existing-image#requirements_for_the_image_file):

 - blobs have to be tar.gzipped with the flag `--format=oldgnu`
 - the disk.raw has to be rounded up to the next Gb ( so no 2.1gb images or 2.4, they need to be an exact 3Gb or 2Gb)
 - image inside the tar.gzip blob needs to be called disk.raw

We provide a make target that will do this for you:

```bash
sudo make gce_disk
```

This will create a `disk.raw.tar.gz` which is our final artifact

### Uploading to Google Cloud storage and importing it as an image

The last step is to upload the blob to Google Cloud storage and import that blob as a valid image.

With [gsutil](https://cloud.google.com/storage/docs/gsutil) and [gcloud](https://cloud.google.com/sdk) tools installed
and their credentials configured, you upload the blob with:

```bash
gsutil cp disk.raw.tar.gz gs://YOURBUCKET/
```

Where YOURBUCKET is the destination bucket you want your file to end up in.

And import it as an image with:

```bash
gcloud compute images create IMAGENAME --source-uri=SOURCEURI --guest-os-features=UEFI_COMPATIBLE
```

Where:
 - IMAGENAME: The name for the final image
 - SOURCEURI: The full Google Cloud Storage URI where the disk image is stored.
   This file must be a gzip-compressed tarball whose name ends in
   .tar.gz.
   This is the full path to the blob we just uploaded.
   
Note that we used `--guest-os-features=UEFI_COMPATIBLE` as a flag. This indicates that the image will be booted with UEFI
and its required. Otherwise, launching the image will try to boot it in legacy mode and it will fail.


Once this is over you will have you cOS (or derivative) vanilla image ready for consumption.
You can see your new image by running:

```bash
gcloud compute images describe IMAGENAME
```
