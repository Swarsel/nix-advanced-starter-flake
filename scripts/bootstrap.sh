set -eo pipefail

target_config=""
target_user=""
git_repo=""
dotfile_dir=".dotfiles"
current_dir="$(pwd)"
function help_and_exit() {
    echo
    echo "Locally installs starter flake on this machine."
    echo
    echo "USAGE: $0 -n <target_config> -u <target_user> [OPTIONS]"
    echo
    echo "ARGS:"
    echo "  -n <target_config>                      specify the nixos config to deploy."
    echo "  -d <target_user>                        specify user to deploy for."
    echo "  -g <git_repo>                           specify git repo to clone."
    echo "OPTIONS:"
    echo "  -u <dotfile_dir>                        specify dotfile directory."
    echo "                                          Default: current dir"
    echo "  -h | --help                             Print this help."
    exit 0
}

function green() {
    echo -e "\x1B[32m[+] $1 \x1B[0m"
    if [ -n "${2-}" ]; then
        echo -e "\x1B[32m[+] $($2) \x1B[0m"
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
    -n)
        shift
        target_config=$1
        ;;
    -g)
        shift
        git_repo=$1
        ;;
    -d)
        shift
        dotfile_dir=$1
        ;;
    -u)
        shift
        target_user=$1
        ;;
    -h | --help) help_and_exit ;;
    *)
        echo "Invalid option detected."
        help_and_exit
        ;;
    esac
    shift
done

green "nix-advanced-starter-flake installer"
green "Cloning dotfile repo"
git clone "$git_repo" "$dotfile_dir"

green "Generating hardware configuration"
sudo nixos-generate-config --root /mnt --no-filesystems --dir "$current_dir"/"$dotfile_dir"/hosts/"$target_config"/

green "Setting up disk"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake "$current_dir"/"$dotfile_dir"#"$target_config" --yes-wipe-all-disks

green "Copying configuration to root disk"
sudo mkdir -p /mnt/home/"$target_user"/
sudo cp -r "$current_dir"/"$dotfile_dir" /mnt/home/"$target_user"/

green "Installing flake $target_config"
sudo nixos-install --flake ./"$dotfile_dir"#"$target_config"

green "Installation finished! Reboot to see changes"
