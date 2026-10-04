# ROS 2 setup for DASE7505

Run these commands in a Bash terminal inside **Ubuntu 22.04 (Jammy) on amd64 (Intel/AMD 64-bit)**, including an Ubuntu 22.04 amd64 virtual machine. The installer sets up ROS 2 Humble, ROS development tools, Fast DDS, TurtleBot4 desktop packages, Gazebo Classic, and the TurtleBot3 packages required by the simulation labs. No Waterloo account or external `.fastdds.xml` file is required.

## Check your architecture first

Inside Ubuntu, run:

```bash
dpkg --print-architecture
```

Continue with this installer only if the result is `amd64`. The [official Gazebo Classic installation guide](https://get.gazebosim.org/tutorials?tut=install_ubuntu) explains that the Ubuntu 22.04 Gazebo Classic binaries and the ROS Gazebo packages that depend on them are available only for amd64 in the standard repositories. ROS 2 Humble itself can run on ARM64; the restriction here concerns the course's Gazebo Classic package installation.

If the result is `arm64`, **keep your current VM and use an Intel/AMD Ubuntu 22.04 lab machine, or connect to one through remote desktop**. Run the installation and simulation commands on that machine. This is the course route for ARM64 students; reinstalling packages in the same ARM64 VM will not provide the required amd64 binaries. The script checks both Ubuntu version and architecture before making installation changes.

## First installation

```bash
sudo apt update &&
sudo apt install -y git &&
git clone https://github.com/SAS-HKU/DASE7505_student.git &&
cd DASE7505_student &&
git checkout setup &&
bash setup_dase7505.sh &&
source ~/.bashrc
```

Run the script as your normal Ubuntu user; it requests `sudo` when needed. Installation downloads many packages and can take some time. The `&&` separators stop the sequence if a command fails.

## Update an existing checkout and retry

Open a terminal in your existing `DASE7505_student` folder, then run:

```bash
git fetch origin &&
git checkout setup &&
git pull --ff-only origin setup &&
bash setup_dase7505.sh &&
source ~/.bashrc
```

If Git reports local changes or another error, resolve that error before running the installer. Do not discard coursework to force an update.

An older installer may ask for a username at `git.uwaterloo.ca`, or stop with `cp: cannot stat .../robohub/turtlebot4/configs/.fastdds.xml`. Press **Ctrl+C** if it is waiting for credentials, then use the update-and-retry commands above. The updated script removes both the Waterloo clone and the copy operation. Installed APT packages are retained; neither Ubuntu reinstallation nor a Waterloo login is necessary. A previous `robohub` folder can be left in place.

## Check the installation

After installation, run:

```bash
command -v gazebo &&
test -r /usr/share/gazebo/setup.sh &&
source /opt/ros/humble/setup.bash &&
ros2 pkg prefix turtlebot3_gazebo &&
ros2 pkg prefix gazebo_ros &&
ros2 pkg prefix turtlebot4_desktop &&
test -f "$(ros2 pkg prefix turtlebot3_gazebo)/share/turtlebot3_gazebo/launch/turtlebot3_house.launch.py"
```

The command and package checks should print installation paths; each `test` succeeds silently. The installer performs these checks before printing `Required ROS and Gazebo Classic packages verified.` It installs `gazebo`, `ros-humble-gazebo-ros-pkgs`, `ros-humble-turtlebot3`, and `ros-humble-turtlebot3-gazebo` explicitly. The script also sets `TURTLEBOT3_MODEL=burger` in `~/.bashrc`. These checks confirm the required files and packages are available; they do not test a running simulation or graphics support.

## Step 16: launch the TurtleBot3 house simulation

On the supported lab machine or in its remote desktop session, run:

```bash
source /opt/ros/humble/setup.bash &&
source /usr/share/gazebo/setup.sh &&
export TURTLEBOT3_MODEL=burger &&
ros2 launch turtlebot3_gazebo turtlebot3_house.launch.py
```

Gazebo should open the house world with the robot. Use **Ctrl+C** in the terminal to stop the simulation. This GUI check is separate from the installer's package verification.

## Optional TurtleBot4 simulation

`ros-humble-turtlebot4-desktop` contains desktop tools; it does not install the TurtleBot4 simulator. The course installer retains the TurtleBot3 simulation package set. If an exercise specifically uses TurtleBot4 simulation, follow the **Humble / Ubuntu 22.04** sections of the [official TurtleBot4 simulator guide](https://turtlebot.github.io/turtlebot4-user-manual/software/turtlebot4_simulator.html), including Ignition Fortress and the `ros-humble-turtlebot4-simulator` and `ros-humble-irobot-create-nodes` packages.
