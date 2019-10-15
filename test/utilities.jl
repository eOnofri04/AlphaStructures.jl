if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "Load file .las" begin

	@testset "lasPoint without color" begin
		fname = "srs.las"
		V,VV,rgb = AlphaStructures.loadlas(fname)
		@test size(V) == (3,10)
		@test isempty(rgb)
	end

	@testset "lasPoint with color" begin
		fname = "cava.las"
		V,VV,rgb = AlphaStructures.loadlas(fname)
		@test size(V) == size(rgb)
		@test typeof(V) == Lar.Points{Float64}
		@test typeof(rgb) == Array{LasIO.FixedPointNumbers.Normed{UInt16,16},2}
		V,VV,rgb = AlphaStructures.loadlas(fname,fname)
		@test size(V) == (3,5278*2) == size(rgb)
	end

	@testset "more file .las" begin
		fname = "srs.las"
		V,VV,rgb = AlphaStructures.loadlas(fname,fname)
		@test size(V) == (3,20)
		V,VV,rgb = AlphaStructures.loadlas(fname,fname,fname)
		@test size(V) == (3,30)
	end

end

@testset "View colored" begin
	V,(VV,EV,FV,CV) = Lar.cuboidGrid([1,1,1],true)
	DT = AlphaStructures.delaunayTriangulation(V)
	rgb = [0.8 0.0 0.0 0.8 0.0 0.0 0.8 0.3; 0.0 0.8 0.0 0.0 0.8 0.0 0.2 0.8; 0.0 0.0 0.8 0.0 0.0 0.8 0.3 0.4]
	@test typeof(AlphaStructures.colorview(V,VV,rgb))==GL.GLMesh
	@test typeof(AlphaStructures.colorview(V,EV,rgb))==GL.GLMesh
	@test typeof(AlphaStructures.colorview(V,DT,rgb))==GL.GLMesh
end
