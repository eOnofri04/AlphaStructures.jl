__precompile__()

module AlphaStructures
	using LinearAlgebraicRepresentation
	using MATLAB
	#using Delaunay #BUG in package
	using Combinatorics, DataStructures
	using Distributed
	Lar = LinearAlgebraicRepresentation

	include("alpha_complex.jl")
	#include("deWall.jl")
	include("geometry.jl")
	include("delaunayTriangulation.jl")

	export alphaFilter, alphaSimplex, delaunayTriangulation
end
