if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "Find Center" begin

	P = [
		0.0 1.0 0.0 0.0
		0.0 0.0 1.0 0.0
		0.0 0.0 0.0 1.0
	]

	@testset "Points Find Center" begin
		@test AlphaStructures.findCenter(P[1:1, 2:2]) == [1.0]
		@test AlphaStructures.findCenter(P[1:2, 2:2]) == [1.0, 0.0]
		@test AlphaStructures.findCenter(P[1:3, 2:2]) == [1., 0.0, 0.0]
	end

	@testset "Edges Find Center" begin
		@test AlphaStructures.findCenter(P[1:1, 1:2]) == [0.5]
		@test AlphaStructures.findCenter(P[1:2, 1:2]) == [0.5, 0.0]
		@test AlphaStructures.findCenter(P[1:3, 1:2]) == [0.5, 0.0, 0.0]
	end

	@testset "Triangles Find Center" begin
		@test AlphaStructures.findCenter(P[1:2, 1:3]) == [0.5, 0.5]
		@test AlphaStructures.findCenter(P[1:3, 1:3]) == [0.5, 0.5, 0.0]
	end

	@testset "Tetrahedrons Find Center" begin
		@test AlphaStructures.findCenter(P[1:3, 1:4]) == [0.5, 0.5, 0.5]
	end

end

#–------------------------------------------------------------------------------

@testset "Find Closest Point" begin
	P = [
		0.0 1.0 2.0 3.0 4.0
		0.0 3.0 2.0 2.0 1.0
		0.0 5.0 6.0 2.0 2.0
	]

	@testset "1D closest point" begin
		idxs = [2; 3; 4; 5]
		@test AlphaStructures.findClosestPoint(P[[1], [1]], P[[1], idxs]) == 1
		@test AlphaStructures.findClosestPoint(P[[2], [1]], P[[2], idxs]) == 4
		@test AlphaStructures.findClosestPoint(P[[3], [1]], P[[3], idxs]) == 3
	end

	@testset "2D closest point" begin
		idxs = [2; 3; 4; 5]
		σ = [1]
		while length(σ) <= 2
			newidx = idxs[
					AlphaStructures.findClosestPoint(P[1:2, σ], P[1:2, idxs])
			]
			idxs = [i for i in idxs if i ≠ newidx]
			σ = [σ; newidx]
		end
		@test σ == [1; 3; 2]
	end

	@testset "3D closest point" begin
		idxs = [2; 3; 4; 5]
		σ = [1]
		while length(σ) <= 3
			newidx = idxs[
					AlphaStructures.findClosestPoint(P[1:3, σ], P[1:3, idxs])
			]
			idxs = [i for i in idxs if i ≠ newidx]
			σ = [σ; newidx]
		end
		@test σ == [1; 4; 5; 3]
	end

end

#-------------------------------------------------------------------------------

@testset "FindMedian" begin

	P = [
		0.0 1.0 0.0 0.0
		0.0 0.0 2.0 0.0
		0.0 0.0 0.0 3.0
	]

	@test AlphaStructures.findMedian(P, 1) == 0.5
	@test AlphaStructures.findMedian(P, 2) == 1.0
	@test AlphaStructures.findMedian(P, 3) == 1.5

end

#-------------------------------------------------------------------------------

@testset "Find Radius" begin

	P = [
		0.0 1.0 0.0 0.0 0.0
		0.0 0.0 1.0 0.0 0.0
		0.0 0.0 0.0 1.0 1.0
	]

	@testset "Points Find Radius" begin
		@test AlphaStructures.findRadius(P[1:1, 2:2]) == 0.0
		@test AlphaStructures.findRadius(P[1:2, 2:2]) == 0.0
		@test AlphaStructures.findRadius(P[1:3, 2:2]) == 0.0
	end

	@testset "Edges Find Center" begin
		@test AlphaStructures.findRadius(P[1:1, 1:2]) == 0.5
		@test AlphaStructures.findRadius(P[1:2, 1:2]) == 0.5
		@test AlphaStructures.findRadius(P[1:3, 1:2]) == 0.5

		@test AlphaStructures.findRadius(P[1:2, 4:5]) == 0.0
	end

	@testset "Triangles Find Center" begin
		r = 0.707106781
		@test isapprox(AlphaStructures.findRadius(P[1:2, 1:3]), r, atol=1e-9)
		@test isapprox(AlphaStructures.findRadius(P[1:3, 1:3]), r, atol=1e-9)

		@test AlphaStructures.findRadius(P[1:2, 3:5]) == Inf
		@test AlphaStructures.findRadius(P[1:3, 3:5]) == Inf
	end

	@testset "Tetrahedrons Find Center" begin
		r = 0.866025403
		@test isapprox(AlphaStructures.findRadius(P[1:3, 1:4]), r, atol=1e-9)

		@test AlphaStructures.findRadius(P[1:3, 2:5]) == Inf
	end

end

#-------------------------------------------------------------------------------

@testset "Opposit Half Space" begin
	V = [
		0.0 1.0 0.0 0.0 4.0 -1. 1.0
		0.0 0.0 1.0 0.0 1.0 0.0 1.0
		0.0 0.0 0.0 1.0 2.0 0.0 1.0
	]

	@testset "1D Opposite Half Space" begin
		V1D = V[[1], :]
		@test AlphaStructures.oppositeHalfSpacePoints(V1D, [1], 2) == [6]
		@test AlphaStructures.oppositeHalfSpacePoints(V1D, [6], 1) == []
		@test AlphaStructures.oppositeHalfSpacePoints(V1D, [1], 6) == [2; 5; 7]
	end

	@testset "2D Opposite Half Space" begin
		V2D = V[1:2, :]
		@test AlphaStructures.oppositeHalfSpacePoints(V2D, [2; 3], 1) == [5; 7]
		@test AlphaStructures.oppositeHalfSpacePoints(V2D, [1; 2], 3) == []
		@test AlphaStructures.oppositeHalfSpacePoints(V2D, [1; 3], 2) == [6]
	end

	@testset "3D Opposite Half Space" begin
		@test AlphaStructures.oppositeHalfSpacePoints(V, [2; 3; 4], 1) == [5; 7]
		@test AlphaStructures.oppositeHalfSpacePoints(V, [1; 2; 3], 4) == []
		@test AlphaStructures.oppositeHalfSpacePoints(V, [1; 3; 4], 2) == [6]
	end

end

#-------------------------------------------------------------------------------

@testset "planarIntersection" begin

	P = [
		0.0 1.0 -1. 1.0 2.0
		1.0 2.0 -1. 1.0 3.0
		1.0 0.0 -1. -1. -5.
	]

	@testset "1D Planar Intersection" begin
		@test AlphaStructures.planarIntersection(P, [1], 1, 0.0) == 0
		@test AlphaStructures.planarIntersection(P, [2], 1, 0.0) == 1
		@test AlphaStructures.planarIntersection(P, [3], 1, 0.0) == -1
	end

	@testset "2D Planar Intersection" begin
		@test AlphaStructures.planarIntersection(P, [2; 3], 1, 0.0) == 0
		@test AlphaStructures.planarIntersection(P, [1; 2], 2, 0.0) == 1
		@test AlphaStructures.planarIntersection(P, [2; 3], 3, 0.0) == -1
	end

	@testset "3D Planar Intersection" begin
		@test AlphaStructures.planarIntersection(P, [1; 2; 3], 1, 0.0) == 0
		@test AlphaStructures.planarIntersection(P, [1; 2; 4], 2, 0.0) == 1
		@test AlphaStructures.planarIntersection(P, [2; 3; 4], 3, 0.0) == -1
	end

	@testset "4D Planar Intersection" begin
		@test AlphaStructures.planarIntersection(P, [2; 3; 4; 5], 1, 0.0) == 0
		@test AlphaStructures.planarIntersection(P, [1; 2; 4; 5], 2, 0.0) == 1
		@test AlphaStructures.planarIntersection(P, [2; 3; 4; 5], 3, 0.0) == -1
	end
end

#-------------------------------------------------------------------------------

@testset "Simplex Faces" begin
	@test AlphaStructures.simplexFaces([1; 2]) == [ [1], [2] ]
	@test AlphaStructures.simplexFaces([1; 2; 3]) ==
		[ [1, 2], [1, 3], [2, 3] ]
	@test AlphaStructures.simplexFaces([1; 2; 3; 4]) ==
		[ [1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4] ]
	@test AlphaStructures.simplexFaces([4; 3; 2; 1; 5]) ==
		[ [1, 2, 3, 4], [1, 2, 3, 5], [1, 2, 4, 5], [1, 3, 4, 5], [2, 3, 4, 5] ]
end

#-------------------------------------------------------------------------------
#
# @testset "Vertex in Circumball" begin
#
# 	@testset "2D Vertex in Circumball" begin
# 		V = [
# 			0. 1. 0.;
# 			0. 0. 1.
# 		]
# 		simplex = [2, 3]
# 		up_simplex = [1, 2, 3]
# 		point = V[:, setdiff(up_simplex, simplex)]
# 		T=[ V[:, v] for v in simplex ]
# 		@test AlphaStructures.vertexInCircumball(
# 			T, AlphaStructures.foundRadius(T), point
# 		)
# 	end
#
# 	@testset "3D Vertex in Circumball" begin
#
# 		@testset "edge and triangle" begin
# 			V=[
# 				0. 1. 0.;
# 				0. 0. 1.;
# 				0. 0. 0.
# 			]
# 			simplex = [2, 3]
# 			up_simplex = [1, 2, 3]
# 			point = V[:, setdiff(up_simplex, simplex)]
# 			T=[ V[:, v] for v in simplex ]
# 			@test AlphaStructures.vertexInCircumball(
# 				T, AlphaStructures.foundRadius(T), point
# 			)
# 		end
#
# 		@testset "triangle and tetrahedron" begin
# 			V=[
# 				0. 1. 0. 0.;
# 				0. 0. 1. 0.;
# 				0. 0. 0. 1.
# 			]
# 			simplex = [2, 3, 4]
# 			up_simplex = [1, 2, 3, 4]
# 			point = V[:, setdiff(up_simplex, simplex)]
# 			T=[ V[:, v] for v in simplex ]
# 			@test AlphaStructures.vertexInCircumball(
# 				T, AlphaStructures.foundRadius(T), point
# 			)
# 		end
#
# 	end
#
# end
