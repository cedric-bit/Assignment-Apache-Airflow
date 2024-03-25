#!/bin/bash
##############################################
#            projet bash
#     nom:  Kouamou Djampo 
#  prenom:  Cedric
# matricule: 000487814
#
##############################################

##verification du nombre de parametre 3 attentue

if [ "${#}" -ne "3" ]; then
    echo "Mauvais nombre de paramètres (3 attendu)">&2
    exit 1
fi
### verification si le premier parametre qui est un fichier existe

if [ ! -e "$1" ]; then
    echo "Fichier inexistant.">&2
    exit 1
fi

## fichier regulier?

if [ ! -f "$1" ]; then
    echo "the path is not the file">&2
    exit 1
fi

##readbility

if [ ! -r "$1" ]; then
    echo "not readable">&2
    exit 1
fi

### verification si les deux parametres sont bel et bien les repertoire

if [ ! -d "$2" ] || [ ! -d "$3" ] ; then
    echo "bad directory">&2
    exit 1
fi


#### code principale #########

file_seach="$1"
file_explore="$2"
file_destination="$3"
 cur_dir="$(pwd)" 
###########################################################################
#connaissant le nombre de dossier et sous dossiers
#a creer dans le repertoire de destination il est préferable de ce redirigé
#dans ce repertoire (tout en gardant la trace du repertoire courant
#d'ou la necessité de la variable cur_dir)
#et creé ses dossier d'ou l'utilité de mkdir
#
#############################################################################

 if [  -d "${file_destination}" ]; then
           cd "${file_destination}"
       
             mkdir -p university/{INFO-F101,INFO-F102,INFO-F103,INFO-F104}
  fi 
cd  "${cur_dir}"
###############################################################################
#ici il est question d'effectuer une recherche dans 
#les repertoires, dossier et sous dossier donc il serait question
#d'effectuer un parcour recursif dans tous repertoire 
#etant donné que nous avons vu lors des scéance de tp comment
#effectuer un parcours recursif nous avons donc exploité les bouts
#de code des differents TP
# la fonction list permet de liste le contenu d'un repertoire et stoke le 
#le contenu dans une variable result ->reference TP
###############################################################################
   function list {

    local current_directory=$1
    local -n result=$2
    result=()
     
     for file in $current_directory/*; do
         result+=("$file")
    done
                    
    }
########################################################################
#comme file_explore est un repertoire a effectuer nos recherche 
#
#la recherche s'effectue sur le nom des cours a suvre au total 4 cours
# il est donc simple pour moi de creé 4 filtre et stoker le resultalt des 
#recherche à l'interieure des different filtre ( grep -i (teni compte de la case))
#chaque filtre correspond à l'élément recherché 
#on verifie si le filtre n'est pas vide et on copie le contenu dans le 
#repertoire correspond et un log.out est generé 
##############################################################################""

  fine_file=($file_explore)


while [ ${#fine_file[@]} -gt 0 ]; do
    current_directory=${to_visit[0]}
    fine_file=(${fine_file[@]:1})
   list $current_directory files 
  for file in ${files[@]}; do
    if [ -d "$file" ]; then
            fine_file+=("$file")
       elif [ -f "$file" ]; then
                filtered=$(echo "$file" | grep -i INFO-F101)
                filtered1=$(echo "$file" | grep -i INFO-F102)
                filtered2=$(echo "$file" | grep -i INFO-F103)
                filtered3=$(echo "$file" | grep -i INFO-F104)
            if [ ! -z "$filtered" ]; then
                  cp -R "$filtered" "$file_destination"/university/INFO-F101
                 echo "FROM $file_explore TO $file_destination /university/INFO-F101" >> "$file_destination"/university/log.out
            fi
                 if [ ! -z "$filtered1" ]; then
                   cp -R "$filtered1" "$file_destination"/university/INFO-F102
                 echo "FROM $file_explore TO $file_destination /university/INFO-F102" >> "$file_destination"/university/log.out
                  fi
                   
                if [ ! -z "$filtered2" ]; then
                   cp -R "$filtered2" "$file_destination"/university/INFO-F103
                   echo "FROM $file_explore TO $file_destination /university/INFO-F103" >> "$file_destination"/university/log.out
                fi
             if [ ! -z "$filtered3" ]; then
                   cp -R "$filtered3" "$file_destination"/university/INFO-F104
                     echo "FROM $file_explore TO $file_destination /university/INFO-F104" >> "$file_destination"/university/log.out
                fi          
                  
      fi
  done
done 