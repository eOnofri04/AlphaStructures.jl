#using AlphaStructures
using DataStructures, LinearAlgebraicRepresentation, Plasm
Lar = LinearAlgebraicRepresentation

filename = "examples/OBJ/lowpolytree.obj";
V,EVs,FVs = Lar.obj2lar(filename)
Plasm.view(V,[[i] for i = 1:size(V,2)])
#Plasm.view(V,EVs[1])
#Plasm.view(V,FVs[1])

DT = AlphaStructures.delaunayWall(V)

Plasm.view(V,DT)
