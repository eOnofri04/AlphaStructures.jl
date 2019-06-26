include("../src/AlphaShape.jl")
using Plasm, Triangle, LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

filename = "examples/svg_files/Lar2.svg";
V,EV = Plasm.svg2lar(filename);

Vi, Ve, VVi, VVe = AlphaShape.pointsRand(V, EV, 1000, 10000);

Plasm.view(Vi, VVi)
Plasm.view(Ve, VVe)

filtration = AlphaShape.AlphaFilter(Vi)
VV,EV,FV = AlphaShape.AlphaSimplex(V,filtration)

Plasm.view(Vi, VV)
Plasm.view(Vi, EV)
Plasm.view(Vi, FV)
