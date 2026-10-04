#!/bin/sh

set -e

# Check the course's binary installation prerequisites before changing the system.
if [ ! -r /etc/os-release ]; then
    echo "This course installer requires Ubuntu 22.04 (Jammy)." >&2
    exit 1
fi
. /etc/os-release

if [ "${ID:-}" != "ubuntu" ] || [ "${VERSION_ID:-}" != "22.04" ]; then
    echo "This course installer requires Ubuntu 22.04 (Jammy)." >&2
    exit 1
fi

architecture=$(dpkg --print-architecture)
if [ "$architecture" != "amd64" ]; then
    echo "Detected architecture: $architecture. This course requires amd64 (Intel/AMD 64-bit)." >&2
    echo "The Ubuntu 22.04 Gazebo Classic and ROS Gazebo binary packages used by the labs are available only for amd64." >&2
    echo "ROS 2 Humble itself can run on ARM64; this restriction is specific to the course's Gazebo Classic installation." >&2
    echo "Keep your current VM and use an Intel/AMD Ubuntu 22.04 lab machine or connect to one through remote desktop." >&2
    echo "No installation changes have been made." >&2
    exit 1
fi

echo "....installing ros2 humble...."

sleep 2

sudo apt update
sudo apt install -y git wget vim build-essential
sudo apt install -y lsb-core lsb-release
sudo apt-get install -y net-tools iputils-ping

sleep 1

sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

export LANG=en_US.UTF-8

locale
echo "--------------------------------"
echo "....locales configs successful!...."
echo "--------------------------------"

sudo apt install -y software-properties-common
sudo add-apt-repository --yes universe


sudo apt update && sudo apt install curl -y

sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update

sudo apt install -y ros-humble-desktop

echo "--------------------------------"
echo "....ros successfully installed...."
echo "--------------------------------"

sleep 1

sudo apt install -y ros-dev-tools


ros_bashrc_line="source /opt/ros/humble/setup.bash"

if ! grep -qF "$ros_bashrc_line" /home/$USER/.bashrc ; then echo "$ros_bashrc_line" >> /home/$USER/.bashrc ; fi

tb3_bashrc_line="export TURTLEBOT3_MODEL=burger"

if ! grep -qF "$tb3_bashrc_line" /home/$USER/.bashrc ; then echo "$tb3_bashrc_line" >> /home/$USER/.bashrc ; fi

echo "--------------------------------"
echo "....ros env successfully set!...."
echo "--------------------------------"

sleep 1


# Simulation uses the ROS packages below and default DDS discovery.
# No external robot networking profile is required.
sudo apt install -y ros-humble-rmw-fastrtps-cpp

sleep 1

sudo apt install -y ros-humble-turtlebot4-desktop

sleep 1

sudo apt install -y gazebo ros-humble-gazebo-ros-pkgs ros-humble-turtlebot3 ros-humble-turtlebot3-gazebo

if ! command -v gazebo > /dev/null 2>&1; then
    echo "Installation verification failed: gazebo is not on PATH." >&2
    exit 1
fi

for setup_file in /usr/share/gazebo/setup.sh /opt/ros/humble/setup.sh; do
    if [ ! -r "$setup_file" ]; then
        echo "Installation verification failed: missing or unreadable $setup_file." >&2
        exit 1
    fi
done

. /opt/ros/humble/setup.sh

for package in turtlebot3_gazebo gazebo_ros turtlebot4_desktop; do
    if ! ros2 pkg prefix "$package"; then
        echo "Installation verification failed: ROS package $package is not discoverable." >&2
        exit 1
    fi
done

tb3_prefix=$(ros2 pkg prefix turtlebot3_gazebo)
if [ ! -f "$tb3_prefix/share/turtlebot3_gazebo/launch/turtlebot3_house.launch.py" ]; then
    echo "Installation verification failed: TurtleBot3 house launch file is missing." >&2
    exit 1
fi

echo "--------------------------------"
echo "Required ROS and Gazebo Classic packages verified."
echo "--------------------------------"
echo "Run 'source ~/.bashrc' in your terminal to activate the ROS environment."

