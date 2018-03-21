#Ce fichier une fois chargé permet de charger des 
#fonctions pour realiser du clustering hierarchique

require('tikzDevice')

############################
#Clustering
############################
#
# mat: une matrice de distance carree
#
myhclust <- function(mat){
	#En faire une matrice de distance	
	y<-dist(mat,method="maximum")
	#Claculer l'arbre de clustering
	x=hclust(y)

	return(x)
}

############################
#Clustering
############################
#
# fiche: un fichier csv contenant la matrice
#
myhclusters <- function(fiche){

    #Lire le fichier csv
	mat1 <-read.table(fiche, header=FALSE, sep=",")
	mat <- as.matrix(mat1)
	#En faire une matrice de distance	
	y<-dist(mat,method="maximum")
	#Claculer l'arbre de clustering
	x=hclust(y)

	return(x)
}

############################
#Plotting
############################
#
# x: objet cluster 
#
myplot <- function(x, pdfile="pdf",texfile="tex") {

	if(pdfile=="pdf" && texfile=="tex"){
		plot(x,main="Trees of Clusters",ylab="height",xlab="")
	}
	else
	{
		if(pdfile!="pdf")
		{
			pdf(pdfile)
			plot(x,main="Trees of Clusters",ylab="height",xlab="")
			dev.off()
		}
		if(texfile!="tex")
		{
			tikz(texfile)
			plot(x,main="Trees of Clusters",ylab="height",xlab="")
			dev.off()
		}
	}
}

#####################################
# Le vecteur apres clusters
#####################################
#
# x: cluster object
# recall: precision [0,1]
# 0: n clusters
# 1: 1 cluster
#
vectorOfClusters <- function(x, recall=0.8){
	precision= recall* max(x$height)
	y= cutree(x,h=precision)
	return(y)
}

#####################################
# nombre de clusters
#####################################
#
# x: cluster object
# recall: precision [0,1]
# 0: n clusters
# 1: 1 cluster
#
numberOfClusters <- function(x, recall=0.8){
	y=vectorOfClusters(x,recall)
	return(max(y))
}

######################################
# Les modeles represntatifs
######################################
#
# x: cluster object
# recall: precision [0,1]
# 0: n clusters
# 1: 1 cluster
#
representatifs <- function(x, rec=0.8){

    y= vectorOfClusters(x,recall=rec)

    vec <- vector(mode="integer", length=max(y))
    now <- vector(mode="integer", length=length(y))
    j<-1	

    print(length(vec))
   	print(length(now))

    for(i in 1:length(y)){

        if (! y[i] %in% now)
        {     	
    	  vec[j] <- i
    	  j <- j+1	  
        }

        now[i]=y[i]        
    }

    print(now)
    return(vec)
}

################################
# clusters et their modeles
################################
#
# x: cluster object
# recall: precision [0,1]
# 0: n clusters
# 1: 1 cluster
#
clustersModels <- function(x,rec=0.8){

	models=read.table("modelList",header=FALSE)

	y= vectorOfClusters(x,recall=rec)
	mat<- vector(mode="character",length=max(y))

	for(i in 1:length(y)){
        colonne=y[i]
		print(colonne)
		mat[colonne]<- paste0(mat[colonne],',',models$V1[i])      
    }
    print(mat)

    return(mat)
}


###############################
# Get console args an do calls
###############################
args <- commandArgs()
fin<-length(args)
x=myhclusters(args[fin-2])
myplot(x,args[fin-1],args[fin])
y=clustersModels(x)
write(y,file="clusters")