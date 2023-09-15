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
        # Ask the user if they want to copy .zshrc (default: yes)
        read -p "Do you want to copy my .zshrc configuration file to your system? (Y/n): " choice
        choice="${choice:-y}"  # Set to 'y' if user presses Enter
        choice=${choice,,}     # Convert to lowercase for case-insensitive check

        if [ "$choice" = "y" ]; then
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
        else
          echo "Skipping .zshrc file copy."
        fi

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





  echo "Setting up Zsh and installing oh-my-zsh..."

  # Install Zsh and Oh My Zsh
  sudo apt update
  sudo apt install -y zsh curl git

  if [ $? -ne 0 ]; then
    echo "Error: Failed to install Zsh and Oh My Zsh. Exiting."
    exit 1
  fi

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Change the default shell to Zsh
  chsh -s $(which zsh)

  if [ $? -ne 0 ]; then
    echo "Error: Failed to change the default shell to Zsh. Exiting."
    exit 1
  fi

  echo "Zsh has been set up. Please log out and log in again to use Zsh as your default shell."

  # Ask the user if they want to copy .zshrc (default: yes)
  read -p "Do you want to copy my .zshrc configuration file to your system? (Y/n): " choice
  choice="${choice:-y}"  # Set to 'y' if user presses Enter
  choice=${choice,,}     # Convert to lowercase for case-insensitive check

  if [ "$choice" = "y" ]; then
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
  else
    echo "Skipping .zshrc file copy."
  fi
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
    echo "Submenu - Option 1:"
    echo "1. Sub-option 1"
    echo "2. Sub-option 2"
    echo "3. Back to Main Menu"

    read -p "Enter your choice: " sub_choice

    case $sub_choice in
      1)
        # Add code for Sub-option 1 here
        echo "You selected Sub-option 1"
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      2)
        # Add code for Sub-option 2 here
        echo "You selected Sub-option 2"
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
      3)
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
      read -n 1 -s -r -p "Press any key to continue..."
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
