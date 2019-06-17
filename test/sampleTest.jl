if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "Sample Test" begin
	@test 1 == 1
end
