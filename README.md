# mark64's config files

This repo was originally started in my ~/.config directory. It contains all non-sensitive config
files for my GNU setup.

I don't recommend using this to replace all your configuration files, but if you want to use it,
backup your `.bashrc`, `.profile`, `.pam_environment`, `.inputrc`, `.ssh` dir, `.gnupg` dir. Then,
clone this repo into any directory and run:

```bash
./dotfiles/setup.sh
```

This will create the necessary symlinks to the files mentioned above, generate a .profile with
XDG_CONFIG_HOME set to the path of this repo, install vim plugins if vim or nvim is installed, and
enable automatic updating of this repo in the .bashrc.
