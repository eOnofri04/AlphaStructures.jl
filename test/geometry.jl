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
