#!/bin/bash
if [ ! $1 ];
	then
	    # Si aucun parametre donne
	    # Afficher help
	    #
	    echo "--------------------------------------------------------"
	    echo "Help"
   	    echo "--------------------------------------------------------"
   	    echo ""
	    echo "Usage"
   	    echo ""
		echo "  ./newExtension.sh dir format1 format2";
	    echo ""
	    echo "Parameters"
	    echo ""
		echo "  dir: content the files to convert";
		echo "  format1: Old file extension"
		echo "  format2: New file extension"
		echo ""
	    echo "--------------------------------------------------------"

	else
		if [ ! -d $1 ];
			then
			echo $1" is not a directory !"
		else
			if [ ! $2 ];
				then 
				echo "Please give the source file extension !"
			else
				if [ ! $3 ];
					then
					echo "Please give the target file format !"
				else
					#Les parametres sont corrects, conversion possible
					echo 'Conversion from '$2' files to '$3' files';
					((nb=0));

					dirname=$(echo 'newModelsSet')	
					if [ ! -d "$1/$dirname" ];
						then
						mkdir "$1/$dirname"
					fi	

					list=$(ls $1 | grep -e $2)
					for source in $list 
						do
							#Remove the old extension
							racine=$(echo $source | cut -d. -f1)
							#Concatenate the new extension
							target=$(echo $racine.$3)
							#Create the new file	
							cp $1'/'$source $1$dirname'/'$target
							((nb++))
					done		
					echo $nb' files were converted';
				fi
			fi	
		fi	
fi