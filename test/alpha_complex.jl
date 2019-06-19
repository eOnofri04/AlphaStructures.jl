if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "AlphaFilter" begin

	@testset "contains" begin
		@test AlphaShape.contains([1,2,3],[1,2])
		@test !AlphaShape.contains([1,2,3],[1,4])
	end

end

@testset "delaunayTriangulation" begin

	@testset "1D delaunayTriangulation" begin
		V = [
			0. 1. 2. 9. 14. 12. 4. 7.
		]
		D = AlphaShape.delaunayTriangulation(V)
		@test D == [[1,2],[2,3],[3,7],[4,6],[4,8],[5,6],[7,8]]
	end

	@testset "2D delaunayTriangulation" begin
		V = [
			0.0 1.0 0.0 2.0;
			0.0 0.0 1.0 2.0
		]
		D = AlphaShape.delaunayTriangulation(V)
		@test D == [[1,2,3],[2,3,4]]
	end
end

@testset "found_alpha" begin

	@testset "2D found_alpha" begin
		T = [[1., 1.], [2., 2.]]
		P = [[1., 0.], [2., 0.], [3., 0.]]
		Q = [[0., 0.], [2., 0.], [0., 2.]]
		@test AlphaShape.found_alpha(T) == sqrt(2)/2
		@test AlphaShape.found_alpha(P) == Inf
		@test isapprox(AlphaShape.found_alpha(Q), sqrt(2), atol=1e-4)
	end

	@testset "3D found_alpha" begin
		T = [[1., 1., 0.], [2., 2., 0.]]
		P = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.]]
		Q = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.], [0. ,0. ,1.]]
		R = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.], [0. ,0. ,0.]]
		@test AlphaShape.found_alpha(T) == sqrt(2)/2
		@test isapprox(AlphaShape.found_alpha(P), 1., atol=1e-4)
		@test AlphaShape.found_alpha(Q) == 1.
		@test AlphaShape.found_alpha(R) == Inf
	end

end

@testset "vertex_in_circumball" begin

	@testset "2D vertex_in_circumball" begin
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

	@testset "3D vertex_in_circumball" begin
		@testset "edge and triangle" begin
			V=[
				0. 1. 0.;
				0. 0. 1.;
				0. 0. 0.
			]
			simplex = [2, 3]
			up_simplex = [1, 2, 3]
			point = V[:, setdiff(up_simplex, simplex)]
			T=[ V[:, v] for v in simplex ]
			@test AlphaShape.vertex_in_circumball(T, AlphaShape.found_alpha(T), point)
		end

		@testset "triangle and tetrahedron" begin
			V=[
				0. 1. 0. 0.;
				0. 0. 1. 0.;
				0. 0. 0. 1.
			]
			simplex = [2, 3, 4]
			up_simplex = [1, 2, 3, 4]
			point = V[:, setdiff(up_simplex, simplex)]
			T=[ V[:, v] for v in simplex ]
			@test AlphaShape.vertex_in_circumball(T, AlphaShape.found_alpha(T), point)
		end
	end

end
