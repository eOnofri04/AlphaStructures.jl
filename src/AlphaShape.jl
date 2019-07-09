module AlphaStructures
	using LinearAlgebraicRepresentation, Triangle, Combinatorics, DataStructures
	Lar = LinearAlgebraicRepresentation

	include("alpha_complex.jl")
	include("3D_delaunay.jl")
	include("geometry.jl")
end
