__precompile__()

module AlphaStructures
	using LinearAlgebra
	using Delaunay # used in 3D triangulation --->> warning Test possible BUG in this package
	using Triangulate # used in 2D triangulation
	using Combinatorics, DataStructures
	using Distributed
	using SharedArrays

	#using MATLAB

	include("alpha_complex.jl")
	include("geometry.jl")
	include("delaunayTriangulation.jl")

	export alphaFilter, alphaSimplex, delaunayTriangulation
end
