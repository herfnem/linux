#!/bin/bash

extra_packages() {
  while true; do
    clear
    echo "Extra Packages and Options"
    echo "1. Add current user to the sudoers list"
    echo "2. Install extra packages"
    echo "3. Install Pop Shell and Rounded Window Corners extensions"
    echo "4. Install archlinux with distrobox"
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
        sudo apt install -y mpv gimp htop git neofetch curl exa rofi nala libfuse2 gufw dconf-editor ntfs-3g build-essential alacritty
        sudo apt install -y tealdeer && tldr -u
        curl -fsSL https://bun.sh/install | bash
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      3)
        cd gnome_extensions
        gnome-extensions install rounded-window-corners@yilozt.shell-extension.zip
        gnome-extensions install pop-shell@system76.com.zip
        cd ..
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      4)
        sudo apt install podman -y
        curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
        distrobox create --nvidia --name archlinux --init --image quay.io/toolbx-images/archlinux-toolbox:latest
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
        cp oh-my-zsh/neko.zsh-theme ~/.oh-my-zsh/themes/

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
  echo "4. Install Flatpak"
  echo "5. Install NeoVim and NvChad"
  echo "6. Exit"
    
  read -p "Enter your choice: " main_choice
    
  case $main_choice in
    1)
      extra_packages
      ;;
    2)
      setup_zsh
      ;;
    3)
      whitesur_theme
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    4)
      install_flatpak
      echo "REBOOT IS REQUIRED."
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    5)
      install_nvim
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    6)
      echo "Exiting the program."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
