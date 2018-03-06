set -U editor nvim

function fish_greeting
end

set -Ux XDG_CONFIG_HOME	$HOME/.config
set -Ux XDG_CACHE_HOME	$HOME/.cache
set -Ux XDG_DATA_HOME	$HOME/.local/share
set -Ux XDG_DATA_DIRS	/usr/local/share:/usr/share
set -Ux XDG_CONFIG_DIRS	/etc/xdg
