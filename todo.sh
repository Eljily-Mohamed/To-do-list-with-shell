#!/bin/bash
#--------------------------------------------------------------------+
#Color picker, usage: printf ${BLD}${CUR}${RED}${BBLU}"Hello!)"${DEF}|
#-------------------------+--------------------------------+---------+
#       Text color        |       Background color         |         |
#-----------+-------------+--------------+-----------------+         |
# Base color|Lighter shade|  Base color  | Lighter shade   |         |
#-----------+-------------+--------------+-----------------+         |
BLK='\e[30m'; blk='\e[90m'; BBLK='\e[40m'; bblk='\e[100m' #| Black   |
RED='\e[31m'; red='\e[91m'; BRED='\e[41m'; bred='\e[101m' #| Red     |
GRN='\e[32m'; grn='\e[92m'; BGRN='\e[42m'; bgrn='\e[102m' #| Green   |
YLW='\e[33m'; ylw='\e[93m'; BYLW='\e[43m'; bylw='\e[103m' #| Yellow  |
BLU='\e[34m'; blu='\e[94m'; BBLU='\e[44m'; bblu='\e[104m' #| Blue    |
MGN='\e[35m'; mgn='\e[95m'; BMGN='\e[45m'; bmgn='\e[105m' #| Magenta |
CYN='\e[36m'; cyn='\e[96m'; BCYN='\e[46m'; bcyn='\e[106m' #| Cyan    |
WHT='\e[37m'; wht='\e[97m'; BWHT='\e[47m'; bwht='\e[107m' #| White   |
#----------------------------------------------------------+---------+
# Effects                                                            |
#--------------------------------------------------------------------+
DEF='\e[0m'   #Default color and effects                             |
BLD='\e[1m'   #Bold\brighter                                         |
DIM='\e[2m'   #Dim\darker                                            |
CUR='\e[3m'   #Italic font                                           |
UND='\e[4m'   #Underline                                             |
INV='\e[7m'   #Inverted                                              |
COF='\e[?25l' #Cursor Off                                            |
CON='\e[?25h' #Cursor On                                             |
#--------------------------------------------------------------------+
# Text positioning, usage: XY 10 10 "Hello World!"                   |
XY   () { printf "\e[${2};${1}H${3}";   } #                          |
#--------------------------------------------------------------------+
# Print line, usage: line - 10 | line -= 20 | line "Hello World!" 20 |
line () { printf -v LINE "%$2s"; printf -- "${LINE// /$1}"; } #      |
# Create sequence like {0..X}                                        |
cnt () { printf -v _N %$1s; _N=(${_N// / 1}); printf "${!_N[*]}"; } #|
#--------------------------------------------------------------------+


welcome=(''
    $RED" ____      ____  ________  _____       ______    ___   ____    ____  ________      \n"$DEF
    $RED"|_  _|    |_  _||_   __  ||_   _|    .' ___  | .'   \`.|_   \  /   _||_   __  |    \n"$DEF
    $GRN"  \ \  /\  / /    | |_ \_|  | |     / .'   \_|/  .-.  \ |   \/   |    | |_ \_|     \n"$DEF
    $GRN"   \ \/  \/ /     |  _| _   | |   _ | |       | |   | | | |\  /| |    |  _| _      \n"$DEF
    $BLU"    \  /\  /     _| |__/ | _| |__/ |\ \`.___.'\\\\\  \`-'  /_| |_\/_| |_  _| |__/ |\n"$DEF
    $BLU"     \/  \/     |________||________| \`.____ .' \`.___.'|_____||_____||________|   \n"$DEF
    
)

#fonction banner permet de specifie User qui lance script 
function banner (){
     for i in {1..2}
     do
	  echo ''
     done
     echo -en "\e[1m\e[32m$USER\e[0m welcome in your to do list" 
     echo ''  
}
#fonction permet  a user de choisie l'option 
function choixOption(){
    read "Commande (m pour l'aide) : "  choix
    if [[ "$reponse" =~ ^([hH][eE][lL][pP]|[mM])$ ]]
    then
       helpf
    fi
    elif [[ "$reponse" =~ ^([tT][aA][sS][kK]|[tT])$ ]]
    then 
       Ajout
    fi
    elif [[ "$reponse" =~ ^([dD][eE][lL][eE][tT]|[dD])$ ]]
    then 
       Delete
    fi
    elif [[ "$reponse" =~ ^([rR][eE][aA][dD]|[rR])$ ]]
    then 
       Affiche_list
    fi
    elif [[ "$reponse" =~ ^([eE][dD][iI][tT]|[eE])$ ]]
    then 
       Edit
    fi
    elif [[ "$reponse" =~ ^([sS][aA][vV][eE]|[wW])$ ]]
    then 
       Sauvgard
    fi
    elif [[ "$reponse" =~ ^([eE][xX][iI][tT]|[eE])$ ]]
    then 
       Exit
    fi
    else
      echo "choisi option valide "
    fi
}
#fonction qui help user a voir differnet options 
function helpf(){
    echo ''
}
#fonction permet d'ajouter une element dans le to do liste
function Ajout(){
    read -p "ajout title de votre task "  task_title
    #on doit sauvgard le nombres des lignes qui exsite dans le file
    nombre=`wc -l doeljily.txt | cut -c1`
    nombreinsert=$(($nombre + 1))
    #apres on get nombre selment with commande cut
    # for  i in $( eval echo {0..$nombre} )
    # do 
    #    echo "i = $i"
    # done 
    echo "$nombreinsert-$task_title" >> do$USER.txt
}
#fonction permet de Supprime task qui exsite dans to do list avec le numero de task
function Delete(){
      echo ''
}
#fonction permet de modifie element sur to list 
function Edit (){
      echo ''
}
#fonction permet d'affiche to do list
function Affiche_list(){
      echo ''
      echo "TO DO LIST :"
      #fonction test l'exsitance de file todo list pour cette user
      if [ -f "/opt/TODO/do$USER.txt" ];
      then
        echo "found"
        cd /opt/TODO/
        cat do$USER.txt       
      else 
        echo "not found"
        cd /opt/TODO/
        touch do$USER.txt
        Affiche_list
      fi 
}

#fonction qui permet de sauvgard le modification effectue sur le list si il exsite si no pas besoine de  appelle  cette methode
function Sauvgard (){
    echo ''
}
#fonction permet de sortire sans sauvgarde les modifications 
function Exit(){
    echo ''
}

# #fonction main point d'excution de programme
function main (){
     printf "${welcome[*]}"
     banner
     Affiche_list
     Ajout
}

main
