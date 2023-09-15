#!/bin/bash 

# Function to set up Zsh and install Oh-My-Zsh
setup_zsh() {
  echo "Setting up Zsh and installing oh-my-zsh..."
  
  # Install Zsh and Oh My Zsh
  sudo apt update
  sudo apt install -y zsh curl git
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
  # Change the default shell to Zsh
  chsh -s $(which zsh)
  
  echo "Zsh has been set up. Please log out and log in again to use Zsh as your default shell."

  # Ask the user if they want to copy .zshrc (default: yes)
  read -p "Do you want to copy my .zshrc configuration file to your system? (Y/n): " choice
  choice="${choice:-y}"  # Set to 'y' if user presses Enter
  choice=${choice,,}     # Convert to lowercase for case-insensitive check
  
  if [ "$choice" = "y" ]; then
    cp /backup/.zshrc ~/
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    cp /oh-my-zsh/anup.zsh-theme ~/.oh-my-zsh/themes/
    echo ".zshrc file has been copied to your home directory."
  else
    echo "Skipping .zshrc file copy."
  fi
}

# Display a menu and prompt for an option
PS3="Please select an option: "
options=("Install zsh and setup oh-my-zsh" "Create a file" "Quit")

select choice in "${options[@]}"; do
  case $REPLY in
    1) 
      option=1
      setup_zsh
      ;;
    2) 
      option=2
      read -p "Enter file name: " file_name
      if [ -z "$file_name" ]; then
        echo "File name cannot be empty. Exiting."
        exit 1
      fi
      touch "$file_name"
      echo "File '$file_name' created successfully."
      ;;
    3) 
      echo "Exiting."
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done
