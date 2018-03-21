#!/bin/bash

if [ ! $1 ];
	then
	    # Si aucun parametre donne
	    # Afficher help
	    #
	    echo ""
	    echo "HELP"
	    echo ""
   	    echo "  This is a matrix clustering tool"
   	    echo "  Use it when your matrix is already available"
   	    echo ""
	    echo "USAGE"
   	    echo ""
		echo "  ./doMatrixClustering.sh folder matrix";
	    echo ""
	    echo "PARAMETERS"
	    echo ""
	    echo "  folder: folder that contents models files to cluster";
		echo "  matrix: distance matrix file"
		echo ""
	    echo "PROCESSING"
	    echo ""
	    echo "  1: Voronoi diagram is plot (requires R software)"
	    echo "  2: Hierarchical clustering id done on each matrix (requires R software)"
	    echo "  3: Most representative models are chosen (requires R software)"
	    echo ""
	else
		if [ ! -d $1 ];
			then echo $1" is not a folder";
		else
			if [ ! $2 -o ! -f $1"/"$2 ];
				then echo "Please give a correct matrix file"
			else
				if [ ! -d $1"/clustering" ]
					then
					mkdir $1"/clustering"
				fi

				if [ -f /usr/bin/R ] && [ -f /usr/bin/Rscript ];
					then
					fol=$1"/clustering" 	
					#Plot clustering tree
					Rscript --vanilla hierarchicalClustering.r $1"/"$2 $fol"/"$2"clustering.pdf" $fol"/"$2"clustering.tex" >& /dev/null
					#Plot Voronoi diagram
					Rscript --vanilla voronoi.r $1"/"$2 $fol"/"$2"voronoi.pdf" $fol"/"$2"voronoi.tex" >& /dev/null
					#Get clusters and their models

					echo "--"
					echo "$2"
					cat clusters | sed -e 's/^,//g' | nl -w1 -nln -s: | sed -e 's/^/Cluster/g' > theClusters
					cat theClusters
					mv theClusters $1/"clustering"/$2"Clusters"
					rm clusters
				else
					echo "Error: R and Rscript are not available on computer"
					echo "Please install them and run COMODI again"
				fi	
			fi
		fi
					
fi					 	