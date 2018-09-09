#!/usr/bin/env python3
import grp
import os
import shutil
import subprocess
import sys
from typing import List, Dict

HOME_DIR = os.environ.get('HOME', '/home/mark')
REPO_ROOT = f'{HOME_DIR}/repos'
CONFIG_ROOT = f'{REPO_ROOT}/dotfiles'
LOCAL_ROOT = f'{HOME_DIR}/.local'

pam_env_vars = {
    'XDG_CONFIG_HOME': f'{CONFIG_ROOT}',
    'XDG_CACHE_HOME': f'{LOCAL_ROOT}/tmp',
    'XDG_DATA_HOME': f'{LOCAL_ROOT}/share',
    'XDG_BIN_HOME': f'{LOCAL_ROOT}/bin',
    'XDG_BIN_HOME': f'{LOCAL_ROOT}/bin',
    'XDG_LIB_HOME': f'{LOCAL_ROOT}/lib',
    'GOPATH': f'{REPO_ROOT}/go',
}
pam_env_vars['PYLINTHOME'] = f'{pam_env_vars["XDG_DATA_HOME"]}/pylint'
pam_env_vars['LESSHISTFILE'] = f'{pam_env_vars["XDG_DATA_HOME"]}/less/history'
pam_env_vars['LESSKEY'] = f'{pam_env_vars["XDG_DATA_HOME"]}/less/keys'


class SetupError(Exception):
    pass


class SetupFailure(Exception):
    pass


def install_apt_packages(packages: List[str], should_install: bool):
    installed_packages = subprocess.Popen(
        'apt list --installed 2>/dev/null | sed s,/.*$,,',
        shell=True,
        stdout=subprocess.PIPE,
        stdin=sys.stdin).stdout.read().decode().split('\n')
    to_install_packages = [i for i in packages if i not in installed_packages]
    if not to_install_packages:
        return
    elif not should_install:
        raise SetupFailure(
            f'Need to install the following packages: {to_install_packages}')
    else:
        print(f'Installing packages: {to_install_packages}')
        p = subprocess.Popen(
            f'sudo apt-get install {" ".join(to_install_packages)}',
            stdin=subprocess.PIPE,
            shell=True)
        p.wait()
        if p.returncode:
            if len(to_install_packages) == 1:
                raise SetupFailure('Failed to install apt packages')
            for package in to_install_packages:
                install_apt_packages(package, should_install)


def install_pip_packages(packages: List[str]):
    dependencies = ['pip3']
    for dependency in dependencies:
        if not shutil.which(dependency):
            raise SetupError(
                f'Cannot install pip packages: {dependency} not installed')
    for package in packages:
        p = subprocess.Popen(
            f'pip3 install --user --upgrade {package}',
            shell=True)
        p.wait()
        if p.returncode:
            raise SetupFailure(f'Failed to install pip package {package}')


def setup_rust(env: Dict[str, str]):
    dependencies = ['curl']
    for dependency in dependencies:
        if not shutil.which(dependency):
            raise SetupError(
                f'Cannot install rustup: {dependency} not installed')
    cargo_path = f'{env["XDG_DATA_HOME"]}/cargo'
    for var in ['RUSTUP_HOME', 'CARGO_HOME']:
        env[var] = cargo_path
        os.environ[var] = cargo_path
    p = None
    if shutil.which('cargo') and shutil.which('rustup'):
        p = subprocess.Popen('rustup update', shell=True)
    else:
        p = subprocess.Popen(
            'curl https://sh.rustup.rs -sSf | sh -- --no-modify-path -y',
            shell=True)
    p.wait()
    if p.returncode:
        raise SetupFailure(f'Failed to setup rustup and cargo')


def generate_profile(env: Dict[str, str]):
    with open(f'{HOME_DIR}/.profile', 'w') as profile_file:
        for var, value in env.items():
            profile_file.write(f'export "{var}"="{value}"\n')
        extra_paths = [
            env['XDG_BIN_HOME'],
            f'{env["CARGO_HOME"]}/bin',
            f'{env["GOPATH"]}/bin']
        path_edit_loop = (f'for path in {" ".join(extra_paths)}; do\n'
                          '    if [ -d "$path" ]; then\n'
                          '        export PATH="$PATH:$path"\n'
                          '    fi\n'
                          'done\n')
        profile_file.write(path_edit_loop)
        bashrc_source = (
            f'if [ -z "$SOURCING_PROFILE" ] && [ -n "$BASH_VERSION" ]; then\n'
            '    # include .bashrc if it exists\n'
            '    if [ -f "$HOME/.bashrc" ]; then\n'
            '        source "$HOME/.bashrc"\n'
            '    fi\n'
            'fi\n')
        profile_file.write(bashrc_source)
        return
    raise SetupFailure('Could not create ~/.profile file')


def generate_bashrc():
    pass


def generate_fish_conf():
    pass


def generate_inputrc():
    with open(f'{HOME_DIR}/.inputrc', 'w') as inputrc_file:
        inputrc_file.write('$include /etc/inputrc\n'
                           'set completion-ignore-case on\n')
        return
    raise SetupFailure('Could not create ~/.inputrc file')


def setup_vim(env: Dict[str, str]):
    install_plugins = False
    for editor in ['nvim', 'vim']:
        if shutil.which(editor):
            env.setdefault('EDITOR', editor)
            if editor in ['nvim', 'vim']:
                install_plugins = True
            if editor == 'vim':
                p = subprocess.Popen(
                    f'ln -sf "{env["XDG_CONFIG_HOME"]}/nvim/init.vim" "{HOME_DIR}/.vimrc"',
                    shell=True)
                p.wait()
                if p.returncode != 0:
                    raise SetupFailure(
                        "Failed to symlink init.vim to ~/.vimrc")
    if install_plugins:
        p = subprocess.Popen(
            f'{env["EDITOR"]} -i NONE -c PlugUpdate -c quitall',
            shell=True)
        p.wait()
        if p.returncode:
            raise SetupFailure('Failed to install vim plugins')
    return True


def setup_cron():
    pass


def setup_gnupg():
    pass


def setup_ssh():
    pass


def setup_minicom():
    pass


def setup_systemd():
    pass


def setup_ranger():
    dependencies = ['ranger']
    for dependency in dependencies:
        if not shutil.which(dependency):
            raise SetupError(
                f'Cannot install ranger: {dependency} not installed')
    p = subprocess.Popen('ranger --copy-config=scope', shell=True)
    p.wait()
    if p.returncode:
        raise SetupFailure('Failed to setup ranger')


def setup_u2f():
    pass


def setup_pass():
    pass


def setup_firewall():
    pass


def setup_sshserver():
    pass


def setup_pamd():
    pass


def setup_nginx():
    pass


def setup_apache():
    pass


def setup_webserver():
    pass


def setup_auto_certs():
    pass


def setup_disks():
    pass


def setup_backups():
    pass


def setup_user_systemd():
    pass


def checkout_repos():
    pass


APT_PACKAGES = [
    'neovim',
    'python3',
    'python3-pip',
    'chromium',
    'libu2f-host0',
    'gnupg',
    'pass',
    'pass-extension-otp',
    'parcimonie',
    'command-not-found',
    'tmux',
    'openssh-server',
    'minicom',
    'build-essential',
    'cmake',
    'ninja-build',
    'yubikey-personalization',
    'yubico-piv-tool',
    'yubikey-luks',
    'cryptsetup',
    'curl',
    'libpam-u2f',
    'golang-go',
    'pandoc',
    'texlive-latex-base',
    'cscope',
    'exuberant-ctags',
    'clang',
    'clang-format',
    'checkinstall',
    'gdb',
    'lldb',
    'fish',
    'apt-listchanges',
    'apt-listbugs',
    'ufw',
    'tree',
    'tor',
    'ranger',
    'w3m-img',
    'rsync',
    'strace',
    'sshfs',
    'openssl',
    'openssh-client',
    'git',
]

PIP_PACKAGES = [
    'autopep8',
    'flake8',
    'neovim',
    'yapf',
    'jedi',
    'numpy',
    'pylint',
]


def main():
    try:
        is_root = os.getuid() == 0
        install_apt_packages(APT_PACKAGES, is_root)
        if is_root:
            setup_pamd()
            setup_firewall()
            setup_sshserver()
            setup_pamd()
            setup_webserver()
            setup_auto_certs()
            setup_disks()
            setup_backups()
            setup_systemd()
            return
        install_pip_packages(PIP_PACKAGES)
        setup_gnupg()
        setup_vim(pam_env_vars)
        setup_rust(pam_env_vars)
        setup_ssh()
        setup_cron()
        setup_ranger()
        setup_minicom()
        setup_user_systemd()
        setup_u2f()
        setup_pass()
        checkout_repos()
        generate_profile(pam_env_vars)
        generate_bashrc()
        generate_fish_conf()
        generate_inputrc()
    except SetupError as e:
        print(e)
    except SetupFailure as e:
        print(e)
        exit(1)


if __name__ == '__main__':
    main()
