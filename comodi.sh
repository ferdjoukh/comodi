#!/bin/bash

#################################################
# 3 parametres: $1=dossier, $2=format, $3=metamodel
#                 $4=model1, et $5=model2 
# Prend deux modeles et les compare en appelant 
# l'outil de distances
#################################################
function compareTwoXMIModels {
	model1=$1"/"$4
	model2=$1"/"$5
	java -jar comodi.jar $2 $model1 $model2 $3 > tmp
	leven=$(grep -e "levensh" tmp | cut -d, -f2)
	euclide=$(grep -e "euclide" tmp | cut -d, -f2)
	manhattan=$(grep -e "manhattan" tmp | cut -d, -f2)
	#echo $model1 $model2 
	#echo $leven,$euclide,$manhattan
}	

#################################################
# 2 parametres: $1=dossier et $2=format 
# Liste les fichiers xmi ou dot d'un dossier et
# les met dans un array
#################################################
function file2array {
	list=$(ls $1 | grep -e $2)
	((i=0))
	echo -n "" > modelList
	for file in $list 
		do	
			models[$i]=$file
			echo $file >> modelList
			((i++))
	done
	
	echo ${#models[@]} $2 "models found"	
}

if [ ! $1 ];
	then
	    # Si aucun parametre donne
	    # Afficher help
	    #
	    echo ""
	    echo "HELP"
	    echo ""
	    echo "  COMODI is a tool for comparing model sets"
   	    echo ""
	    echo "USAGE"
   	    echo ""
		echo "  ./doClustering.sh folder format metamodel";
	    echo ""
	    echo "PARAMETERS"
	    echo ""
	    echo "  folder: folder that contents models files to cluster";
		echo "  format: xmi,dot"
		echo "  metamodel: if xmi format is chosen, ecore metamodel is mondatory"
		echo ""
	    echo "PROCESSING"
	    echo ""
	    echo "  1: Comparison matrix are produced (distances in Java)"
	    echo "  2: Hierarchical clustering id done on each matrix (Requires R software)"
	    echo "  3: Most representative models are chosen (Requires R software)"
	    echo ""
	else
		if [ ! -d $1 ];
			then echo $1" is not a folder";
		else
			if [ ! $2 ];
				then echo "Please give a correct format"
			else
				if [ "$2" == "dot" ];
					then echo "dot Comparison"
					#################################
					# Dot Comparison
					#################################
				else
					if [ "$2" == "xmi" ];
						then
							if [ ! $3 ];
								then echo "Please give an Ecore metamodel"
							else
								if [ ! -f $3 ];
									then echo $3" is not an ecore metamodel file"
								else
									#echo "$2 models will be compared"
									#################################
									# XMI comparison
									#################################
									((Emin=1))
									((Emax=0))	
									((Emini=0))
									((Eminj=0))
									((Emaxi=0))
									((Emaxj=0))
									
									((Mmin=1))
									((Mmax=0))	
									((Mmini=0))
									((Mminj=0))
									((Mmaxi=0))
									((Mmaxj=0))
									
									((Lmin=1))
									((Lmax=0))	
									((Lmini=0))
									((Lminj=0))
									((Lmaxi=0))
									((Lmaxj=0))

									#List all xmi files in given folder
									file2array $1 $2

									#Build the comparison matrix
									leven_mat=""
									euclide_mat=""
									manhattan_mat=""
									echo $leven_mat > $1"/levenshtein"
									echo $euclide_mat > $1"/euclide"
									echo $manhattan_mat > $1"/manhattan"
									echo -n "Lines remaining: "
									for ((i=0;${#models[@]}-i;i++)) do
										leven_mat=""
										euclide_mat=""
										manhattan_mat=""
										for ((j=0;${#models[@]}-j-1;j++)) do	
										    #Comparer modele i et models j
										    compareTwoXMIModels $1 $2 $3 ${models[$i]} ${models[$j]}
											leven_mat=$leven_mat$leven","
											euclide_mat=$euclide_mat$euclide","
											manhattan_mat=$manhattan_mat$manhattan"," 
											
											if (( $(echo "$euclide > 0.0" |bc -l) )) && (( $(echo "$euclide < $Emin" |bc -l) )); 
												then
												Emin=$euclide
												((Emini=$i))
												((Eminj=$j))
											fi	

											if (( $(echo "$euclide > 0.0" |bc -l) )) && (( $(echo "$euclide > $Emax" |bc -l) )); 
												then
												Emax=$euclide
												((Emaxi=$i))
												((Emaxj=$j))
											fi
											#Manhattan
											if (( $(echo "$manhattan > 0.0" |bc -l) )) && (( $(echo "$manhattan < $Mmin" |bc -l) )); 
												then
												Mmin=$manhattan
												((Mmini=$i))
												((Mminj=$j))
											fi	

											if (( $(echo "$manhattan > 0.0" |bc -l) )) && (( $(echo "$manhattan > $Mmax" |bc -l) )); 
												then
												Mmax=$manhattan
												((Mmaxi=$i))
												((Mmaxj=$j))
											fi
											#Levenshtein
											if (( $(echo "$leven > 0.0" |bc -l) )) && (( $(echo "$leven < $Lmin" |bc -l) )); 
												then
												Lmin=$leven
												((Lmini=$i))
												((Lminj=$j))
											fi	

											if (( $(echo "$leven > 0.0" |bc -l) )) && (( $(echo "$leven > $Lmax" |bc -l) )); 
												then
												Lmax=$leven
												((Lmaxi=$i))
												((Lmaxj=$j))
											fi		
										done
										#Comparer modele i et models j
										#Dernier appel pour ne pas avoir la virgule a la fin    
										compareTwoXMIModels $1 $2 $3 ${models[$i]} ${models[$j]}
										leven_mat=$leven_mat$leven
										euclide_mat=$euclide_mat$euclide
										manhattan_mat=$manhattan_mat$manhattan 
										echo $leven_mat >> $1"/levenshtein"
										echo $euclide_mat >> $1"/euclide"
										echo $manhattan_mat >> $1"/manhattan"
										((r=${#models[@]}-$i))
										
										#Nombre de lignes restantes
										
										if (( $(echo "$euclide > 0.0" |bc -l) )) && (( $(echo "$euclide < $Emin" |bc -l) )); 
											then
											Emin=$euclide
											((Emini=$i))
											((Eminj=$j))
										fi	

										if (( $(echo "$euclide > 0.0" |bc -l) )) && (( $(echo "$euclide > $Emax" |bc -l) )); 
											then
											Emax=$euclide
											((Emaxi=$i))
											((Emaxj=$j))
										fi

										if (( $(echo "$manhattan > 0.0" |bc -l) )) && (( $(echo "$manhattan < $Mmin" |bc -l) )); 
											then
											Mmin=$manhattan
											((Mmini=$i))
											((Mminj=$j))
										fi	

										if (( $(echo "$manhattan > 0.0" |bc -l) )) && (( $(echo "$manhattan > $Mmax" |bc -l) )); 
											then
											Mmax=$manhattan
											((Mmaxi=$i))
											((Mmaxj=$j))
										fi

										if (( $(echo "$leven > 0.0" |bc -l) )) && (( $(echo "$leven < $Lmin" |bc -l) )); 
											then
											Lmin=$leven
											((Lmini=$i))
											((Lminj=$j))
										fi	

										if (( $(echo "$leven > 0.0" |bc -l) )) && (( $(echo "$leven > $Lmax" |bc -l) )); 
											then
											Lmax=$leven
											((Lmaxi=$i))
											((Lmaxj=$j))
										fi	
										echo -n $r" "
									done
									echo "OK"
									echo "--"
									echo "Distance matrices have been generated"
									echo "--"	
									
									echo "euclide" > min_max_distance
									echo "Furthest two models: ${models[Emaxi]} vs. ${models[Emaxj]}=$Emax" >> min_max_distance
									echo "Closest two models: ${models[Emini]} vs. ${models[Eminj]}=$Emin" >> min_max_distance
									echo "--" >> min_max_distance
									
									echo "manhattan" >> min_max_distance
									echo "Furthest two models: ${models[Mmaxi]} vs. ${models[Mmaxj]}=$Mmax" >> min_max_distance
									echo "Closest two models: ${models[Mmini]} vs. ${models[Mminj]}=$Mmin" >> min_max_distance
									echo "--" >> min_max_distance
									
									echo "levenshtein" >> min_max_distance
									echo "Furthest two models: ${models[Lmaxi]} vs. ${models[Lmaxj]}=$Lmax" >> min_max_distance
									echo "Closest two models: ${models[Lmini]} vs. ${models[Lminj]}=$Lmin" >> min_max_distance
									
									cat min_max_distance
									########################
									#	It needs folder and a matrix file (relative path)
									########################
									echo "--"	
									echo "Clustering..."
									./doMatrixClustering.sh $1 "euclide"
									./doMatrixClustering.sh $1 "manhattan"
									./doMatrixClustering.sh $1 "levenshtein"
									rm tmp
									rm modelList
									mv $1/euclide $1/clustering/euclide_matrix
									mv $1/manhattan $1/clustering/manhattan_matrix
									mv $1/levenshtein $1/clustering/levenshtein_matrix
									mv min_max_distance $1/clustering/min_max_distance
									echo "--"
									echo "Results are saved at $1clustering/*"
								 fi
							fi
					else
						echo $2" is not a correct format"
					fi	
				fi					 
			fi
		fi	
fi	