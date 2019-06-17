#using AlphaShape
if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "pointsRand" begin

	V=[0 1 0 1; 0 0 1/2 1/2]
	EV=[[1,2],[2,4],[4,3],[3,1]]
	Vi, Ve, VVi, VVe = AlphaShape.pointsRand(V, EV, 1000, 10000);
	@test size(Vi,2)==1000
	@test size(Ve,2)==10000
	@test length(VVi)==1000
	@test length(VVe)==10000



end
