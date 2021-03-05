__precompile__()

module AlphaStructures
	using LinearAlgebra
	using Delaunay # BUG in this package, in 3D triangulation
	using Combinatorics, DataStructures
	using Distributed
	using SharedArrays

	#using MATLAB

	include("alpha_complex.jl")
	include("geometry.jl")
	include("delaunayTriangulation.jl")

	export alphaFilter, alphaSimplex, delaunayTriangulation
end
