# Following line follows tutorial from ROS's noetic installation tuts (http://wiki.ros.org/noetic/Installation/Ubuntu)
# 1.2 Setup your sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# 1.3. Set up your keys
sudo apt -y install curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

# 1.4 Installation
sudo apt update
sudo apt -y install ros-noetic-ros-base

# 1.5 Env setup
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

# 1.6 Dependencies for building packages
sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
## 1.6.1 Initialize rosdep
sudo apt install -y python3-rosdep
sudo rosdep init
rosdep update

# Following line follows commands provided in GitHub (https://github.com/Akasasura/tutorials/blob/main/1.%20Installing%20ROS%2C%20MAVROS%2C%20and%20Ardupilot.md)
# 2. Setup catkin ws
sudo apt-get -y install python3-wstool python3-rosinstall-generator python3-catkin-tools
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin init

# 3. Clone ardupilot
cd ~
sudo apt install git
git clone https://github.com/ArduPilot/ardupilot.git

# 4. Install dependencies
cd ~/ardupilot
Tools/environment_install/install-prereqs-ubuntu.sh -y
. ~/.profile

# 5. Checkout latest copter build
git checkout Copter-4.2.3
git submodule update --init --recursive

# 8. Dependencies installation (such as mavros and mavlink)
cd ~/catkin_ws
wstool init ~/catkin_ws/src
rosinstall_generator --upstream mavros | tee /tmp/mavros.rosinstall
rosinstall_generator mavlink | tee -a /tmp/mavros.rosinstall
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro `echo $ROS_DISTRO` -y
catkin build
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo ~/catkin_ws/src/mavros/mavros/scripts/install_geographiclib_datasets.sh
