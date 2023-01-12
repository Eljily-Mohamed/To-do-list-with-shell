#!/bin/bash
#variable Generale --------------------------------------------------+
termine=0
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
    read -p "Commande (m pour l'aide) : "  reponse
    if [[ "$reponse" =~ ^([hH][eE][lL][pP]|[mM])$ ]]
    then
       helpf 
       sleep 10
       main
    elif [[ "$reponse" =~ ^([tT][aA][sS][kK]|[tT])$ ]]
    then 
       Ajout
       main
    elif [[ "$reponse" =~ ^([dD][eE][lL][eE][tT]|[dD])$ ]]
    then 
       Delete
       main
    elif [[ "$reponse" =~ ^([rR][eE][aA][dD]|[rR])$ ]]
    then 
       Affiche_list
       main
    elif [[ "$reponse" =~ ^([eE][dD][iI][tT]|[eE])$ ]]
    then 
       Edit
       main
    elif [[ "$reponse" =~ ^([sS][aA][vV][eE]|[wW])$ ]]
    then 
       Sauvgard
    elif [[ "$reponse" =~ ^([eE][xX][iI][tT]|[eE])$ ]]
    then 
       Exit
    else
      echo "choisi option valide "
      sleep 2
      main
    fi
}
#fonction qui help user a voir differnet options 
function helpf(){
    echo ""
    echo "  Générique
   d   supprimer une task
   p   afficher les differentes tasks
   l   afficher les types de partitions connues
   n   ajouter une nouvelle partition
   p   afficher la table de partitions
   t   modifier le type d'une partition
   v   vérifier la table de partitions
   i   Afficher des renseignements sur la partition"

}

#fonction permet d'ajouter une element dans le to do liste
function Ajout(){
    read -p "ajout title de votre task "  task_title
    if [ -f "/opt/TODO/do$USER.txt" ];
    then
    cd /opt/TODO/
    #on doit sauvgard le nombres des lignes qui exsite dans le file
    nombre=`wc -l doeljily.txt | cut -c1`
    nombreinsert=$(($nombre + 1))
    #apres on get nombre selment with commande cut
    # for  i in $( eval echo {0..$nombre} )
    # do 
    #    echo "i = $i"
    # done 
    echo "$nombreinsert-$task_title" >> do$USER.txt
    else 
    cd /opt/TODO/
    touch do$USER.txt
    echo "1-$task_title" >> do$USER.txt
    fi
}
#fonction permet de Supprime task qui exsite dans to do list avec le numero de task
function Delete(){
      #on doit delet taks donc on doit recupere l'emplecement de task
      cd /opt/TODO/
      nombre=`wc -l do$USER.txt | cut -c1`
      read -p "Numéro de Task (1-$nombre, $nombre par défaut)" taskdelet
      if [[ $taskdelet -eq '' ]]
      then
          if [[ $nombre -eq '1' ]]
          then
          taskdelet=$(($nombre))
          rm do$USER.txt
          else
          taskdelet=$(($nombre))
          #head -l (($taskdelet - 1)) do$USER.txt > do$USER.txt
          head -$(($taskdelet -1)) do$USER.txt | sed '/^[[:space:]]*$/d' > do$USER.del.txt
          rm do$USER.txt 
          mv do$USER.del.txt do$USER.txt
          #tail -$(($nombre - $taskdelet)) >> do$USER.del.txt
          fi
      else 
          tasknext=$(($nombre - $taskdelet))
          head -$(($taskdelet -1)) do$USER.txt | sed '/^[[:space:]]*$/d' > do$USER.del.txt
          tail -$(($tasknext)) do$USER.txt >> do$USER.del.txt
          rm do$USER.txt
          compte=0
          while IFS= read -r line; do
          compte=$(($compte+1))
          task=`echo $line | cut -d '-' -f 2`
          echo "$compte-$task"  >> do$USER.txt
          done <  do$USER.del.txt
          rm do$USER.del.txt
          #mv do$USER.del.txt do$USER.txt
      fi
}

#fonction permet de modifie element sur to list 
function Edit (){
      cd /opt/TODO/
      read -p "Edit le task numero : " reponseEdit 
      read -p "New task : " reponseNew
      nombre=`wc -l do$USER.txt | cut -c1`
      if [[ $reponseEdit < $nombre ]]
      then
        for  i in $( eval echo {0..$nombre} )
        do 
          if [[ $i != $reponseEdit ]] 
          then
             awk "NR==$i" do$USER.txt >> fileEdit.txt
             echo "done editing" 
          else 
             echo "$i-$reponseNew" >> fileEdit.txt
          fi 
        done
        #un cas de validation on doit exsite cette commande pour suprimer le  fichier qui exsiet deja et remplace par celui qui stocke le modification 
        rm do$USER.txt
        mv fileEdit.txt do$USER.txt 
      else
         echo "numero ne pas valide "
         sleep 1
         Edit
      fi
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
     clear
     printf "${welcome[*]}"
     banner
     choixOption
}
#fonction main point d'excution de programme
main
