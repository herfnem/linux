#!/bin/bash

extra_packages() {
  sudo pacman -S mpv git neofetch curl exa jasper lame libdca libdv gst-libav libtheora libvorbis libxv wavpack x264 xvidcore dvd+rw-tools dvdauthor dvgrab libmad libmpeg2 libdvdcss libdvdread libdvdnav exfat-utils fuse-exfat a52dec faac faad2 flac alacritty rofi ttf-font-awesome file-roller libreoffice-fresh thunderbird telegram-desktop discord power-profiles-daemon webp-pixbuf-loader base-devel clang libdbus gtk2 libnotify libgnome-keyring alsa-lib libcap libcups libxtst libxss nss gcc-multilib curl gperf bison python-dbusmock jdk8-openjdk dotnet-runtime dotnet-sdk aspnet-runtime --noconfirm
  cd Downloads
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  curl -fsSL https://bun.sh/install | bash
  yay -S nautilus-open-any-terminal
  gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
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
        sudo pacman -S zsh curl git --noconfirm

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
  sudo pacman -S gnome-tweaks --noconfirm
  git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
  cd WhiteSur-gtk-theme

  if [ $? -ne 0 ]; then
    echo "Error: Failed to clone WhiteSur GTK Theme repository. Exiting."
    exit 1
  fi

  ./install.sh -m -t all -N glassy -l --round -i arch --normal

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

install_nvim() {
  sudo pacman -S neovim --noconfirm
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
}

setup_aur() {
  cd Downloads
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
}

install_nvidia() {
  sudo pacman -S nvidia nvidia-utils nvidia-settings nvidia-prime power-profiles-daemon vulkan-tools
}

install_bluez() {
  sudo pacman -S bluez bluez-utils --noconfirm
  sudo systemctl start bluetooth.service
  sudo systemctl enable bluetooth.service
}

# Main menu
while true; do
  clear
  echo "Main Menu:"
  echo "1. Install Extra Packages"
  echo "2. Install zsh and setup oh-my-zsh"
  echo "3. Install WhiteSur GTK Theme"
  echo "4. Install AUR helper - yay"
  echo "5. Install NeoVim and NvChad"
  echo "6. Install Nvidia drivers only [no configuration]"
  echo "7. Install bluetooth drivers"
  echo "8. Exit"
    
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
      setup_aur
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    5)
      install_nvim
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    6)
      install_nvidia
      read -n 1 -s -r -p "Press any key to continue..."
      ;; 
    7)
      install_bluez
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
    8)
      echo "Exiting the program."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
