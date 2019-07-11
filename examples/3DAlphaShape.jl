using AlphaStructures
using  DataStructures, LinearAlgebraicRepresentation, Plasm
Lar = LinearAlgebraicRepresentation

filename = "examples/OBJ/teapot.obj";
V,EVs,FVs = Lar.obj2lar(filename)
Plasm.view(V,[[i] for i = 1:size(V,2)])
Plasm.view(V,EVs[1])
Plasm.view(V,FVs[1])

filename = "examples/OBJ/cat.obj";
V,EVs,FVs = Lar.obj2lar(filename)

Plasm.view(V,[[i] for i = 1:size(V,2)])
Plasm.view(V,EVs[1])
Plasm.view(V,FVs[1])

AFL = Array{Int64,1}[]
axis = [1.,0.,0.]
tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
DT = AlphaStructures.deWall(V,V,AFL,axis,tetraDict)

Plasm.view(V,DT)

filtration = AlphaStructures.alphaFilter(V);

VV,EV,FV,CV = AlphaStructures.alphaSimplex(V,filtration,50.)

Plasm.view(V, VV)
Plasm.view(V, EV)
Plasm.view(V, FV)
Plasm.view(V, CV)
