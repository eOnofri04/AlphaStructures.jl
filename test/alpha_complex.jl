#using AlphaShape
if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "AlphaFilter" begin

	@testset "delaunayTriangulation" begin
		V=[0 1 0 1; 0 0 1 1]
		D=AlphaShape.delaunayTriangulation(V,2)
		@test D[1]==[[1,3],[2,3],[1,2],[2,4],[3,4]]
		@test D[2]==[[3,1,2],[2,4,3]]
	end


	@testset "contains" begin
		@test AlphaShape.contains([1,2,3],[1,2])==true
		@test AlphaShape.contains([1,2,3],[1,4])==false
	end

end
