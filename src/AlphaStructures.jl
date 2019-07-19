module AlphaStructures
	using LinearAlgebra
	using LinearAlgebraicRepresentation, Triangle
	using Combinatorics, DataStructures
	Lar = LinearAlgebraicRepresentation
	LA = LinearAlgebra

	include("alpha_complex.jl")
	include("deWall.jl")
	include("geometry.jl")

	export alphaFilter, alphaSimplex, delaunayTriangulation
end
