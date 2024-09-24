from subprocess import run, CompletedProcess
from argparse import ArgumentParser

def get_os() -> str:
    uname: CompletedProcess = run(['uname', '-s'], capture_output=True, text=True)
    uname_str: str = uname.stdout.strip()
    return uname_str


def get_distro_pkg(release_file_path: str = "/etc/os-release") -> str:
    file_exists = run(["[", "-f", release_file_path, "]"]).returncode
    print(f"file exists: {file_exists}")
    release_file_exists = True if file_exists == 0 else False
    distro_id = ''
    if release_file_exists:
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
        pkg_cmd = input("Please pass in your distro pkg manager installer (ex. for debian it's apt install): ")
        return pkg_cmd


def match_pkg_manager(distro_id):
    match distro_id:
        case 'ubuntu' | 'debian' | 'linuxmint':
            return "apt install"
        case 'fedora' | 'rhel' | 'amzn':
            return "dnf install"
        case 'arch' | 'manjaro':
            return "pacman -S"
        case 'nixos':
            return "nix-env -i"
        case _:
            pkg_cmd = input("Unknown distro. Please enter your command to install a package (i.e. apt install)")
            return pkg_cmd


def main():
    parser = ArgumentParser("Zsh Installer",
                            "Setup zsh with custom configs on mac and linux",
                            "Type -h or --help for this menu")
    parser.add_argument('-i', '--install')
    parser.add_argument('-rf', '--release-file',
                        required=False, default='/etc/os-release')
    args = parser.parse_args()
    os_val = get_os()
    os_val = "MacOS" if (os_val == "Darwin") else os_val
    print(f"{os_val} detected!")
    install_cmd: str = get_distro_pkg(args.release_file) if os_val == "Linux" else "brew install"
    install_cmd = get_distro_pkg(args.release_file)
    print(f"install_cmd: {install_cmd}")
    print(f"Installing using: {install_cmd.split(' ')[0]}")


main()
