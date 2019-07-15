module AlphaStructures
	using LinearAlgebra
	using LinearAlgebraicRepresentation, Triangle
	using Combinatorics, DataStructures
	Lar = LinearAlgebraicRepresentation
	LA = LinearAlgebra

	include("alpha_complex.jl")
	include("3D_delaunay.jl")
	include("geometry.jl")
end
