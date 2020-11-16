using AlphaStructures
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

#include("deWall.jl")
include("delaunay.jl")
include("alpha_complex.jl")
include("geometry.jl")
