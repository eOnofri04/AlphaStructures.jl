include("../src/AlphaShape.jl")
using Plasm, Triangle, LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

filename = "examples/svg_files/Lar2.svg";
V,EV = Plasm.svg2lar(filename);

Vi, Ve, VVi, VVe = AlphaShape.pointsRand(V, EV, 1000, 10000);

Plasm.view(Vi, EVi)
Plasm.view(Ve, EVe)
