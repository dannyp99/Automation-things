#!/bin/bash

OS=""
DISTRO_ID=""
INSTALL_CMD=""

function get_os() {
    unameOs="$(uname -s)"
    case "${unameOs}" in
        Linux*) machine="Linux";;
        Darwin*) machine="Mac";;
        *)  machine="Incompatible" && echo "OS not supported";;
    esac
    echo "Get OS result : $machine"
    OS="$machine";
}
# If it's Linux then we need to determine our package manager
function get_distro() {
    if [[ -f /etc/os-release ]];then
        source /etc/os-release
        DISTRO_ID="$ID"
    else
        echo "Can't detect your Linux distro!"
        DISTRO_ID="Other"
    fi
    get_pkg_mngr
}

function get_pkg_mngr() {
    INSTALL_CMD=()
    case "$DISTRO_ID" in
        "debian"|"ubuntu"|"linuxmint")
            INSTALL_CMD=("apt", "install", "uninstall");;
        "fedora"|"rhel"|"amzn")
            INSTALL_CMD=("dnf", "install", "uninstall");;
        "arch"|"manjaro")
            INSTALL_CMD=("pacman", "-S", "-Rcns");;
        "nixos")
            INSTALL_CMD=("nix-env", "i", "");; # [[ -z var ]]
        "Other"|*)
            INSTALL_CMD=()
            echo "Unkown package manager, Please enter your package manager install and uninstall commands"
            echo "Example for debian based systems: apt, install, uninstall --purge "
            read -p "What is the package manager you are using: " PKG_MNGR && INSTALL_CMD+=($PKG_MNGR);
            read -p "What is the command for $PKG_MNGR to install: " INSTALL && INSTALL_CMD+=($INSTALL);
            read -p "What is the command to uninstall for $PKG_MNGR: " UNINSTALL && INSTALL_CMD+=($UNINSTALL);
            
    esac
}

function remove_omz() {
    if [[ -d "$HOME/.oh-my-zsh" ]];then
        read -p "Remove oh-my-zsh? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] ||  return;
        rm -rf $HOME/.oh-my-zsh
    else 
        echo "oh-my-zsh is already deleted"
    fi
}
get_os
echo "Detected: $OS"
if [[ "$OS" == "Linux" ]];then
    get_distro
    echo "Detected your Distro as: $DISTRO_ID"
else
    echo "MacOS detected using homebrew...."
    PKG_MAN="brew"
fi
get_distro
echo "Install Commands are: ${INSTALL_CMD[@]}"
