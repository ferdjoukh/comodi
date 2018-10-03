#Required libs and packages
library("tripack")
require(tikzDevice)
library(MASS)
	
# This function plots voronoi diagram for a given distance matrix (csv file)
#
# PARAMS
# 	data: distance-matrix.csv
# 	filepdf: output.pdf
# 	filetex: output.tex
#
######
voronoiIt <- function(data,filepdf,filetex){

	#Read CSV file
	matrix1 <-read.table(data, header=FALSE, sep=",")
	m <- as.matrix(matrix1)
	
	#Remove clone lines
	#r <- unique(m)


	r <- addEpsilonValues(m)
	r <- sammon(r)

	#Add labels to the computed points
	x <- r$points	
	dt <- data.frame(x)
	names(dt) <- c('x', 'y')

	#dt$labels <- paste0('m', nonClones(m))
	dt$labels <- paste0('m', 1:ncol(m))

	#Dessiner le diagramme
	#Pdf
	pdf(filepdf)
	plot(voronoi.mosaic(x[,1], x[,2]),axis=TRUE,main="",xlab="",ylab="",title="")
	points(x,pch=1)
	text(dt$x,dt$y,dt$labels, pos=3)
	dev.off()

	#Tikz
	tikz(filetex)
	plot(voronoi.mosaic(x[,1], x[,2]),axis=TRUE,main="",xlab="",ylab="",title="")
	points(x,pch=1)
	text(dt$x,dt$y,dt$labels, pos=3)
	dev.off()
	}


# This function returns the line numbers of non Clone models
# The result is used for labelling the voronoi diagram points
nonClones <- function(matrix){

	dup <- duplicated(matrix)
	result <- vector()

	for (i in 1:ncol(matrix)) {
		if(!dup[i]){
			result <- c(result,i)			
		}
	}
	return(result)
}

# sammon cannot accept zero or negative for non-self values.
# eg. matrix[1,2] = 0 is not possible
# 
# To avoid this case, we add an epsilon values to the matrix in the wrong cases
#
addEpsilonValues <- function(matrix){

	for (i in 1:ncol(matrix)) {
		for (j in 1:nrow(matrix)) {
			if(matrix[i,j]<=0 && i!=j){
				matrix[i,j]=0.0001
			}
		}
	}

	return(matrix)
}


###############################
# Get console args an do calls
###############################
args <- commandArgs()
fin<-length(args)
voronoiIt(args[fin-2],args[fin-1],args[fin])