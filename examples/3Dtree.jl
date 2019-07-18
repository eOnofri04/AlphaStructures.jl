#using AlphaStructures
using  DataStructures, LinearAlgebraicRepresentation, Plasm
Lar = LinearAlgebraicRepresentation

filename = "examples/OBJ/lowpolytree.obj";
V,EVs,FVs = Lar.obj2lar(filename)

Plasm.view(V,[[i] for i = 1:size(V,2)])

DT = AlphaStructures.deWall(V,V)

#to view Delaunay Triangulation
Plasm.view(V,DT)
Plasm.viewexploded(V,DT)(2.,2.,2)


filtration = AlphaStructures.alphaFilter(V);

VV,EV,FV,CV = AlphaStructures.alphaSimplex(V,filtration,0.5)

#to view alpha complex
#Plasm.view(V, VV)
Plasm.view(V, EV)
Plasm.view(V, FV)
Plasm.view(V, CV)
Plasm.viewexploded(V,CV)(2.,2.,2)

# view colored, different colors for each cell
CVs = [[CV[i]] for i = 1:length(CV)]
Plasm.viewcolor(V, CVs)
