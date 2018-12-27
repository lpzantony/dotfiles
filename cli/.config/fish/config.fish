# Fish config file

set airline_right 
set airline_left 
set airline_right_empty 
set airline_left_empty 

set distib_logo (~/.config/fish/dist.sh)

function set_256_color -d "Sets the 256 color-mode current color. fg bg"
	set cmd "\e["
	set fbg 0

	function make_number
		if [ $argv[1] = "r" ]
			echo 9
		else
			echo -sn "8;5;" $argv[1]
		end
	end

	if [ "$argv[1]" = "fg" ]
		set fbg 3
	else if [ "$argv[1]" = "bg" ]
		set fbg 4
	else
		echo -esn $cmd 3 (make_number $argv[1]) ";" 4 (make_number $argv[2]) m
		return
	end

	set cmd "$cmd$fbg"

	if [ "$argv[2]" = "r" ]
		echo -esn $cmd 9m
	else
		echo -esn $cmd "8;5;" $argv[2] m
	end
end
alias s256c set_256_color

set color_hostname_fg 226
set color_hostname_bg 27
set color_pwd_fg 252
set color_pwd_bg 238
set color_pwd_sep 248
set color_extra_fg 15
set color_extra_bg 71

# Prompt (PS1)
function fish_prompt
	set colored_sep (echo -en (s256c fg $color_pwd_sep) $airline_right_empty (s256c fg $color_pwd_fg))
	printf "%s %s %s%s%s %s %s%s " (s256c $color_pwd_fg $color_pwd_bg) (prompt_pwd | sed -E "s!^(~?/[^/]+)(/[^/]+)+((/[^/]+){3})\$!\1/✂\3!g" | sed -E (echo -sen "s!(.)/!\\\1$colored_sep!g") | sed -E (echo -sen "s!^/(.)!/ $colored_sep\\\1!")) (s256c $color_pwd_bg $color_extra_bg) $airline_right (s256c fg $color_extra_fg) $distib_logo (s256c $color_extra_bg r) $airline_right
end

set color_git_bg 1
set color_git_fg 0
set color_venv_bg 208
set color_venv_fg 0

# Right prompt (RPS1)
function fish_right_prompt
	set gitBranch (git branch 2> /dev/null | grep \* | sed 's/^\* //g')
	if [ ! -z "$gitBranch" ]
		# set_color red
		printf "%s%s%s  %s " (s256c $color_git_bg r) $airline_left (s256c $color_git_fg $color_git_bg) $gitBranch
	end
	if [ ! -z "$VIRTUAL_ENV" ]
		set venv_colors (s256c $color_venv_bg r)
		if [ ! -z "$gitBranch" ]
			set venv_colors (s256c $color_venv_bg $color_git_bg)
		end
		printf "%s%s%s  %s " $venv_colors $airline_left (s256c $color_venv_fg $color_venv_bg) (basename $VIRTUAL_ENV)
	end
	printf "%s%s%s %s %s" (s256c fg $color_hostname_bg) $airline_left (s256c $color_hostname_fg $color_hostname_bg) (whoami) (s256c r r)
end

# Aliases
alias rm "rm -i"
alias cp "cp -i"
alias mv "mv -i"
alias ip "ip --color"

# -2 forces tmux to assume the terminal supports 256 colors
# -u forces tmux to assume UTF8 support
alias tmux "tmux -2u"

# ENV
export EDITOR=vim

# VirtualEnv setup
set VIRTUAL_ENV_DISABLE_PROMPT true


# Custom config file to avoid overwrite at each update. Put config-specific data into it
if test -e ~/.fishrc
	source ~/.fishrc
end

# CUSTOM

function sudo
    if test "$argv" = !!
    eval command sudo $history[1]
else
    command sudo $argv
    end
end

alias fucking "sudo"
alias nf "neofetch"
alias gst "git st"
alias gcm "git cm"
alias rst "tput reset"
alias hextodec 'printf "%d\n"'
alias dectohex 'printf "%x\n"'
alias gcma "git commit --amend"
alias grc "git rebase --continue"
alias gdt "git difftool -y -t meld"
alias gcf "git clean -df"
alias tiga "tig --all"
alias pinta "env LANG=C pinta"
