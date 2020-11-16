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

	@testset "Keyword Argument Exception" begin
		@test_throws AssertionError AlphaStructures.findClosestPoint(
			P, P, metric = "Euclidean"
		)
		@test_throws AssertionError AlphaStructures.findClosestPoint(
			P, P, metric = "DD"
		)
		@test_throws AssertionError AlphaStructures.findClosestPoint(
			P, P, metric = "abc"
		)
	end

	@testset "Cannot add more points" begin
		@test_throws AssertionError AlphaStructures.findClosestPoint(P, P)
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

	@testset "Edges Find Radius" begin
		@test AlphaStructures.findRadius(P[1:1, 1:2]) == 0.5
		@test AlphaStructures.findRadius(P[1:2, 1:2]) == 0.5
		@test AlphaStructures.findRadius(P[1:3, 1:2]) == 0.5

		@test AlphaStructures.findRadius(P[1:2, 4:5]) == 0.0
	end

	@testset "Triangles Find Radius" begin
		r = 0.707106781
		@test isapprox(AlphaStructures.findRadius(P[1:2, 1:3]), r, atol=1e-9)
		@test isapprox(AlphaStructures.findRadius(P[1:3, 1:3]), r, atol=1e-9)

		@test AlphaStructures.findRadius(P[1:2, 3:5]) == Inf
		@test AlphaStructures.findRadius(P[1:3, 3:5]) == Inf
	end

	@testset "Tetrahedrons Find Radius" begin
		r = 0.866025403
		@test isapprox(AlphaStructures.findRadius(P[1:3, 1:4]), r, atol=1e-9)

		@test AlphaStructures.findRadius(P[1:3, 2:5]) == Inf
	end

end

#-------------------------------------------------------------------------------

@testset "Matrix Perturbation" begin
	P = rand(Float64, 3, 100000)

	Pperturbated = AlphaStructures.matrixPerturbation(P, atol = 1e-2)
	P1 = AlphaStructures.matrixPerturbation(P, row = [1], atol = 1e-3)
	P2 = AlphaStructures.matrixPerturbation(P, col = [2], atol = 10)
	P13 = AlphaStructures.matrixPerturbation(P, row = [1; 3], atol = 1e-1)
	P11 = AlphaStructures.matrixPerturbation(P, row = [1], col = [1], atol=100)
	noPt = AlphaStructures.matrixPerturbation(P, atol = 0.0)

	@test sum(abs.(P - Pperturbated) .> 1e-2) == 0
	@test sum(abs.(P[1, :] - P1[1, :]) .> 1e-3) == 0
	@test P[[2;3], :] == P1[[2;3], :]
	@test sum(abs.(P[:, 2] - P2[:, 2]) .> 10) == 0
	@test P[:, [1;3]] == P2[:, [1;3]]
	@test sum(abs.(P[[1;3], :] - P13[[1;3], :]) .> 1e-1) == 0
	@test P[2, :] == P13[2, :]
	@test abs.(P[1, 1] - P11[1, 1]) .< 100
	@test P[2:end] == P11[2:end]
	@test P != P1 != P2 != P13 != P11 != Pperturbated
	@test P == noPt

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
		@test AlphaStructures.oppositeHalfSpacePoints(
			V1D, V1D[:, [1]], V1D[:, 2]
		) == [6]
		@test AlphaStructures.oppositeHalfSpacePoints(
			V1D, V1D[:, [6]], V1D[:, 1]
		) == []
		@test AlphaStructures.oppositeHalfSpacePoints(
			V1D, V1D[:, [1]], V1D[:, 6]
		) == [2; 5; 7]
	end

	@testset "2D Opposite Half Space" begin
		V2D = V[1:2, :]
		@test AlphaStructures.oppositeHalfSpacePoints(
			V2D, V2D[:, [2; 3]], V2D[:, 1]
		) == [5; 7]
		@test AlphaStructures.oppositeHalfSpacePoints(
			V2D, V2D[:, [1; 2]], V2D[:, 3]
		) == []
		@test AlphaStructures.oppositeHalfSpacePoints(
			V2D, V2D[:, [1; 3]], V2D[:, 2]
		) == [6]
	end

	@testset "3D Opposite Half Space" begin
		@test AlphaStructures.oppositeHalfSpacePoints(
			V, V[:, [2; 3; 4]], V[:, 1]
		) == [5; 7]
		@test AlphaStructures.oppositeHalfSpacePoints(
			V, V[:, [1; 2; 3]], V[:, 4]
		) == []
		@test AlphaStructures.oppositeHalfSpacePoints(
			V, V[:, [1; 3; 4]], V[:, 2]
		) == [6]
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

 @testset "Vertex in Circumball" begin

 	@testset "2D Vertex in Circumball" begin
 		V = [
 			0. 1. 0.;
 			0. 0. 1.
 		]
 		simplex = [2, 3]
 		up_simplex = [1, 2, 3]
 		point = V[:, setdiff(up_simplex, simplex)]
 		T= V[:, simplex]
 		@test AlphaStructures.vertexInCircumball(
 			T, AlphaStructures.findRadius(T), point
 		)
 	end

 	@testset "3D Vertex in Circumball" begin

 		@testset "edge and triangle" begin
 			V=[
 				0. 1. 0.;
 				0. 0. 1.;
 				0. 0. 0.
 			]
 			simplex = [2, 3]
 			up_simplex = [1, 2, 3]
 			point = V[:, setdiff(up_simplex, simplex)]
 			T= V[:, simplex]
			@test AlphaStructures.vertexInCircumball(
 				T, AlphaStructures.findRadius(T), point
 			)
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
 			T= V[:, simplex]
 			@test AlphaStructures.vertexInCircumball(
 				T, AlphaStructures.findRadius(T), point
 			)
 		end

 	end

 end
