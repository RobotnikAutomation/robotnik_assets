#!/bin/sh
set -e

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

version="20250403"
repo_url="https://raw.githubusercontent.com/RobotnikAutomation/robotnik_assets/refs/tags/${version}/dualboot"

do_install() {
	echo "# Executing robotnik dualboot installer"

	user="$(id -un 2>/dev/null || true)"

	sh_c='sh -c'
	if [ "$user" != 'root' ]; then
		if command_exists sudo; then
			sh_c='sudo -E sh -c'
		elif command_exists su; then
			sh_c='su -c'
		else
			cat >&2 <<-'EOF'
			Error: this installer needs the ability to run commands as root.
			We are unable to find either "sudo" or "su" available to make this happen.
			EOF
			exit 1
		fi
	fi

	main_boot="/dev/nvme0n1p3"
	curr_boot="$(df / | tail -1 | awk '{print $1}')"

	set -x
	$sh_c "wget -O /usr/local/sbin/toggle-default-boot-partition $repo_url/toggle-default-boot-partition -o /dev/null"
	$sh_c "chmod +x /usr/local/sbin/toggle-default-boot-partition"

	if [ "$curr_boot" = "$main_boot" ]; then
		$sh_c "wget -O /usr/local/sbin/list-boot-partition $repo_url/list-boot-partition -o /dev/null"
		$sh_c "chmod +x /usr/local/sbin/list-boot-partition"
	fi
}

# wrapped up in a function so that we have some protection against only getting
# half the file during "curl | sh"
do_install
