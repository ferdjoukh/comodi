	#Paquets requis
	library("tripack")
	require(tikzDevice)
	library(MASS)

	#Three Parameters
	# data: matrice de distance .csv
	# filepdf: sortie .pdf
	# filetex: sortie .tex
	voronoiIt <- function(data,filepdf,filetex){

	#Lire les donnees
	matrix1 <-read.table(data, header=FALSE, sep=",")
	m <- as.matrix(matrix1)
	d <- m
	r <- sammon(d)

	# Calculer la tessellation de Voronoi
	x <- r$points
	dt <- data.frame(x)
	names(dt) <- c('x', 'y')
	dt$labels <- paste0('m', 1:nrow(x))

	#Dessiner le diagramme
	#Pdf
	pdf(filepdf)
	plot(voronoi.mosaic(x[,1], x[,2]),axis=TRUE,
		main="",xlab="",ylab="",title="")
	points(x,pch=1)
	text(dt$x,dt$y,dt$labels, pos=3)
	dev.off()

	#Tikz
	tikz(filetex)
	plot(voronoi.mosaic(x[,1], x[,2]),axis=TRUE,
		main="",xlab="",ylab="",title="")
	points(x,pch=1)
	text(dt$x,dt$y,dt$labels, pos=3)
	dev.off()
	}

###############################
# Get console args an do calls
###############################
args <- commandArgs()
fin<-length(args)
voronoiIt(args[fin-2],args[fin-1],args[fin])
