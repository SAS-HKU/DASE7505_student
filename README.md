# DASE7505 Intelligent Unmanned Systems (MSc course, starting 2025 Fall)
## Department of Data and Systems Engineering, The University of Hong Kong
## Course provided by HKU-SAS Lab

This repository contains the lab sheets and related resources for lab sessions available to students taking DASE7505, taught by Prof. Chen Sun (c87sun@hku.hk). <br />
In this repository, setup instructions and lab exercises are available in the `setup`, `labOne`, and `labTwo` branches. You may change the branch to the respective exercises and access the materials.

## ROS 2 installation

For Ubuntu 22.04 and ROS 2 Humble, follow the [installation and recovery instructions on the setup branch](https://github.com/SAS-HKU/DASE7505_student/tree/setup). The updated `setup_dase7505.sh` installs the simulation packages without a Waterloo account or external `.fastdds.xml` file.

If you already cloned this repository, run the following in its directory:

```bash
git fetch origin &&
git checkout setup &&
git pull --ff-only origin setup &&
bash setup_dase7505.sh &&
source ~/.bashrc
```

If a command fails, resolve that error before continuing. The setup guide includes the complete commands for a new installation and for retrying after an older installer stopped at the Waterloo step.

### This repo is under continuous updating. Any technical issues, bugs found, and constructive feedback, please contact via email to teaching assistant: peterwang.dase@connect.hku.hk
