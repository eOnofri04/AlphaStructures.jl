@testset "Delaunay" begin

	@testset "2D" begin
		@testset "one tetrahedron" begin
			P = [
				0.0 1.0 0.0
				0.0 0.0 1.0
			];
			DT = delaunayTriangulation(P)
			@test DT == [ [1, 2, 3] ]
		end

		@testset "two tetrahedron" begin
			P = [
				0.0 1.0 0.0 2.0
				0.0 0.0 1.0 0.0
			];
			DT = delaunayTriangulation(P)
			@test DT == [ [1, 2, 3], [2, 3, 4] ]
		end

		@testset "cube" begin
			P = [
				0.0 1.0 0.0 1.0
				0.0 0.0 1.0 1.0
			];
			DT = delaunayTriangulation(P)
			@test length(DT) == 2
		end
	end

	@testset "3D" begin
		@testset "one tetrahedron" begin
			P = [
				0.0 1.0 0.0 0.0
				0.0 0.0 1.0 0.0
				0.0 0.0 0.0 1.0
			];
			DT = delaunayTriangulation(P)
			@test DT == [ [1, 2, 3, 4] ]
		end

		@testset "two tetrahedron" begin
			P = [
				0.0 1.0 0.0 0.0 2.0
				0.0 0.0 1.0 0.0 0.0
				0.0 0.0 0.0 1.0 0.0
			];
			DT = delaunayTriangulation(P)
			@test DT == [ [1, 2, 3, 4], [2, 3, 4, 5] ]
		end

		@testset "cube" begin
			P = [
				0.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0
				0.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0
				0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0
			];
			DT = delaunayTriangulation(P)
			@test length(DT) == 6
		end
	end

end
