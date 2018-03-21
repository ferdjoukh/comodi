# comodi

**COMODI** (**CO**unting **MO**del **DI**fferences) is a tool for model comparison. It consists in two different parts. The first one, written in java, is used to measure differences between two models using the above 4 metrics. The second part, written in bash and R, provides algorithms for handling model sets (comparison, diversity estimation and clustering).

# COMODI tool for comparing model sets

COMODI (COunting MOdel DIfferences) is a tool for measuring model differences. It provides several algorithms and distance metrics to compare 2 models (dot or xmi files). Given a folder of models, COMODI creates distance matrices comparing all the models inside that folder. Then, a hierarchical clustering is performed and the most representative models of the folder are automatically chosen.

A human readable graphical representation is also plotted. It easily shows the coverage of solutions’ space of a model set. Finally, some extra statistics are computed over the input folder (closest models, average distance).

# Get it and use it

COMODI is free and it usage is simple. Download it (jar, all scripts, examples)

Get Comodi here. This archive contains:

-COMODI.jar to compare two models (xmi or dot files).
-COMODI.sh to handle a folder of models.
-Matrix clustering script.
-R scripts (clustering, voronoi).

# Examples

Example models and meta-model [zip][zip]

# Required

Linux, R software (+ tripack, tikzdevice packages)

