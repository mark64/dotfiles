# git prompt
set -U __fish_git_prompt_showdirtystate		1
set -U __fish_git_prompt_showstashstate		1
set -U __fish_git_prompt_showuntrackedfiles	1
set -U __fish_git_prompt_showupstream		informative
set -U __fish_git_prompt_describe_style		default
set -U __fish_git_prompt_showcolorhints		1

function fish_prompt
	printf '%s@%s %s%s%s%s> ' (whoami) (hostname) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (__fish_git_prompt)
end

# for git review alias
# see https://blog.jez.io/cli-code-review/
set -gx REVIEW_BASE							HEAD^
