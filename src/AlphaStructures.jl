module AlphaStructures
	using LinearAlgebraicRepresentation, Triangle
	using Combinatorics, DataStructures
	Lar = LinearAlgebraicRepresentation

	include("alpha_complex.jl")
	include("deWall.jl")
	include("geometry.jl")

	export alphaFilter, alphaSimplex, delaunayTriangulation
end
