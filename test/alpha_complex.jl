@testset "α Filter" begin

	@testset "1D α Filter" begin
		# Input Data
		V = [ 1. 3. 2. 6. 7. 8. 12. 10. ]
		DT = AlphaStructures.delaunayTriangulation(V)

		# Expected Output
		VV = [[1],[2],[3],[4],[5],[6],[7],[8]]
		EV = [[1,3],[2,3],[2,4],[4,5],[5,6],[6,8],[7,8]]

		# Evaluation
		filter = AlphaStructures.alphaFilter(V, DT)

		@test length(unique(values(filter))) == 4
		@test sort(unique(values(filter))) == [0.0, 0.5, 1.0, 1.5]
		@test length(unique(keys(filter))) == 15
		@test sort([v for v in unique(keys(filter)) if length(v) == 2]) == EV
	end

	@testset "2D α Filter" begin
		# Input Data
		V = [
			0.0 1.0 0.0 2.0;
			0.0 0.0 1.0 2.0
		]

		# Expected Output
		VV = [[1],[2],[3],[4]]
		EV = [[1, 2],[1, 3],[2, 3],[2, 4],[3, 4]]
		FV = [[1, 2, 3],[2, 3, 4]]

		# Evaluation
		filter = AlphaStructures.alphaFilter(V)

		@test length(unique(values(filter))) == 5
		@test isapprox(sort(unique(values(filter))),
			[0.0, 0.5, 0.7071, 1.1180, 1.1785], atol=1e-4
		)
		@test length(unique(keys(filter))) == 11
		@test sort([v for v in unique(keys(filter)) if length(v) == 1]) == VV
		@test sort([v for v in unique(keys(filter)) if length(v) == 2]) == EV
		@test sort([v for v in unique(keys(filter)) if length(v) == 3]) == FV
	end

	@testset "3D α Filter" begin
		V = [
			0.0 1.0 0.0 0.0 1.0 0.0;
			0.0 0.0 1.0 0.0 0.0 1.0;
			0.0 0.0 0.0 1.0 1.0 2.0
		]

		# Expected Output
		VV = [[1],[2],[3],[4],[5],[6]]
		CV = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
		# Evaluation
		filter = AlphaStructures.alphaFilter(V, digits=4)

		@test length(unique(values(filter))) == 6
		@test sort(unique(values(filter))) == [0.0, 0.5, 0.7071, 0.866, 1.0, 1.118]
		@test length(unique(keys(filter))) == 31
		@test sort([v for v in unique(keys(filter)) if length(v) == 1]) == VV
		@test sort([v for v in unique(keys(filter)) if length(v) == 4]) == CV
	end

end

@testset "α Simplices Evaluation" begin

	@testset "1D α Simplex" begin
		# Input Data
		V = [
			0.0 1.0 2.0 7.0 5.0 3.0 14.0 11.0
		]
		filtration = AlphaStructures.alphaFilter(V)

		# α = 0.0
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 0.0)
		@test α_simplices[1] == [[1],[2],[3],[4],[5],[6],[7],[8]]
		@test isempty(α_simplices[2])
		# α = 0.5
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 0.5)
		@test α_simplices[2] == [[1,2],[2,3],[3,6]]
		# α = 1.0
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 1.0)
		@test α_simplices[2] == [[1, 2], [2, 3], [3, 6], [4, 5], [5, 6]]
		# α = 1.5
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 1.5)
		@test α_simplices[2] == [[1, 2], [2, 3], [3, 6], [4, 5], [5, 6], [7, 8]]

	end

	@testset "2D α Simplex" begin
		# Input Data
		V = [
			0.0 1.0 0.0 2.0;
			0.0 0.0 1.0 0.3
		]
		filtration = AlphaStructures.alphaFilter(V)

		# α = 0.0
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 0.0)
		@test α_simplices[1] == [[1],[2],[3],[4]]
		@test isempty(α_simplices[2])
		@test isempty(α_simplices[3])
		# α = 0.5
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 0.5)
		@test α_simplices[2] == [[1,2],[1,3]]
		@test isempty(α_simplices[3])
		# α = 1.0
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 1.0)
		@test α_simplices[2] == [[1,2],[1,3],[2,3],[2,4]]
		@test α_simplices[3] == [[1,2,3]]
		# α = 1.5
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 1.5)
		@test α_simplices[2] == [[1,2],[1,3],[2,3],[2,4],[3,4]]
		@test α_simplices[3] == [[1,2,3],[2,3,4]]

	end

	@testset "3D α Simplex" begin
		# Input Data
		V = [
			0.0  1.0  0.0  0.0  2.0;
			0.0  0.0  1.0  0.0  2.0;
			0.0  0.0  0.0  1.0  2.0
		]
		filtration = AlphaStructures.alphaFilter(V)

		# α = 0.0
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 0.0)
		@test α_simplices[1] == [[1],[2],[3],[4],[5]]
		@test isempty(α_simplices[2])
		@test isempty(α_simplices[3])
		@test isempty(α_simplices[4])
		# α = 0.5
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 0.5)
		@test α_simplices[2] == [[1,2],[1,3],[1,4]]
		@test isempty(α_simplices[3])
		@test isempty(α_simplices[4])
		# α = 1.0
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 1.0)
		@test α_simplices[2] == [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
		@test α_simplices[3] == [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
		@test α_simplices[4] == [[1,2,3,4]]

		# α = 1.5
		α_simplices = AlphaStructures.alphaSimplex(V, filtration, 1.6)
		@test α_simplices[4] == [[1,2,3,4],[2,3,4,5]]
	end

end
