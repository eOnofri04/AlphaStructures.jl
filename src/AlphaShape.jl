module AlphaShape
	using LinearAlgebraicRepresentation, Triangle, Combinatorics
	Lar = LinearAlgebraicRepresentation

	include("alpha_complex.jl")
	include("3D_delaunay.jl")
end
