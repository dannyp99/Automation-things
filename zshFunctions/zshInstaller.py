from subprocess import run, CompletedProcess
from argparse import ArgumentParser
from pathlib import Path


def cmd_dryrun(dry_run: bool, cmd: list):
    if dry_run:
        print("".join(cmd))
    else:
        run(cmd)


def get_os() -> str:
    uname: CompletedProcess = run(['uname', '-s'],
                                  capture_output=True, text=True)
    uname_str: str = uname.stdout.strip()
    return uname_str


def file_exists(file_path: str) -> bool:
    requested_file = Path(file_path)
    return requested_file.exists()


def get_distro_pkg(release_file_path: str) -> str:
    file_path_exists = file_exists(release_file_path)
    print(f"file exists: {file_exists}")
    distro_id = ''
    if file_path_exists:
        print(f"file found: {release_file_path}")
        with open(release_file_path) as release_file:
            lines = [line.rstrip() for line in release_file]
            id_dict: dict(str) = {line.split('=')[0]: line.split('=')[1] for line in lines}
            print(id_dict)
            distro_id = id_dict['ID']
            print(distro_id)
            return match_pkg_manager(distro_id)
    else:
        print("Failed to detect os-release file!")
        pkg_cmd = input("Please pass in your distro pkg manager install and uninstall (ex. for debian it's apt install uninstall): ")
        return pkg_cmd


def match_pkg_manager(distro_id) -> list:
    match distro_id:
        case 'ubuntu' | 'debian' | 'linuxmint':
            return ['apt', 'install', 'uninstall --purge']
        case 'fedora' | 'rhel' | 'amzn':
            return ['dnf', 'install', 'uninstall']
        case 'arch' | 'manjaro':
            return ['pacman', '-S', '-Rcns']
        case 'nixos':
            return ['nix-env', '-i', None]
        case _:
            pkg_cmd = input("Unknown distro. Please enter your command to install a package (i.e. apt install)")
            return pkg_cmd


def omz_install():
    print("oh_my_zsh")
    run(["bash", "-c", "\"$(curl", "-fsSL",
        "https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""])


def install_zsh(pkg_cmd: list, dry_run: bool):
    print("Checking if zsh is installed")
    zsh_installed = file_exists('/usr/bin/zsh') or file_exists('/bin/zsh')
    if (zsh_installed):
        print('zsh already installed')
    else:
        print('Installing ZSH')
        cmd_dryrun(dry_run, ["sudo", pkg_cmd[0], pkg_cmd[1], "zsh"])
    install_omz = input("Would you like to install zsh: (y/n) ")
    if install_omz == 'y':
        omz_install()
    else:
        exit(0)


def main():
    DRY_RUN = False
    parser = ArgumentParser("Zsh Installer",
                            "Setup zsh with custom configs on mac and linux",
                            "Type -h or --help for this menu")
    parser.add_argument('action', help='option to install or remove zsh with configs',
                        choices=['install', 'remove'])
    parser.add_argument('-r', '--release-file', help='Option to reference release file with distro info',
                        required=False, default='/etc/os-release', type=str)
    parser.add_argument('-d', '--dry-run', help='option to see the commands being run without running them. Treat as a debug',
                        choices=[True, False], required=False, type=bool)
    args = parser.parse_args()
    print(f"Args:{args}")
    DRY_RUN = args.dry_run

    os_val = get_os()
    os_val = "MacOS" if (os_val == "Darwin") else os_val
    print(f"{os_val} detected!")
    pkg_cmd: str = get_distro_pkg(args.release_file) if os_val == "Linux" else ['brew', 'install', 'remove']
    print(f"pkg_cmd: {pkg_cmd}")
    pkg_mngr = pkg_cmd[0]
    install_cmd = pkg_cmd[1]
    remove_cmd = pkg_cmd[2]
    print(f"Will run commands with {pkg_mngr}")
    if args.action == 'install':
        install_zsh(pkg_cmd, DRY_RUN)
    elif args.action == 'remove':
        print("remove to be implemented")

main()
