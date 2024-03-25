#!/bin/bash

if [ "$#" -eq "3" ] ; then #Vérification des 3 arguments
	if [ ! -f "$1" ]; then echo "Le fichier contenant la liste de cours n'existe pas !"; exit 1; fi # Vérifier si fichier de cours existe
	if [ ! -d "$2" ]; then echo "Le dossier à réorganiser n'existe pas !"; exit 1; fi # Vérifier si le dossier à réorganiser existe
	if [ ! -d "$3" ]; then echo "Le dossier de destination n'existe pas !"; exit 1; fi # Vérifier si le dossier de destination existe
	for cours in $(cat "$1"); do # Boucle en fonction du fichier de la liste de cours
		cd "$3"
		if [ ! -d "$PWD/University" ]; then echo "Creating University folder"; mkdir "University"; fi # Création du dossier University si non existant
		if [ ! -f "$PWD/University/log.out" ]; then echo -e "Creating/overwriting empty log file\n"; touch "$PWD/University/log.out" ; fi # Création du fichier log si non existant
		echo "Creating $cours folder"
		mkdir "University/$cours" # Création du dossier du cours actuel dans la boucle
		cd "$2"
		echo "Searching $cours files"
		# Recherche des fichiers contenant le cours repris dans la boucle, si contenant : déplacement dans le dossier de destination trié
		grep -lir "$cours" "$PWD" | xargs -r cp -t "$3/University/$cours" -v >> "$3/University/log.out"
		echo "Copying $cours files"
		# Recherche des noms de fichier contenant le cours repris dans la boucle, si contenant : déplacement dans le dossier de destination trié
		find "$PWD" -iname "*$cours*" | xargs -r cp -t "$3/University/$cours" -v >> "$3/University/log.out"
		echo -e "Log registered\n"
	done
else
	echo "Nombre d'arguments invalide !"
	exit 1; #Arrêt du script à cause d'une erreur
fi
