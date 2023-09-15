#!/bin/bash

# Function to set up Zsh and install Oh-My-Zsh
setup_zsh() {
  while true; do
    clear
    echo "Install zsh and oh-my-zsh"
    echo "1. Install zsh"
    echo "2. Install oh-my-zsh [log out and log in again after this step]"
    echo "3. Install my .zshrc config file"
    echo "4. Back"

    read -p "Enter your choice: " sub_choice

    case $sub_choice in
      1)
        sudo apt update
        sudo apt install -y zsh curl git

        if [ $? -ne 0 ]; then
          echo "Error: Failed to install Zsh and Oh My Zsh. Exiting."
          exit 1
        fi

        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      2)
        # Add code for Sub-option 2 here
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

        # Change the default shell to Zsh
        chsh -s $(which zsh)

        if [ $? -ne 0 ]; then
          echo "Error: Failed to change the default shell to Zsh. Exiting."
          exit 1
        fi

        echo "Zsh has been set up. Please log out and log in again to use Zsh as your default shell."
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      3)
        cp backup/.zshrc ~/.zshrc
        if [ $? -ne 0 ]; then
          echo "Error: Failed to copy .zshrc. Exiting."
          exit 1
        fi

        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        cp oh-my-zsh/anup.zsh-theme ~/.oh-my-zsh/themes/

        if [ $? -ne 0 ]; then
          echo "Error: Failed to copy additional Zsh files. Exiting."
          exit 1
        fi

        echo ".zshrc file has been copied to your home directory."

        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      4)
        break  # Return to the Main Menu
        ;;
      *)
        echo "Invalid choice. Please try again."
        ;;
    esac
  done
}

whitesur_theme() {
  echo "Installing WhiteSur GTK Theme..."
  sudo apt install gnome-tweaks gnome-shell-extension-manager
  git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
  cd WhiteSur-gtk-theme

  if [ $? -ne 0 ]; then
    echo "Error: Failed to clone WhiteSur GTK Theme repository. Exiting."
    exit 1
  fi

  ./install.sh -m -t all -N glassy -l --round -i ubuntu --normal

  if [ $? -ne 0 ]; then
    echo "Error: Failed to install WhiteSur GTK Theme. Exiting."
    exit 1
  fi

  sudo ./tweaks.sh -g

  if [ $? -ne 0 ]; then
    echo "Error: Failed to apply WhiteSur GTK Theme tweaks. Exiting."
    exit 1
  fi

  cd ..
  rm -rf WhiteSur-gtk-theme
  echo "WhiteSur GTK Theme has been installed."
}

setup_hyprland() {
  while true; do
    clear
    echo "Set up Hyprland with rofi, waybar and more"
    echo "1. Add current user to the sudoers list"
    echo "2. Install required packages"
    echo "3. Install Hyprland"
    echo "4. Copy my config files"
    echo "5. Back"

    read -p "Enter your choice: " sub_choice

    case $sub_choice in
      1)
        # Detect the current username
        CURRENT_USER=$(whoami)

        # Check if the user is already in the sudoers file
        if sudo grep -q "$CURRENT_USER" /etc/sudoers; then
          echo "User $CURRENT_USER is already in the sudoers file."
        else
          # Add the user to the sudoers file
          echo "$CURRENT_USER   ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
          echo "User $CURRENT_USER added to the sudoers file."
        fi
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      2)
        sudo apt-get install -y meson wget build-essential ninja-build cmake-extras cmake gettext gettext-base fontconfig libfontconfig-dev libffi-dev libxml2-dev libdrm-dev libxkbcommon-x11-dev libxkbregistry-dev libxkbcommon-dev libpixman-1-dev libudev-dev libseat-dev seatd libxcb-dri3-dev libvulkan-dev libvulkan-volk-dev  vulkan-validationlayers-dev libvkfft-dev libgulkan-dev libegl-dev libgles2 libegl1-mesa-dev glslang-tools libinput-bin libinput-dev libxcb-composite0-dev libavutil-dev libavcodec-dev libavformat-dev libxcb-ewmh2 libxcb-ewmh-dev libxcb-present-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-res0-dev libxcb-xinput-dev xdg-desktop-portal-wlr hwdata check libgtk-3-dev libsystemd-dev xwayland pamixer gsimplecal cava rofi waybar brightnessctl alacritty
        cd backup
        sudo cp 90-brightnessctl.rules /usr/lib/udev/rules.d/ 
        cd ..
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      3)
        mkdir hyprland-files
        cd hyprland-files
        wget https://github.com/hyprwm/Hyprland/releases/download/v0.29.1/source-v0.29.1.tar.gz
        tar -xvf source-v0.29.1.tar.gz

        wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.32/downloads/wayland-protocols-1.32.tar.xz
        tar -xvf wayland-protocols-1.32.tar.xz

        wget https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.22.0/downloads/wayland-1.22.0.tar.xz
        tar -xvf wayland-1.22.0.tar.xz

        wget https://gitlab.freedesktop.org/emersion/libdisplay-info/-/releases/0.1.1/downloads/libdisplay-info-0.1.1.tar.xz
        tar -xvf libdisplay-info-0.1.1.tar.xz

        git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
        git clone https://gitlab.freedesktop.org/libinput/libinput.git

        #Build and install wayland
        cd wayland-1.22.0
        mkdir build &&
        cd    build &&

        meson setup ..            \
            --prefix=/usr       \
            --buildtype=release \
            -Ddocumentation=false &&
        ninja
        sudo ninja install

        cd ../..
        
        #Build and install wayland-protocols
        cd wayland-protocols-1.32

        mkdir build &&
        cd    build &&

        meson setup --prefix=/usr --buildtype=release &&
        ninja

        sudo ninja install

        cd ../..

        sudo apt install edid-decode

        #Build and install libdisplay-info
        cd libdisplay-info-0.1.1/

        mkdir build &&
        cd    build &&

        meson setup --prefix=/usr --buildtype=release &&
        ninja

        sudo ninja install

        cd ../..

        #Build and install libliftoff
        cd libliftoff
        meson setup build/
        ninja -C build/
        cd build
        sudo ninja install
        cd ../..

        #Build and install libinput
        cd libinput
        sudo ln -s /usr/include/locale.h /usr/include/xlocale.h
        meson setup --prefix=/usr build/
        ninja -C build/
        sudo ninja -C build/ install
        cd ..

        #Build and install Hyprland
        sudo apt install libgbm-dev
        chmod a+rw hyprland-source
        cd hyprland-source/
        sudo make install
        cd ../..
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      4)
        cp config/* ~/.config/
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      5)
        break  # Return to the Main Menu
        ;;
      *)
        echo "Invalid choice. Please try again."
        ;;
    esac
  done
}

# Main menu
while true; do
  clear
  echo "Main Menu:"
  echo "1. Install zsh and setup oh-my-zsh"
  echo "2. Install WhiteSur GTK Theme"
  echo "3. Set up Hyprland"
  echo "4. Exit"
    
  read -p "Enter your choice: " main_choice
    
  case $main_choice in
    1)
      setup_zsh
      ;;
    2)
      whitesur_theme
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    3)
      # Add code for Option 3 here
      setup_hyprland
      ;;
    4)
      echo "Exiting the program."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
