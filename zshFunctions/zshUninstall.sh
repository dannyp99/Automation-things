#!/bin/bash

## TODO
# Determine dependencies for install (ripgrep, fzf, git, bat)

DRY_RUN=0
VALID_ARGS=$(getopt -o diru --long dry-run:,distro:,install,release-file:,uninstall -- "$@")
if [[ $? -ne 0 ]];then
    exit 1
fi

OS=""
DISTRO_ID=""
INSTALL_CMD=""
RELEASE_FILE=""
ZSH_DEPENDENCIES=("git" "ripgrep" "bat")

function help_function() {
    echo " "
    echo ""
    echo ""
    echo ""
    echo ""
}

function handle_args() {
    eval set -- "$VALID_ARGS"
    while true; do
        case "$1" in
            --dry-run)
                DRY_RUN="$2"
                echo "dry-run set to $DRY_RUN"
                shift 2
                ;;
            -d | --distro)
                DISTRO_ID="$2"
                echo "distro set to $DISTRO_ID"
                shift 2
                ;;
            -i | --install)
                echo "Installing zsh custom configurations"
                INSTALL=true
                shift
                ;;
            -r | --release-file)
                RELEASE_FILE="$2"
                echo "release-file set to $RELEASE_FILE"
                shift 2
                ;;
            -u | --uninstall)
                INSTALL=false
                echo "Uninstalling zsh custom configurations"
                shift
                ;;
            --) shift;
                break
                ;;
        esac
    done
}

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
    if [[ -z "$RELEASE_FILE" ]] && [[ -d "$RELEASE_FILE" ]];then
        # shellcheck source=/etc/os-release
        source "$(RELEASE_FILE)/os-release"
        DISTRO_ID="$ID"
    elif [[ -f /etc/os-release ]];then
        echo "release info not found in $RELEASE_FILE"
        echo "Defaulting to /etc/os-release"
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
            INSTALL_CMD=("apt" "install" "uninstall");;
        "fedora"|"rhel"|"amzn")
            INSTALL_CMD=("dnf" "install" "uninstall");;
        "arch"|"manjaro")
            INSTALL_CMD=("pacman" "-S" "-Rcns");;
        "nixos")
            INSTALL_CMD=("nix-env" "i" "");; # [[ -z var ]]
        "Other"|*)
            INSTALL_CMD=()
            echo "Unkown package manager Please enter your package manager install and uninstall commands"
            echo "Example for debian based systems: apt install uninstall --purge "
            read -r -p "What is the package manager you are using: " PKG_MNGR && INSTALL_CMD+=("$PKG_MNGR");
            read -r -p "What is the command for $PKG_MNGR to install: " INSTALL && INSTALL_CMD+=("$INSTALL");
            read -r -p "What is the command to uninstall for $PKG_MNGR: " UNINSTALL && INSTALL_CMD+=("$UNINSTALL");
            
    esac
}

function remove_omz() {
    if [[ -d "$HOME/.oh-my-zsh" ]];then
        read -r -p "Remove oh-my-zsh? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] ||  return;
        rm -rf "$HOME/.oh-my-zsh"
    else 
        echo "oh-my-zsh is already deleted"
    fi
}

function handle_install() {
    end_idx=2
    if [[ $DRY_RUN -eq 1 ]];then
        INSTALL_CMD=("echo " "${INSTALL_CMD[@]}")
        ((end_idx++))
    fi
    echo "Installing dependencies...."
    eval "sudo ${INSTALL_CMD[*]:0:$end_idx} ${ZSH_DEPENDENCIES[*]}"
    if [[ ! -d "$HOME/.fzf/" ]];then
        echo "Install FZF from Source"
        eval "git clone https://github.com/junegunn/fzf.git $HOME/.fzf"
    else
        echo "FZF already installed"
    fi
    if [[ -n $(which zsh) ]];then
        echo "ZSH already installed"
    else
        eval "sudo ${INSTALL_CMD[0]} ${INSTALL_CMD[1]} zsh"
    fi
}

function handle_plugins() {
    echo "handle_plugins"
}

handle_args "$@"
if [[ -n "$DISTRO_ID" ]];then
    get_pkg_mngr
    exit 0
else
    get_os
    echo "Detected: $OS"
    if [[ "$OS" == "Linux" ]];then
        get_distro
        echo "Detected your Distro as: $DISTRO_ID"
    else
        echo "MacOS detected using homebrew...."
        INSTALL_CMD=("brew" "install" "uninstall")
    fi
    echo "Install Commands are: ${INSTALL_CMD[*]}"
    handle_install
fi
