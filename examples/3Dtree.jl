using  DataStructures, LinearAlgebraicRepresentation, Plasm
Lar = LinearAlgebraicRepresentation

filename = "examples/OBJ/lowpolytree.obj";
V,EVs,FVs = Lar.obj2lar(filename)

Plasm.view(V,[[i] for i = 1:size(V,2)])

AFL = Array{Int64,1}[]
axis = [1.,0.,0.]
tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
DT = AlphaStructures.deWall(V,V,AFL,axis,tetraDict)

Plasm.view(V,DT)


filtration = AlphaStructures.alphaFilter(V);

VV,EV,FV,CV = AlphaStructures.alphaSimplex(V,filtration,0.5)

Plasm.view(V, VV)
Plasm.view(V, EV)
Plasm.view(V, FV)
Plasm.view(V, CV)
Plasm.viewexploded(V,CV)(2.,2.,2)
