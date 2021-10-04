## Build PYNQ SD Image for Pynq-ZU

### Prerequisites

**Required tools:**
* Ubuntu 18.04/20.04 LTS 64-bit host PC
* Passwordless SUDO privilege for the building user
* Roughly 35GB of free space (build process only, not accounting for Xilinx tools)
* At least 8GB of RAM (more is better)
* Xilinx PetaLinux 2020.2 and Vivado 2020.2
* PYNQ main repo cloned locally

Retrieve the Pynq-ZU board git into a NEW directory somewhere outside the PYNQ git directory.

```shell
git clone https://github.com/Xilinx/PYNQ-ZU.git <LOCAL_PYNQ-ZU_REPO>
```

### Build SD Image

If you haven't already (it is one of the prerequisites above), retrieve the main PYNQ repo into a NEW directory somewhere **outside** the Pynq-ZU directory.
```shell
git clone https://github.com/Xilinx/PYNQ.git <LOCAL_PYNQ_REPO>
```

Setup PYNQ repo to work on branch `image_v2.7`.
```shell
cd <LOCAL_PYNQ_REPO>
git checkout origin/image_v2.7
```

Configure and install build tools, this will take some effort and will be an iterative process. Install on your own any missing tools.
```shell
cd sdbuild
make checkenv
```

In your PYNQ repository go to the directory `sdbuild` and run `make`.

```shell
make clean
make BOARDDIR=<LOCAL_PYNQ-ZU_REPO>
```

Once the build has completed, if successful an SD card image will be available under the PYNQ repo directory  `<LOCAL_PYNQ_REPO>/sdbuild/output/Pynq-ZU_v2.6.img`.

Use Etcher or Win32DiskImager to write this image to an SD card. 
