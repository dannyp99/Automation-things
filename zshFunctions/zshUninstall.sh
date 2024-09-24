#!/bin/bash
_passback() { while [ 1 -lt $# ]; do printf '%q=%q;' "$1" "${!1}"; shift; done; return $1; }
passback() { _passback "$@" "$?"; }
_capture() { { out="$("${@:2}" 3<&-; "$2_" >&3)"; ret=$?; printf "%q=%q;" "$1" "$out"; } 3>&1; echo "(exit $ret)"; }
capture() { eval "$(_capture "$@")"; }

OS=""
DISTRO_ID=""
INSTALL_CMD=""

function get_os_() { passback OS }
function get_os() {
    unameOs="$(uname -s)"
    case "${unameOs}" in
        Linux*) machine="Linux";;
        Darwin*) machine="Mac";;
        *)  machine="Incompatible" && echo "OS not supported";;
    esac
    echo "Get OS result : $machine"
    "$OS"="$machine";
}
# If it's Linux then we need to determine our package manager
function get_distro_() { passback DISTRO_ID; }
function get_distro() {
    DISTRO_ID=""
    if [[ -f /etc/os-release ]];then
        source /etc/os-release
        DISTRO_ID="$ID"
    else
        echo "Can't detect your Linux distro!"
        DISTRO_ID="Other"
    fi
}

function_get_pkg_mngr_() { passback INSTALL_CMD }
function get_pkg_mngr() {
    DISTRO_ID="$1"
    INSTALL_CMD=""
    case "$DISTRO_ID" in
        "debian"|"ubuntu"|"linuxmint")
            INSTALL_CMD="apt install";;
        "fedora"|"rhel"|"amzn")
            INSTALL_CMD="dnf install";;
        "arch"|"manjaro")
            INSTALL_CMD="pacman -S";;
        "nixos")
            INSTALL_CMD="nix-env i";;
        "Other"|*)
            echo "Unkown package manager"
            read -p "Please enter your package manager install command" INSTALL_CMD;;
    esac
    return INSTALL_CMD;
}

function remove_omz() {
    if [[ -d "$HOME/.oh-my-zsh" ]];then
        read -p "Remove oh-my-zsh? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] ||  return;
        rm -rf $HOME/.oh-my-zsh
    else 
        echo "oh-my-zsh is already deleted"
    fi
}

echo "Detected: $OS"
if [[ "$OS" == "Linux" ]];then
    echo "Detected your Distro as: $DISTRO_ID"
else
    echo "MacOS detected using homebrew...."
    PKG_MAN="brew"
fi
