#!/bin/bash

# VERIFICATION
# vérification du nombre d'arguments
if [ ! $# -eq "3" ]; then
    echo "Arguments invalides. Requiert 3 arguments"
    exit 1 
fi

# vérification si les arguments sont des chemins relatifs ou absolu
cours="$1"
source="$2"
destination="$3"
[ ${cours:0:1} = "/" ] && cours="$1" || cours="$PWD/$1"
[ ${source:0:1} = "/" ] && source="$2" || source="$PWD/$2"
[ ${destination:0:1} = "/" ] && destination="$3" || destination="$PWD/$3"

#vérification de l'existence et la nature des arguments
if [ ! -f $cours ] || [ ! -d $source ] || [ ! -d $destination ]; then 
	echo "arguments incompatibles."
	exit 1
fi

#COEUR DU SCRIPT
#check si un dossier University existe déjà. Si oui, le supprime.
if [ -d "$destination/University" ]; then
	rm -r "$destination/University"
fi
mkdir "$destination/University"

touch $destination/University/log.out	#création d'un fichier vide

#Boucle while pour parcourir le fichier courses.txt et récuperer ainsi les différents cours.
while read line; do	
	#Permet de creer autant de répertoire dans $destination/University qu'il y a de cours dans courses.txt
	mkdir "$destination/University/$line"
		
	#Recherche par rapport aux noms des fichiers
	for fichier in $(find "$source" -iname *$line*); do		# -iname permet d'ignorer la casse
		cp "$fichier" "$destination/University/$line"
		echo "FROM $fichier TO $destination/University/$line" >> $destination/University/log.out
	done 
	
	#Recherhce par rapport au contenu des fichiers
	for fichier in $(grep -r -i -l $line "$source"); do		# -r recursif | -i permet d'ingnorer la casse | -l plutôt que l'output "normal" de grep, On renvoie à la place le nom du fichier dans lequel on aurait renvoyé normalement une ligne qui correspond avec le mot donné en argument.  
		cp "$fichier" "$destination/University/$line"
		echo "FROM $fichier TO $destination/University/$line" >> $destination/University/log.out
	done
done < "$cours"