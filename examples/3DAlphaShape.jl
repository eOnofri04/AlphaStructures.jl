include("../src/AlphaShape.jl")
using Plasm, LinearAlgebraicRepresentation
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

filename = "examples/OBJ/lowpolytree.obj";
V,EVs,FVs = Lar.obj2lar(filename)

Plasm.view(V,[[i] for i = 1:size(V,2)])
