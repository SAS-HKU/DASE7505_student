# ROS 2 setup for DASE7505

Run these commands in a Bash terminal inside **Ubuntu 22.04 (Jammy)**, including an Ubuntu 22.04 virtual machine. The installer sets up ROS 2 Humble, ROS development tools, Fast DDS, TurtleBot4 desktop packages, and TurtleBot3 packages for the simulation labs. No Waterloo account or external `.fastdds.xml` file is required.

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
source ~/.bashrc &&
ros2 pkg prefix turtlebot3_gazebo &&
ros2 pkg prefix turtlebot4_desktop
```

Both package checks should print their installation paths. The script also sets `TURTLEBOT3_MODEL=burger` in `~/.bashrc`. These checks confirm the packages are discoverable; they do not test a running simulation or the virtual machine's graphics support.

## Optional TurtleBot4 simulation

`ros-humble-turtlebot4-desktop` contains desktop tools; it does not install the TurtleBot4 simulator. The course installer retains the TurtleBot3 simulation package set. If an exercise specifically uses TurtleBot4 simulation, follow the **Humble / Ubuntu 22.04** sections of the [official TurtleBot4 simulator guide](https://turtlebot.github.io/turtlebot4-user-manual/software/turtlebot4_simulator.html), including Ignition Fortress and the `ros-humble-turtlebot4-simulator` and `ros-humble-irobot-create-nodes` packages.
