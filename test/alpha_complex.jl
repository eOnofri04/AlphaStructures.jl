if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "AlphaFilter" begin

	@testset "contains" begin
	#	@test AlphaShape.contains([1,2,3],[1,2])==true
	#	@test AlphaShape.contains([1,2,3],[1,4])==false
	end

end

@testset "delaunayTriangulation" begin

	V = [
		0.0 1.0 0.0 2.0;
		0.0 0.0 1.0 2.0
	]
	D = AlphaShape.delaunayTriangulation(V)
	@test D == [[1,2,3],[2,3,4]]

end

@testset "found_alpha" begin
	T = [[1., 1.], [2., 2.]]
	P = [[1., 0.], [2., 0.], [3., 0.]]
	Q = [[0., 0.], [2., 0.], [0., 2.]]
	@test AlphaShape.found_alpha(T)==sqrt(2)/2.
	@test AlphaShape.found_alpha(P)==Inf
	@test isapprox(AlphaShape.found_alpha(Q), sqrt(2), atol=1e-4)
end

@testset "vertex_in_circumball" begin
	V=[
		0. 1. 0.;
		0. 0. 1.
	]
	simplex = [2, 3]
	up_simplex = [1, 2, 3]
	point = V[:, setdiff(up_simplex, simplex)]
	T=[ V[:, v] for v in simplex ]
	@test AlphaShape.vertex_in_circumball(T, AlphaShape.found_alpha(T), point)
end
