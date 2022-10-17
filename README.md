## Build PYNQ SD Image for Pynq-ZU

### Prerequisites

**Required tools:**

* Ubuntu 18.04/20.04 LTS 64-bit host PC
* Passwordless SUDO privilege for the building user
* Roughly 35GB of free space (build process only, not accounting for Xilinx tools)
* At least 8GB of RAM (more is better)
* Xilinx PetaLinux 2022.1 and Vivado 2022.1

Retrieve the Pynq-ZU board git into a NEW directory.

```shell
git clone https://github.com/Xilinx/PYNQ-ZU.git <LOCAL_PYNQ-ZU_REPO>
```

### Build SD Image

PYNQ is a submodule and it points to the corresponding branch.

Configure and install build tools, this will take some effort and will be an iterative process. Install on your own any missing tools.

Inside the `<LOCAL_PYNQ-ZU_REPO>/` execute

```shell
cd pynq/sdbuild
make checkenv
```

In the root directory (`<LOCAL_PYNQ-ZU_REPO>/`) run `make`.

```shell
make 2>&1 | tee build.log
```

Once the build has completed, if successful a SD card image will be available under the directory `<LOCAL_PYNQ-ZU_REPO>/sdbuild/output/Pynq-ZU-3.0.0.img`.

Use Etcher or Win32DiskImager to write this image to an SD card. 

------------------------------------------------------
<p align="center">Copyright&copy; 2022 Xilinx</p>