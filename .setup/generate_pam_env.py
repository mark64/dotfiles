#!/usr/bin/env python3
import abc
import enum
import grp
import logging
import os
import shlex
import shutil
import subprocess
import sys
from typing import Dict, List

HOME_DIR = os.environ.get("HOME", "/home/mark")
REPO_ROOT = "{HOME_DIR}/repos".format(HOME_DIR=HOME_DIR)
CONFIG_ROOT = "{REPO_ROOT}/dotfiles".format(REPO_ROOT=REPO_ROOT)
LOCAL_ROOT = "{HOME_DIR}/.local".format(HOME_DIR=HOME_DIR)

pam_env_vars = {
    "XDG_CONFIG_HOME": "{CONFIG_ROOT}".format(CONFIG_ROOT=CONFIG_ROOT),
    "XDG_CACHE_HOME": "{LOCAL_ROOT}/tmp".format(LOCAL_ROOT=LOCAL_ROOT),
    "XDG_DATA_HOME": "{LOCAL_ROOT}/share".format(LOCAL_ROOT=LOCAL_ROOT),
    "XDG_BIN_HOME": "{LOCAL_ROOT}/bin".format(LOCAL_ROOT=LOCAL_ROOT),
    "XDG_BIN_HOME": "{LOCAL_ROOT}/bin".format(LOCAL_ROOT=LOCAL_ROOT),
    "XDG_LIB_HOME": "{LOCAL_ROOT}/lib".format(LOCAL_ROOT=LOCAL_ROOT),
    "GOPATH": "{REPO_ROOT}/go".format(REPO_ROOT=REPO_ROOT),
}
pam_env_vars["PYLINTHOME"] = "{}/pylint".format(pam_env_vars["XDG_DATA_HOME"])
pam_env_vars["LESSHISTFILE"] = "{}/less/history".format(pam_env_vars["XDG_DATA_HOME"])
pam_env_vars["LESSKEY"] = "{}/less/keys".format(pam_env_vars["XDG_DATA_HOME"])
os.environ["XDG_CONFIG_HOME"] = CONFIG_ROOT
os.environ["XDG_DATA_HOME"] = pam_env_vars["XDG_DATA_HOME"]
os.environ["PATH"] += ":{XDG_BIN_HOME}:{GOPATH}".format(
    XDG_BIN_HOME=pam_env_vars["XDG_BIN_HOME"], GOPATH=pam_env_vars["GOPATH"]
)


class SetupError(Exception):
    pass


class SetupFailure(Exception):
    pass


def install_apt_packages(packages, should_install: bool):
    installed_packages = (
        subprocess.Popen(
            "apt list --installed 2>/dev/null | sed s,/.*$,,",
            shell=True,
            stdout=subprocess.PIPE,
            stdin=sys.stdin,
        )
        .stdout.read()
        .decode()
        .split("\n")
    )
    to_install_packages = [i for i in packages if i not in installed_packages]
    if not to_install_packages:
        return
    elif not should_install:
        raise SetupFailure(
            "Need to install the following packages: {to_install_packages}".format(
                to_install_packages=to_install_packages
            )
        )
    else:
        logging.info(
            "Installing packages: {to_install_packages}".format(
                to_install_packages=to_install_packages
            )
        )
        p = subprocess.Popen(
            "DEBIAN_FRONTEND=noninteractive apt-get install -y {packages}".format(
                packages=" ".join(to_install_packages)
            ),
            stdin=subprocess.PIPE,
            shell=True,
        )
        p.wait()
        if p.returncode:
            if len(to_install_packages) == 1:
                raise SetupFailure(
                    "Failed to install apt package {package}".format(
                        package=packages[0]
                    )
                )
            for package in to_install_packages:
                try:
                    install_apt_packages([package], should_install)
                except SetupFailure as e:
                    logging.error(e)


def install_pip_packages(packages):
    dependencies = ["pip3"]
    for dependency in dependencies:
        if not shutil.which(dependency):
            raise SetupError(
                "Cannot install pip packages: {dependency} not installed".format(
                    dependency=dependency
                )
            )
    for package in packages:
        p = subprocess.Popen(
            "pip3 install --user --upgrade {package}".format(package=package),
            shell=True,
        )
        p.wait()
        if p.returncode:
            raise SetupFailure(
                "Failed to install pip package {package}".format(package=package)
            )


def setup_rust(env):
    dependencies = ["curl"]
    for dependency in dependencies:
        if not shutil.which(dependency):
            raise SetupError(
                "Cannot install rustup: {dependency} not installed".format(
                    dependency=dependency
                )
            )
    cargo_path = "{}/cargo".format(env["XDG_DATA_HOME"])
    for var in ["RUSTUP_HOME", "CARGO_HOME"]:
        env[var] = cargo_path
        os.environ[var] = cargo_path
        os.environ["PATH"] += ":{cargo_path}/bin".format(cargo_path=cargo_path)
    p = None
    if shutil.which("cargo") and shutil.which("rustup"):
        p = subprocess.Popen("rustup update", shell=True)
    else:
        p = subprocess.Popen(
            "curl https://sh.rustup.rs -sSf | sh -- --no-modify-path -y", shell=True
        )
    p.wait()
    if p.returncode:
        raise SetupFailure("Failed to setup rustup and cargo")
    p = subprocess.Popen("rustup toolchain add nightly", shell=True)
    p.wait()
    # don't care if it fails


def generate_profile(env):
    with open("{HOME_DIR}/.profile".format(HOME_DIR=HOME_DIR), "w") as profile_file:
        for var, value in env.items():
            profile_file.write(
                'export "{var}"="{value}"\n'.format(var=var, value=value)
            )
        extra_paths = [
            env["XDG_BIN_HOME"],
            env["CARGO_HOME"] + "/bin",
            env["GOPATH"] + "/bin",
        ]
        path_edit_loop = (
            "for path in {paths}; do\n"
            '    if [ -d "$path" ]; then\n'
            '        export PATH="$PATH:$path"\n'
            "    fi\n"
            "done\n".format(paths=" ".join(extra_paths))
        )
        profile_file.write(path_edit_loop)
        bashrc_source = (
            'if [ -z "$SOURCING_PROFILE" ] && [ -n "$BASH_VERSION" ]; then\n'
            "    # include .bashrc if it exists\n"
            '    if [ -f "$HOME/.bashrc" ]; then\n'
            '        source "$HOME/.bashrc"\n'
            "    fi\n"
            "fi\n"
        )
        profile_file.write(bashrc_source)
        return
    raise SetupFailure("Could not create ~/.profile file")


def setup_vim(env):
    install_plugins = False
    for editor in ["nvim", "vim"]:
        if shutil.which(editor):
            env.setdefault("EDITOR", editor)
            if editor in ["nvim", "vim"]:
                install_plugins = True
            if editor == "vim":
                p = subprocess.Popen(
                    'ln -sf "{}/nvim/init.vim" "{HOME_DIR}/.vimrc"'.format(
                        env["XDG_CONFIG_HOME"], HOME_DIR=HOME_DIR
                    ),
                    shell=True,
                )
                p.wait()
                if p.returncode != 0:
                    raise SetupFailure("Failed to symlink init.vim to ~/.vimrc")
    if install_plugins:
        p = subprocess.Popen(
            env["EDITOR"]
            + ' -i NONE -u "{XDG_CONFIG_HOME}/nvim/init.vim" -c PlugUpdate -c quitall >/dev/null'.format(
                XDG_CONFIG_HOME=env["XDG_CONFIG_HOME"]
            ),
            shell=True,
        )
        p.wait()
        if p.returncode:
            raise SetupFailure("Failed to install vim plugins")
    return True


def install_cargo_packages(packages, env):
    if not shutil.which("cargo"):
        raise SetupError("Cannot install cargo packages because cargo is not installed")
    for package in packages:
        if shutil.which("sccache"):
            env["RUSTC_WRAPPER"] = "sccache"
        # cargo install for some reason can't use sccache
        p = subprocess.Popen(
            'RUSTC_WRAPPER="" cargo install --force "{package}"'.format(
                package=package
            ),
            shell=True,
        )
        p.wait()
        if p.returncode:
            raise SetupError(
                "Could not install cargo package {package}".format(package=package)
            )


def install_rustup_components(components):
    if not shutil.which("rustup"):
        raise SetupError(
            "Cannot install rustup components because rustup is not installed"
        )
    for component in components:
        # cargo install for some reason can't use sccache
        p = subprocess.Popen(
            'RUSTC_WRAPPER="" rustup component add "{component}"'.format(
                component=component
            ),
            shell=True,
        )
        p.wait()
        if p.returncode:
            raise SetupError(
                "Could not add rustup component {component}".format(component=component)
            )
        p = subprocess.Popen(
            'RUSTC_WRAPPER="" rustup component add "{component}" --toolchain nightly'.format(
                component=component
            ),
            shell=True,
        )
        # don't care if it fails
        p.wait()
    p = subprocess.Popen("rustup update", shell=True)
    p.wait()
    if p.returncode:
        raise SetupError("Could not install rustup components")


def install_go_packages(packages):
    if not shutil.which("go"):
        raise SetupError("Cannot install go packages because go is not installed")
    for package in packages:
        p = subprocess.Popen(
            'go get -u "{package}"'.format(package=package), shell=True
        )
        p.wait()
        if p.returncode:
            raise SetupError(
                "Could not add go package {package}".format(package=package)
            )


class OS(enum.Enum):
    DEBIAN = 1
    UBUNTU = 2


class System(object):
    def __init__(self) -> System:
        proc = subprocess.Popen("lsb_release -is", stdout=subprocess.PIPE)
        proc.wait()
        if proc.returncode:
            logging.fatal("Could not determine operating system")
        os_mapping = {"Debian": OS.DEBIAN, "Ubuntu": OS.UBUNTU}
        self.os = os_mapping[proc.stdout.read()]


class Package(object):
    def __init__(self, name: str, name_mapping: Dict[str, str] = {}, required=False):
        self._name = name

    @property
    def name(self, system: System = None):
        if system:
            return self.name_mapping.get(system.os, default=self._name)
        return self._name


class PackageManager(object):
    REQUIRES_ROOT = True
    COMMAND_STRING = "echo"

    def install_package(self, package: Package, system: System) -> bool:
        package_name = package.name(system=system)
        proc = subprocess.Popen(
            f"{self.COMMAND_STRING} {shlex.quote(package_name)}", stderr=subprocess.PIPE
        )
        proc.wait()
        if proc.returncode:
            logging.error(
                f"Failed to install package {package.name}:\n{proc.stderr.read()}"
            )
            return False
        return True


class AptPackageManager(PackageManager):
    COMMAND_STRING = "DEBIAN_FRONTEND=noninteractive apt-get install -y"

    def __init__(self):
        proc = subprocess.Popen("apt-get update")
        proc.wait()


class PipPackageManager(PackageManager):
    REQUIRES_ROOT = False
    COMMAND_STRING = "pip3 install --user"


class Rustup(PackageManager):
    REQUIRES_ROOT = False
    COMMAND_STRING = "rustup component add"


PACKAGES = {
    "apt": {
        "class": AptPackageManager,
        "packages": [
            Package("vim", required=True),
            Package("neovim"),
            Package("python3", required=True),
            Package("python3-pip", required=True),
            Package("chromium", name_mapping={OS.UBUNTU: "chromium-browser"}),
            Package("libu2f-host0"),
            Package("gnupg"),
            Package("pass"),
            Package("pass-extension-otp"),
            Package("parcimonie"),
            Package("command-not-found"),
            Package("tmux"),
            Package("openssh-client"),
            Package("openssh-server"),
            Package("minicom"),
            Package("build-essential", required=True),
            Package("cmake"),
            Package("bazel"),
            Package("ninja-build"),
            Package("yubikey-personalization"),
            Package("yubikey-piv-tool"),
            Package("yubikey-luks"),
            Package("cryptsetup"),
            Package("curl", required=True),
            Package("libpam-u2f"),
            Package("golang-go"),
            Package("pandoc"),
            Package("texlive-latex-base"),
            Package("cscope"),
            Package("exuberant-ctags"),
            Package("clang"),
            Package("clang-format"),
            Package("checkinstall"),
            Package("gdb"),
            Package("lldb"),
            Package("fish"),
            Package("apt-listchanges"),
            Package("apt-listbugs"),
            Package("ufw"),
            Package("true"),
            Package("tor"),
            Package("ranger"),
            Package("rsync"),
            Package("git", required=True),
        ],
    },
    "pip": {
        "class": PipPackageManager,
        "packages": [
            Package("black"),
            Package("flake8"),
            Package("jedi"),
            Package("neovim"),
            Package("numpy"),
        ],
    },
}


def install_packages(packages: Dict[str, Dict[str, object]], is_root: bool):
    pass


def main():
    try:
        is_root = os.getuid() == 0
        install_apt_packages(APT_PACKAGES, is_root)
        if is_root:
            setup_firewall()
            setup_sshserver()
            setup_webserver()
            setup_auto_certs()
            return
        install_pip_packages(PIP_PACKAGES)
        setup_gnupg()
        setup_vim(pam_env_vars)
        setup_rust(pam_env_vars)
        setup_ssh()
        setup_cron()
        setup_user_systemd()
        setup_pass()
        #   install_cargo_packages(['ripgrep', 'sccache'], pam_env_vars)
        install_rustup_components(["rustfmt-preview"])
        install_go_packages(["mvdan.cc/sh/cmd/shfmt"])
        checkout_repos()
        generate_profile(pam_env_vars)
        generate_bashrc()
        generate_inputrc()
    except SetupError as e:
        logging.error(e)
    except SetupFailure as e:
        logging.error(e)
        exit(1)


if __name__ == "__main__":
    main()
