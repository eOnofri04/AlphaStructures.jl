if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "First Delaunay Wall Simplex" begin

	P = [
		1.0 1.0 1.5 2.0 2.0
		0.0 0.2 1.3 1.0 1.0
		2.0 0.0 0.0 1.0 0.5
	]

	axis = 1
	off = AlphaStructures.findMedian(P, axis)
	@test sort(AlphaStructures.firstDeWallSimplex(P, axis, off)) == [1, 2, 3, 4]

	axis = 2
	off = AlphaStructures.findMedian(P, axis)
	@test sort(AlphaStructures.firstDeWallSimplex(P, axis, off)) == [2, 3, 4, 5]

	axis = 3
	off = AlphaStructures.findMedian(P, axis)
	@test sort(AlphaStructures.firstDeWallSimplex(P, axis, off)) == [2, 3, 4, 5]

end


@testset "Find Wall Simplex" begin

	@testset "2D wall simplex" begin
		P = [ 0. 1. 0  1    2.;
		 	  0  0  1. 0.2  2.;
		 	]

		@test AlphaStructures.findWallSimplex(P, [2,3], [0., 0.]; DEBUG = true) == nothing
		@test AlphaStructures.findWallSimplex(P, [1,2], [0.,1.]) == nothing
		@test AlphaStructures.findWallSimplex(P, [4,3], [0.,0.]) == [3,4,5]
	end

	@testset "3D wall simplex" begin
		P = [ 0. 1. 0  0  2.;
			  0  0  1. 0  2.;
			  0  0  0  1. 2.]
		@test AlphaStructures.findWallSimplex(P, [2,3,4], [0., 0., 0.]; DEBUG = true) == [2,3,4,5]
		@test AlphaStructures.findWallSimplex(P, [2,3,5], [0., 0., 1.]) == nothing
		@test AlphaStructures.findWallSimplex(P, [2,3,4], [2., 2., 2.])  == [1,2,3,4]
		@test AlphaStructures.findWallSimplex(P, [2,3,4], [0., 0., 0.], 1, DEBUG = true) == nothing
	end

end

@testset "Delaunay Wall" begin

	@testset "one tetrahedron" begin
		P = [
			0.0 1.0 0.0 0.0
			0.0 0.0 1.0 0.0
			0.0 0.0 0.0 1.0
		];
		DT = sort(AlphaStructures.delaunayWall(P, 1))
		@test DT == [ [1, 2, 3, 4] ]
		@test sort(AlphaStructures.delaunayWall(P, 2)) == DT
		@test sort(AlphaStructures.delaunayWall(P, 3)) == DT
	end

	@testset "two tetrahedron" begin
		P = [
			0.0 1.0 0.0 0.0 2.0
			0.0 0.0 1.0 0.0 0.0
			0.0 0.0 0.0 1.0 0.0
		];
		DT = sort(AlphaStructures.delaunayWall(P, 1))
		@test DT == [ [1, 2, 3, 4], [2, 3, 4, 5] ]
		@test sort(AlphaStructures.delaunayWall(P, 2)) == DT
		@test sort(AlphaStructures.delaunayWall(P, 3)) == DT
	end

	@testset "points on a plane" begin
		P = [
			0.0 0.0 0.0 0.0 0.0
			2.0 0.0 1.0 0.0 2.0
			0.0 0.0 0.0 1.0 2.0
		];
	 	@test_throws AssertionError AlphaStructures.delaunayWall(P, 1)
		@test_throws AssertionError AlphaStructures.delaunayWall(P, 2)
		@test_throws AssertionError AlphaStructures.delaunayWall(P, 3)
	end

	@testset "cube" begin
		P = [
			0.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0
			0.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0
			0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0
		];
		DT = sort(AlphaStructures.delaunayWall(P, 1))
		@test length(DT) == 6
		@test DT == sort(AlphaStructures.delaunayWall(P, 2))
	end

end
