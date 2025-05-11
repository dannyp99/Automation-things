#!/bin/bash

## TODO
# Determine dependencies for install (ripgrep, fzf, git, bat)

DRY_RUN=1
VALID_ARGS=$(getopt -o dhru --long dry-run:,distro:,help,release-file:,uninstall -- "$@")
if [[ $? -ne 0 ]];then
    exit 1
fi

OS=""
DISTRO_ID=""
INSTALL_CMD=""
RELEASE_FILE=""
ZSH_DEPENDENCIES=("git" "ripgrep" "bat")

function help_function() {
    echo "--dry-run                                 Set to =0 to ensure commands are actually run and =1 for debugging"
    echo "-d, --distro <DISTRO_ID>                  Set the id of your linux distro"
    echo "-h, --help                                Print this help menu"
    echo "-r, --release-file <RELEASE_FILE_PATH>    Set the location of the release file. Defaults to /etc/os-release"
    echo "-u, --uninstall                           Use to uninstall zsh customization. System level packages that were installed via package manager are not removed"
    exit 0
}

function handle_args() {
    eval set -- "$VALID_ARGS"
    while true; do
        case "$1" in
            -h|--help)
                shift
                help_function
                ;;
            --dry-run)
                echo "dry-run set to $DRY_RUN"
                shift 2
                ;;
            -d)
                DISTRO_ID="$3"
                shift
                ;;
            --distro)
                DISTRO_ID="$2"
                shift 2
                ;;
            -r)
                RELEASE_FILE="$3"
                echo "release-file set to $RELEASE_FILE"
                shift
                ;;
            --release-file)
                RELEASE_FILE="$2"
                echo "release-file set to $RELEASE_FILE"
                shift 2
                ;;
            -u |--uninstall)
                echo "Uninstalling zsh custom configurations"
                shift
                remove_omz
                ;;
            --)
                shift;
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
        read -r -p "Remove oh-my-zsh? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || return;
        if [[ $DRY_RUN -eq 0 ]];then
            rm -rf "$HOME/.oh-my-zsh"
        else
            echo "dry-run: rm -rf $HOME/.oh-my-zsh"
        fi
    else 
        echo "oh-my-zsh is already deleted"
    fi
    get_distro
    get_pkg_mngr
    if [[ -n "${INSTALL_CMD[2]}" ]];then
        echo "If you wish to remove packages installed try running: sudo ${INSTALL_CMD[0]} ${INSTALL_CMD[2]} ${ZSH_DEPENDENCIES[*]} zsh"
        printf "You might also want to remove fzf with\n\trm -rf ~/.fzf\n"
    fi
    exit 0
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
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install"
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
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo "OMZ is already installed"
        return
    else
	    cp "$HOME/.zshrc" zshrc_backup
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        git clone https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        wget -O "$HOME/.oh-my-zsh/custom/themes/lambda-mod.zsh-theme" https://raw.githubusercontent.com/halfo/lambda-mod-zsh-theme/master/lambda-mod.zsh-theme
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
        git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin"
        cp ./zshrc ~/.zshrc
        # Commented out while an existing zsh file is being maintianed
        # sed 's/ZSH_THEME.*/ZSH_THEME="lambda-mod"/g' zshrc_backup | tr "%" "\n" > "$HOME/.zshrc"
        # sed -i 's/plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-zsh-plugin)/' "$HOME/.zshrc"
        # echo "FZF command configs"
        # echo "export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g \"!{**/node_modules/*,**/.git/*,**/target/*,**/build/*}\"'" >> "$HOME/.zshrc"
        # echo "export FZF_DEFAULT_OPTS='--preview \"batcat --style=numbers --color=always {}\" --preview-window right:50%:hidden:wrap --bind ctrl-/:toggle-preview'" >> "$HOME/.zshrc"
        # echo "export FZF_ALT_C_COMMAND='find -type d \( -path \"**/node_modules\" -prune -o -path \"**/.git\" -prune -o -path \"**/target\" -prune -o -path \"**/build\" \) -o -print'" >> "$HOME/.zshrc"
        # echo "[ -f ~/.fzf.zsh ] && source ~/.fzf/fzf.zsh" >> "$HOME/.zshrc"
    fi
}

handle_args "$@"
if [[ -n "$DISTRO_ID" ]];then
    get_pkg_mngr
    handle_install
    handle_plugins
    exit 0
else
    get_os
    echo "Detected: $OS"
    if [[ "$OS" == "Linux" ]];then
        get_distro
        echo "Detected your Distro as: $DISTRO_ID"
        get_pkg_mngr
    else
        echo "MacOS detected using homebrew...."
        INSTALL_CMD=("brew" "install" "uninstall")
    fi
    echo "Install Commands are: ${INSTALL_CMD[*]}"
    handle_install
    handle_plugins
fi
