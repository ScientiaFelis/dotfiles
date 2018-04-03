############################################################################################
    ##########################Make some aliases and functions ##########################
        #### OBS this file is both for ARCH LINUX and derivatives, and LINUX MINT ####
#############################################################################################


########################################
##  For Arch Linux specific aliases ##
########################################


if [[ -d /etc/pacman.d ]];then  ## Only load arch specific aliases and functions if in a arch system

#alias units='pacmatic -Qql '$1' | grep -Fe .service -e .socket'


## Run the firefox-sync script to load the profile into RAM
if [[ -x ~/bin/firefox-sync.sh ]]; then
	~/bin/firefox-sync.sh
fi

[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

## Pacman alias
alias pacmirrors='sudo reflector -l 100 -a 24 --score 15 -f 10 --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist' # Update mirrorlist with the 100 latest synchronized within 24 hours and select the 15 with highest score and the 10 fastest of those mirrors and save them as a new mirrorlist.



#alias pacman='pacmatic --color=always' # package manager utility
alias pacinst='sudo pacmatic -S --color=always' # Install a packages
alias pacupg='sudo pacmatic -Syyyu --color=always' # Install updates without first force syncronization
alias sysupgrade='sudo pacmatic -Syu --color=always && cleancache' # Install updates forcing syncronizacion of databases
alias aurupg='sudo yaurt -Syua' # Update from AUR
alias pacpurge='sudo pacmatic -Rns && cleancache' # Purge packages
alias sinstpac='pacman -Qs' # Search from the local installed packages
alias pacinfo='pacman -Qii' # give information on the packages
#alias orphans='pacmatic -Qdt'

## Check for new pacnew and pacsave conf files
alias findpacnew='sudo find / -regextype posix-extended -regex ".+\.pac(new|save|orig)" 2> /dev/null'

alias kernels='\pacman -Q | grep linux'


## Sync write cache befor shutting down and reboot, and the firefox profile from RAM
alias poweroff='[[ -x "$HOME/bin/firefox-sync.sh" ]] && ~/bin/firefox-sync.sh && sync && sudo poweroff || sync && sudo poweroff'
alias reboot='[[ -x "$HOME/bin/firefox-sync.sh" ]] && ~/bin/firefox-sync.sh && sync && sudo reboot || sync && sudo reboot'

alias xed='gedit'
alias xreader='evince'

## Find dependencies
finddep() { ## NÅGONTING FUNKAR INTE RIKTIGT

        CMD="pacman -Si"
        SEP=": "
        TOTAL_SIZE=0

        RESULT=$(eval "${CMD} $@ 2>/dev/null" | awk -F "$SEP" -v filter="Size" -v pkg="^Name" \
          '$0 ~ pkg {pkgnme=$2} $0 ~ filter {gsub(/\..*/,"") ; printf("%6s KiB %s\n", $2, pkgname)}' | sort -u -k3)

        echo "$RESULT"

        ## Print total size
        echo "$RESULT" | awk '{TOTAL=$1+TOTAL} END {printf("Total : %d KiB\n",TOTAL)}'

}


## Find changed config files that you may want to back up
confchange() {
    pacman -Qii | awk '/^MODIFIED/ {print $2}'
}


## Delete orphans
orphanpurge() {
	if [[ ! -n $(pacman -Qdt) ]]; then
	   echo "No orphans to remove"
	else
		pacman -Qdt
		read -p "Do you want to remove following packages (y/N): " answers

		case $answers in
    		[y,Y]*) 	sudo pacman -Rns $(pacman -Qdtq) ;;
		    *)	echo "Did not do anything"
		esac
	fi
 }


## Cache clean up
## Remove all cached packages except the last two
## then remove all uninstalled packages and all their cached versions.

cleancache() {
	paccache -vvvdk2; paccache -vvvduk0

	echo ""
	read -p "Remove these packages? (y/N)" answer

	case $answer in
		[yY]*) 	paccache -rk2 && paccache -ruk0 ;;
    		*) 	echo "Did not do anything" ;;
 	esac
 }




## Find all packages no other packages depends on

nodeps () {

	local ignoregrp="base base-devel cinnamon"
	local ignorepkg="antergos-keyring antergos-mirrorlist"
	comm -23 <(pacman -Qqt | sort) <(echo $ignorepkg | tr ' ' '\n' | cat <(pacman -Sqg $ignoregrp) - | sort -u)
}


disownedfile () {

	tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
	db=$tmp/db
	fs=$tmp/fs

	mkdir "$tmp"
	trap 'rm -rf "$tmp"' EXIT

	pacman -Qlq | sort -u > "$db"

	sudo find /etc /opt /usr ! -name lost+found \( -type d -printf '%p/\n'-o -print \) | sort > "$fs"

}


## This ends the check if if we are on a Arch based system



########################################
##  For Linux Mint specific aliases ##
########################################

elif [[ -d /etc/apt ]]; then

##------------------
# apt-get, dpkg
##-------------------

    alias ag='sudo apt-get'
    alias ag='sudo apt-get'
    alias kernels='dpkg --get-selections | grep -e linux-image -e linux-header'
    alias sysupgrade='sudo apt-get update && sudo apt-get dist-upgrade'
    alias aptinst='sudo apt-get install'
    alias aptremove='sudo apt-get remove'
    alias aptpurge='sudo apt-get purge'
    alias aptautrem='sudo apt-get autoremove && sudo apt-get autoclean'
    alias acs='apt-cache search'

    alias up12='sudo mintupdate-tool upgrade -r -l12 -nk'
    alias upsec='sudo mintupdate-tool upgrade -r -s -nk'
    alias upkern='sudo mintupdate-tool upgrade -r -s -k'
    alias upall='sudo mintupdate-tool upgrade -r -l1234 -s -k'


    alias poweroff='sync && systemctl poweroff'
    alias reboot='sync && systemctl reboot'
    
    #function dlpkgdeps (){  ## It did not work when packages had the form of <pkgname>
    #    apt-get download "$1" $(apt-cache depends -i "$1" | grep Beroende | awk -F ": " '{print $NF}' | xargs) ## Download a package and its dependencies
    #}
    
    # List packages by size
   function apt-list-packages() {
    	dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n' | \
    	grep -v deinstall | \
    	sort -n | \
    	awk '{print $1" "$2}'
   }
    
    
    alias compiledeb='sudo checkinstall -D --install=no'

else
    echo "You are neighter on a Debian nor an Arch based system."

fi ## This completes the check for a Debian based system



############################################################################################
   ####################### Common aliases for ARCH LINUX and Linux Mint###################
#############################################################################################


##--------------
## Most used commands
##------------------
mestanv() {
    \cat $HOME/.bash_history | awk '{CMD[$1]++ CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}


##--------------------
## Some ls, cat aliases
##---------------------
alias l.='ls -d .* --color=auto' # Lists all hidden directories
alias lD='ls -lhAd */ --color=always' #List all directories in current directory. 
alias lg='ls -lhA --group-directories-first --color=always'
alias lgr='ls -lhAr --group-directories-first --color=always'
alias lt='ls -lAht --group-directories-first --color=always' # Lists all files and directories (exept '.' and '..') and sort them by modified time, newest first.
alias ltr='ls -lAhtr --group-directories-first --color=always' # Lists all files and directories (exept '.' and '..') and sort them by modified time, oldest first.
alias lS='ls -lAhFS --group-directories-first --color=always' # Lists all files and directories (exept '.' and '..') and sort them by size, largest first.
alias lSr='ls -lAhFSr --group-directories-first --color=always' # Lists all files and directories (exept '.' and '..') and sort them by size, smallest first.
alias lsroot='find ~ -user root -exec ls -lad {} \;'
alias lsx='ls -lBAhX --group-directories-first --color=always' # Lists files sorted by file extensions

[[ -x $HOME/bin/ccat ]] && alias cat='ccat --bg=dark --color=auto'
alias catn='\cat -n'

function nrof() { cat "$2" | grep "$1" | wc -l; } ## Counts the number of times something (first argument) exists in a file (second argument)

## Edit this alias file or the .bashrc file in vim
alias cba='vim ~/.bash_aliases'
alias cbr='vim ~/.bashrc'

##------------------------
## some cp, mv, rm, mkdir, cd and ln aliases
##---------------------------
#mkdir
alias mkdir='mkdir -pv' # makes directories recursively (creates directories inside another new directory), in verbose mode.
mkdircd() { mkdir "$1" && cd "$1"; } # makes a direktory and change to it.


##cp & mv
alias cp='cp -uvia'
alias mv='mv -uvi'

cpcd() {   # makes a new directory, if it did not exist, copy a file or a directory there, and change to it.

	if [ ! -d "${@:$#}" ]; then # If the last argument is not a directory then...
		mkdir "${@:$#}"			# make that last argument a directory.
    fi

	cp "${@:1:$(($#-1))}" "${@:$#}" && cl "${@:$#}" # Copy every argument, exept the last one, into the last
													# argument (the new directory), and then change into it.
}


mvcd() {  # makes a new directory, if it do not exist, move a file there, and change to it.

	if [ ! -d "${@:$#}" ]; then # If the last argument is not a directory then...
		mkdir "${@:$#}"			# make that last argument a directory.
	fi

	mv "${@:1:$(($#-1))}" "${@:$#}" && cl "${@:$#}"	# Move every argument(file/directory), exept the last one,
													# into the lastargument (the new directory), and then change
													# into it.
}


cpmk() {   # makes a new directory, if it did not exist, copy files or directories there.

	if [ ! -d "${@:$#}" ]; then # If the last argument is not a directory then...
		mkdir "${@:$#}"			# make that last argument a directory.
    fi

	cp "${@:1:$(($#-1))}" "${@:$#}" # Copy every argument, exept the last one, into the last
									# argument (the new directory).
}


mvmk() {  # makes a new directory, if it do not exist, move files there.

	if [ ! -d "${@:$#}" ]; then # If the last argument is not a directory then...
		mkdir "${@:$#}"			# make that last argument a directory.
	fi

	mv "${@:1:$(($#-1))}" "${@:$#}"	# Move every argument(file/directory), exept the last one,
									# into the lastargument (the new directory).
}



##ln
alias lns='ln -sfi' # Makes a forced symbolic link asking if destinations should be taken away if they exist

##cd
alias cd...='cd ../../'
alias cd2='cd ../../'
alias cd3='cd ../../../'
alias cd4='cd ../../../../'
cl () { builtin cd "$@" && ltr; } # goes into a directory and list the files and directories in it (if cd were succcessful).

##rm
alias rm='rm -I --preserve-root' # Ask before deleting more than 3 files and Do not delete root.


## Open documents in background and pushing error codes to a textfile
function docop() { libreoffice "$1" 2> $HOME/docerrors.txt & }
function pdfop() { xreader "$1" 2> $HOME/pdferrors.txt & }
function txtop() { xed "$1" 2> $HOME/txterrors.txt & }


##------------------------------------
## diff, diff3 and patch
##----------------------------------

alias diff='colordiff -Naurs'
alias patch='patch -u'



##---------------------------------------------------------------------##
## chmod, chown & chgroup Parenting; do not change perms on / etc ##
##------------------------------------------------------------------------##
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

function chmR() { #Change the permissions on directories (d) or files (f) recursively from a path.
  find "$3" -type "$1" -exec chmod "$2" {} +
  ls -ltR "$3"
  echo ""
  echo "Changed permissions on type '$1' to '$2' from path '$3' recursively."
  echo ""
}


##---------------------------------
## grep, pdfgrep, find, fdupes
##-------------------------------

alias pdfgrep='pdfgrep -nrH --color always'

alias dupdel='fdupes -Srd' # find duplicates recursively in directories presented and ask to delete or not.


##--------------------------------------
## dir, du, df, lsblk, free, push and popd aliases
##-----------------------------
alias dirs='dirs -v'
alias du='du -sh'
alias duu='\du -h --max-depth=1'
alias df='pydf -h'
alias dfa='pydf -ah'
alias dfi='pydf -hi'
alias free='free -h'


alias lsblk='lsblk -o TYPE,NAME,SIZE,MOUNTPOINT,FSTYPE,HOTPLUG,LABEL,UUID'

alias randcom='whatis $(ls /usr/bin | shuf -n 1)' #Shows a random command from /usr/bin



##---------------------------
## If cmatrix is installed
##--------------------------
alias matrix='cmatrix -asb -C cyan'
alias cmatrix='cmatrix -as'


##------------------------
## tar aliases
##---------------------------
alias taru='tar -uivpf' # update an archive
alias tarc='tar -cvpJf' # creates a xz-compressed archive
alias tarx='tar -xvpJf' # uncompress a xz-compressed archive
alias tarxg='tar -xvpzf' # uncompress a gz-compressed archive



##-------------------------------------
## rsync
##------------------------------------------
alias bakuS='rsync -avShun --progress'
alias baku='rsync -avShu --progress' # sync files and replace older files, with preserved permisions etc
alias bakuDS='rsync -avShun --delete-after --progress'
alias bakuD='rsync -avShu --delete-after --progress' # sync files and replace older filesand delete files not in first directory, with preserved permisions etc



##-------------------------
## wget, pv
##-----------------------
alias wget='wget -c' ## wget resume from partially downloaded file

alias pv='pv -ptera' ## shows throughput of different processes. Se man pv for details.




##-----------------------------
#Networks, printers
##---------------------------
alias ports='netstat -tulanp'
alias lpp='lpstat -tR; lpq -l' # Show the status of printers and jobs

alias ping='ping -c5'


###--------------------###
## Security
##--------------------##

alias rootkit='sudo chkrootkit && sudo rkhunter --check && cat /var/log/rkhunter.log'



##----------------------------##
## Git
##----------------------------------##

# Global variables
re='^[0-9]+$'

# Updates your current branch with origin/master even, make you dont have uncommited changes
# sync with origin/master and then put your changes back
update() {
    if currentBranch=$(git symbolic-ref --short -q HEAD)
    then
        git checkout master
        pull
        git checkout $currentBranch
        git rebase master
    else
        echo not on any branch
    fi
}

# Rebase your current branch for last n($1) commits
# Its going to be interactive
rebase() {
    if [ -z $1 ] 
        then val=2
    else
        val=$1
    fi
    git rebase -i HEAD~$val
}


# Regular push current branch to origin
# It will not push the master branch
push() {
    if [ -z $1 ]
        then echo "Need the name of the branch"
    else
        git push origin $1    
    fi
}

# Log of commit messages in one line
log() {
    git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short
}


# Status of git
gstat() {
    git status
}


# Pulls the changes for current branch from origin and merges them.
pull() {
    if currentBranch1=$(git symbolic-ref --short -q HEAD)
    then
        git pull origin $currentBranch1 --rebase --prune
    else
        echo not on any branch
    fi
}

# Commit the files (on current branch) with the given message
# It will incluide all the files that have been modified and deleted.
# For new files you have to manually stage them using 'git add .'
commit() {
    local message=$@
    if [ -z "${message// }" ]
        then echo "Commit message missing"
    else
        git commit -am "$message"
    fi
}

# Updates your fork from upstream master and pushes the updates to your origin fork 
updateFork() {
    git checkout master
    git fetch upstream master
    git merge upstream/master
    push master
}




##----------------------------##
## passwords etc
##----------------------------##

alias pw8='pwgen -Bn1 15 10'




##---------------------------###
## systemctl, systeminfo
##--------------------------##
alias status='systemctl status'
alias startserv='sudo systemctl start' ## show the status of a service
alias restartserv='sudo systemctl restart' ## restart a service
alias reloadserv='sudo systemctl reload' ## reload a service configuration file, without restarting
alias stopserv='sudo systemctl stop' ## stop a service
alias enableserv='sudo systemctl enable' ## eneble a service (so that it start automatic att boot)
alias disableserv='sudo systemctl disable' ## disable a service
alias listserv='systemctl list-unit-files' ## List all units
alias requires='systemctl show -p Requires' ## Lists which services the named service Requires to start
alias wants='systemctl show -p Wants' ## Lists which services the named service Wants to start but do not fail if not
alias conflicts='systemctl show -p Conflicts' ## Lists which services the named service Conflicts with
alias requisite='systemctl show -p Requisite' ## Lists which services the named service Requisite to be started

alias startuptime='systemd-analyze blame; systemd-analyze critical-chain'

#Governor
alias governors='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'

#Processes
alias psall='ps -aux'

#Visudo to change the sudoer file
alias nanosudoer='sudo EDITOR=nano visudo -fs'
alias visudo='sudo visudo -s'

## Add users
alias admusr='sudo useradd -m -U -G wheel,sudo,adm,cdrom,dip,plugdev,lpadmin -s /bin/bash' ## Add user with admin rights
alias guestusr='sudo useradd -m -U -e $(date +%x --date='next month') -s /bin/bash' ## Add guest user valid for a month.
alias normusr='sudo useradd -m -U -s /bin/bash' ## Add usual user 

alias compSwapUUID='echo -e "First output from fstab, change to match second. \n" && \cat /etc/fstab | grep none | awk -F " " '\''{print $1}'\'' | awk -F "=" '\''{print $2}'\'' && lsblk | grep SWAP | awk -F " " '\''{print $7}'\'''


################################################
       #### GENERAL  FUNCTIONS ####
################################################


## Check if swappiness and cache pressure is set to reasonable values

(( $(\cat /proc/sys/vm/swappiness | awk '{print $1}') > 20 )) && echo "Change swappiness to a lower value (use eg. swapp.sh)." 

(( $(\cat /proc/sys/vm/vfs_cache_pressure | awk '{print $1}') > 50 )) && echo "Change cache pressure to a lower value." 

## Change file extensions. Can be useful to change filesextensions on a bunch of files so it get the right colors (e.g. .JPG --> .jpg) or when files should be sent to a windows machine where file extension matters.

# extname [Old extension] [New extension]

function extrename() {
	## rename file extentions from argument 1 ($1) to argument 2 ($2)
   rename -v ."$1" ."$2" *."$1"
}


## Extract compressed and tar files of different kind
# extract [file]

extract() {

    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then

            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
            		c=(bsdtar xvf);;
            *.7z)   c=(7z x);;
            *.Z)    c=(uncompress);;
            *.bz2)  c=(bunzip2);;
            *.exe)  c=(cabextract);;
            *.gz)   c=(gunzip);;
            *.rar)  c=(unrar x);;
            *.xz)   c=(unxz);;
            *.zip)  c=(unzip);;
            *)      echo "$0: unrecognized file type: \`$i'" >&2
                    continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"

}


## Select row number X to Y from a file and print it to std out
## printlines [X] [Y] [file]

printlines() {

	< "$3" tail -n +"$1" | head -n "$(( $2 - $1 ))"

}


## Check and delete broken symlinks in current directory
alias brokensymlink='find . -type l -! -exec test -e {} \; -print'
function delbrokensymlinks() {
    find . -type l -exec sh -c 'for x; do [ -e "$x" ] || (ls -la "$x" && unlink "$x"); done' _ {} +
    echo ""
    echo "These are the broken symlinks in the CURRENT directory"
}

### pars for fun: install | remove | rollback
if [[ -d /etc/apt ]]; then
function apt-history(){
	case "$1" in
		install)  grep 'install ' /var/log/dpkg.log  ;;
        upgrade|remove) grep $1 /var/log/dpkg.log  ;;
        rollback)    grep upgrade /var/log/dpkg.log | grep "$2" -A10000000 | grep "$3" -B10000000 | awk '{print $4"="$5}' ;;
        *) cat /var/log/dpkg.log  ;;
	esac
}
fi




##--------------------------------
# Source the .bashrc and .bash_aliases files after changes has been made to it
##-------------------------------
alias s.bs='source $HOME/.bashrc'


##########################################################################
# To tell if the file was read
echo "The .bash_aliases file was successfully read"
