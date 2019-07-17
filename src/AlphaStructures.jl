module AlphaStructures
	using LinearAlgebraicRepresentation, Triangle, Combinatorics, DataStructures
	Lar = LinearAlgebraicRepresentation

	using LinearAlgebra
	LA=LinearAlgebra

	#include("alpha_complex.jl")
	include("3D_delaunay.jl")
	#include("geometry.jl")
	include("_geometry.jl")
	#include("deWall.jl")
end
