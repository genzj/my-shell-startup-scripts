##################################################
################# Bash commands  #################
#------------------------------------------------#
# add color output
alias ls='ls --color=auto'
#show details in jobs output
alias jobs='jobs -l'
#show human readable details when using ll
alias ll='ls -lhaF'

#get shorter date output
alias date-short='date +%m_%d_%Y_%H%M%S'
alias date-read='date +%b_%d_%Y_%a_%H:%M:%S'

#my source code generator tool
alias addheader='~jason/Projects/header-comment-generate/addheader.sh'

#grep with colour and line number
alias grep='grep -n --color=always'
alias egrep='egrep -n --color=always'
alias fgrep='fgrep -n --color=always'
##################################################
#
#-------------- ctags for omni completion -------#
alias ctags-omni='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++'


##################################################
################# cscope related  ################
#------------------------------------------------#
#cscope index creation, useless
alias cscope-indexer='cscope -Rbkq'
#create cscope database with a specified list file
alias cscope-from-list='cscope -bki'
#create source files list for cscope
alias cscope-create-list='find \( -iname "*.c*" -o -iname "*.h" -o -iname "*.mk" -o -iname "*.mak" -o -iname "*.make" -o -iname "*.s" -o -iname "*.ia" -o -iname "*.inc" \) -exec echo \"{}\" \;  >cscope.files'
##################################################

##################################################
##################### CVS  ######################
alias cvs-n-update='cvs -n update 2>/dev/null'
alias cvs-diff-less='cvs -n diff 2>/dev/null | less'

##################################################
################## vim related  ##################
#------------------------------------------------#
#run vim and load a certain session
alias vimsession='vim -S'
##################################################
#
################## Functions  ##################
#------------------------------------------------#
# function getfunc() { 
# 	grep -i "$1" ~/Projects/Docsis_Transponder/under_cvs/trunk/BFC4.4.6/CmDocsisSystem/ecos/bcm93378vms_eu/ecram.shortmap
# }
