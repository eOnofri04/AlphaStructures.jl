using AlphaStructures
using  DataStructures, LinearAlgebraicRepresentation, Plasm
Lar = LinearAlgebraicRepresentation

filename = "examples/OBJ/cat.obj";
P,EVs,FVs = Lar.obj2lar(filename)
Plasm.view(V,[[i] for i = 1:size(V,2)])
Plasm.view(V,EVs[1])
Plasm.view(V,FVs[1])

VV = [[i] for i = 1:size(V,2)]

DT = AlphaStructures.deWall(V,V)

Plasm.view(V,DT)
#model=(V,(VV,EVs[1],FVs[1],DT))
#Plasm.view(Plasm.numbering(2.)(model))

"""
filtration = AlphaStructures.alphaFilter(V);

VV,EV,FV,CV = AlphaStructures.alphaSimplex(V,filtration,50.)

Plasm.view(V, VV)
Plasm.view(V, EV)
Plasm.view(V, FV)
Plasm.view(V, CV)
"""
