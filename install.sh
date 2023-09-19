#!/bin/bash

extra_packages() {
  sudo apt install mpv git neofetch curl exa
}

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

  sudo ./tweaks.sh -g -f monterey

  if [ $? -ne 0 ]; then
    echo "Error: Failed to apply WhiteSur GTK Theme tweaks. Exiting."
    exit 1
  fi
  
  sudo flatpak override --filesystem=xdg-config/gtk-4.0
  cd ..
  # rm -rf WhiteSur-gtk-theme
  echo "WhiteSur GTK Theme has been installed."
}

setup_hyprland() {
  while true; do
    clear
    echo "Set up Hyprland with rofi, waybar and more"
    echo "1. Add current user to the sudoers list"
    echo "2. Install required packages"
    echo "3. Install Hyprland"
    echo "4. Build and Install waybar"
    echo "5. Copy my config files"
    echo "6. Back"

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
        sudo apt-get install -y meson wget build-essential ninja-build cmake-extras cmake gettext gettext-base fontconfig libfontconfig-dev libffi-dev libxml2-dev libdrm-dev libxkbcommon-x11-dev libxkbregistry-dev libxkbcommon-dev libpixman-1-dev libudev-dev libseat-dev seatd libxcb-dri3-dev libvulkan-dev libvulkan-volk-dev  vulkan-validationlayers-dev libvkfft-dev libgulkan-dev libegl-dev libgles2 libegl1-mesa-dev glslang-tools libinput-bin libinput-dev libxcb-composite0-dev libavutil-dev libavcodec-dev libavformat-dev libxcb-ewmh2 libxcb-ewmh-dev libxcb-present-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-res0-dev libxcb-xinput-dev xdg-desktop-portal-wlr hwdata check libgtk-3-dev libsystemd-dev xwayland pamixer gsimplecal cava rofi brightnessctl alacritty kitty dunst pulsemixer playerctl swaybg
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
        sudo apt install -y clang-tidy gobject-introspection libdbusmenu-gtk3-dev libevdev-dev libfmt-dev libgirepository1.0-dev libgtk-3-dev libgtkmm-3.0-dev libinput-dev libjsoncpp-dev libmpdclient-dev libnl-3-dev libnl-genl-3-dev libpulse-dev libsigc++-2.0-dev libspdlog-dev libwayland-dev scdoc upower libxkbregistry-dev cava
        git clone https://github.com/Alexays/Waybar
        cd Waybar
        meson build
        ninja -C build
        ninja -C build install
        cd ..
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      5)
        cp -r config/* ~/.config/
        cp -r wallpapers/* ~/Pictures/
        CURRENT_USER=$(whoami)
        sudo gpasswd -a $CURRENT_USER video
        sudo cp backup/90-brightnessctl.rules /usr/lib/udev/rules.d/
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      6)
        break  # Return to the Main Menu
        ;;
      *)
        echo "Invalid choice. Please try again."
        ;;
    esac
  done
}

install_flatpak() {
  sudo apt install flatpak -y
  sudo apt install gnome-software-plugin-flatpak -y
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install_nvim() {
  wget https://github.com/neovim/neovim-releases/releases/download/nightly/nvim-linux64.deb
  sudo apt install ./nvim-linux64.deb
  sudo apt install python3.11-venv
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
}

# Main menu
while true; do
  clear
  echo "Main Menu:"
  echo "1. Install Extra Packages"
  echo "2. Install zsh and setup oh-my-zsh"
  echo "3. Install WhiteSur GTK Theme"
  echo "4. Set up Hyprland"
  echo "5. Install Flatpak"
  echo "6. Install NeoVim and NvChad"
  echo "7. Exit"
    
  read -p "Enter your choice: " main_choice
    
  case $main_choice in
    1)
      extra_packages
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    2)
      setup_zsh
      ;;
    3)
      whitesur_theme
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    4)
      setup_hyprland
      ;;
    5)
      install_flatpak
      echo "REBOOT IS REQUIRED."
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    6)
      install_nvim
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    7)
      echo "Exiting the program."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
