# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# fix the stupid tterm vt320 bullshit
if [ "$TERM" = "vt320" ]; then
	export TERM=ansi
fi

# l, ll, ldot, d aliases are quite useful
# the F is to append special chars
alias l='ls -lhF --color=auto'
alias ls='ls -alh --color=auto'
alias ll='ls -alhF --color=auto'
alias ldot='ls -aldhF --color=auto .*'
alias d='ls -askhF --color=auto'
alias pwgen='tr -dc "[:lower:][:digit:]" < /dev/urandom | head -c 16 && echo'


# copy and move are verbose -- NOT NECESSARY
# but nice unless you background the cp/mv
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'

# disk sizes 
alias df='df -ah'

# why isn't this the default behaviour?!
alias vim='vim -o'

# prompt and dir colours
# ----------------------
# the dircolours include colourising Oracle files, like
# *.sql, *.sh, *.dmp, *.ora, *.bak, etc
# if any of these are bold, add a 00; in front, eg: di=00;32:*.gz=00;35
# fix the prompt
export PS1='[\[\033[33m\]\u@\h \[\033[32m\w\033[0m]
:) '
# standard file types that want to be colourised
export LS_COLORS="di=32:*.sh=33:*.pl=33:*.bak=35:*.zip=35:*.tgz=35:*.rpm=35:*.gz=35:*.Z=35:*.z=35"
# multimedia file types love to be colourised
export LS_COLORS="$LS_COLORS:*.mp3=36:*.m3u=36:*.wav=36:*.gif=36:*.jpg=36:*.xcf=36:*.png=36:*.avi=36:*.mpg=36:*.mpeg=36:*.wmv=36:*.mov=36:*.mp4=36:*.mkv=36"

# sometimes I sudo become root so I need to
# get $HOME and $PWD set correctly
if [ "$USER" == "root" ] ; then
	export HOME=/root;
	cd $HOME;
fi

export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/sbin:$HOME/bin

# ssh agent setup
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
        eval `$SSHAGENT $SSHAGENTARGS` >/dev/null 2>&1
        trap "kill $SSH_AGENT_PID" 0 >/dev/null 2>&1
fi

# this is to ssh to wherever knows of these two privkeys
[ -e ~/.ssh/id_rsa.cloudslaves ] && ssh-add ~/.ssh/id_rsa.cloudslaves >/dev/null 2>&1
[ -e ~/.ssh/id_other ] && ssh-add ~/.ssh/id_other >/dev/null 2>&1

# Fedora Core 4 has an odd delete key mapping?
if [ -e ~/bin/sttyerase.sh ] ; then . ~/bin/sttyerase.sh ; fi

export EDITOR=vim

alias mRoot='mysql -u root -p'
alias slaveStatus='mysql -u root -e "show slave status\G"'
alias tableStatus='mysql -u root -e "select concat(table_schema,'\''.'\'',table_name) as tbl,engine,table_rows,data_length,index_length from information_schema.tables 
where table_schema not in ('\''information_schema'\'', '\''mysql'\'')"'

function ssa() { ssh -A -o StrictHostKeyChecking=no -t $1 ;}
