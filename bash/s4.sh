#!/bin/bash

> log.out #On renitialise le fichier log.out

if [[ $# != 3 ]]
then
    echo "On attend 3 paramètres, courses.txt source_dir dest_dir, cela n'a pas été respecté"
    echo "Arrêt du script !"
    exit
fi


if [[ $1 == *.txt ]] #Condition de vérification que le fichier contenant les cours est bien un fichier text
then 
    echo "Le fichier des cours a la bonne extension."
else
    echo "Le fichier contenant les cours n'est pas au bon format."
    echo "Arrêt du script !"
    exit
fi

if [[ $1 != /* ]] #Vérification que le fichier contenant les cours est passé en chemin complet ou non
then 
    courses_file=$PWD/$1
    echo "Nouvelle route pour le fichier des cours: $courses_file"
else
    courses_file=$1
    echo "La route du fichier des cours est : $courses_file"
fi

if [[ -f $courses_file ]] #Vérification que le fichier contenant les cours existe
then
    echo "Le fichier des cours existe"
else
    echo "Le fichier des cours n'existe pas au chemin renseigné"
    echo "Arrêt du script"
    exit
fi

if [[ $2 != /* ]] #Vérification que le répertoire source est passé en chemin complet ou non
then 
    source_dir=$PWD/$2
    echo "Nouvelle route pour le répertoire source: $source_dir"
else
    source_dir=$2
    echo "La route du répertoire source: $source_dir"
fi

if [[ -d $source_dir ]] #Vérification que le répertoire source existe
then
    echo "Le répertoire source existe"
else
    echo "Le répertoire source n'existe pas au chemin renseigné"
    echo "Arrêt du script"
    exit
fi

if [[ $3 != /* ]] #Vérification que le répertoire destination est passé en chemin complet ou non
then 
    dest_dir=$PWD/$3
    echo "Nouvelle route pour le répertoire destination: $dest_dir"
else
    source_dir=$3
    echo "La route du répertoire destination: $dest_dir"
fi

if [[ -d $dest_dir ]] #Vérification que le répertoire destination existe
then
    echo "Le répertoire destination existe"
else
    echo "Le répertoire destination n'existe pas au chemin renseigné"
    echo "Arrêt du script"
    exit
fi

mkdir $dest_dir/"University" #On crée le repertoire University

while read -r course
do
    mkdir $dest_dir/"University"/$course #Création du répertoire du cours si il existe pas
    echo "Recherche du cours $course"
    #La ligne ci dessous, recherche les fichiers contenants le nom du cours sans faire attention à la casse puis va les deplacer avec mv et ecrire un log par la suite
    find $source_dir -iname *$course* -exec mv '{}' $dest_dir/"University"/$course ';' -exec echo "FROM {} TO $dest_dir/University/$course" >> log.out ';'
    echo "Cours $course déplacé"
done < "$courses_file"