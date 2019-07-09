if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

using DataStructures, LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

@testset "makeFirstWallSimplex" begin
	P = [  -1.  1    1.5  2   ;
			0.  0.2  1.3  1.  ;
			0.  0.   0.   1.   ]

	axis = [1.,0,0]
	off = AlphaStructures.splitValue(P,axis)
	@test AlphaStructures.makeFirstWallSimplex(P,P,axis,off) == [1,2,3,4]

	axis = [0,1.,0]
	off = AlphaStructures.splitValue(P,axis)
	@test AlphaStructures.makeFirstWallSimplex(P,P,axis,off) ==  [1,2,3,4]

	axis = [0,0,1.]
	off = AlphaStructures.splitValue(P,axis)
	@test AlphaStructures.makeFirstWallSimplex(P,P,axis,off) == [1,2,3,4]

end

@testset "makeSimplex" begin
	P = [ 0. 1. 0  0  2.;
	 	  0  0  1. 0  2.;
		  0  0  0  1. 2.]
	@test AlphaStructures.makeSimplex([2,3,4],[1,2,3,4],P,P) == [2,3,4,5]
	@test AlphaStructures.makeSimplex([2,3,5],[2,3,4,5],P,P) == nothing
	@test AlphaStructures.makeSimplex([2,3,4],[2,3,4,5],P,P) == [1,2,3,4]
end

@testset "deWall" begin
	AFL = Array{Int64,1}[]
	axis = [1.,0.,0.]

	@testset "one tetrahedron" begin
		tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
		P = [  -1.  1    1.5  2   ;
				0.  0.2  1.3  1.  ;
				0.  0.   0.   1.   ]
		@test AlphaStructures.deWall(P,P,AFL,axis,tetraDict) == [[1,2,3,4]]
	end

	@testset "generic examples" begin
		tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
		P = [  -1. -2. 3.  4.  5. -6.  ;
				0.  1. 3. -2. -4.  2.  ;
				1.  8. -5.  7.  4.  3.  ]
		@test length(AlphaStructures.deWall(P,P,AFL,axis,tetraDict)) == 5
	end

	@testset "two tetrahedron" begin
		tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
		P = [ 0. 1. 0  0  2.;
		 	  0  0  1. 0  2.;
			  0  0  0  1. 2.]
		@test AlphaStructures.deWall(P,P,AFL,axis,tetraDict) == [[1,2,3,4],[2,3,4,5]]
	end

	@testset "points on a plane" begin
		tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
		P = [ 0. 0. 0  0  0.;
	 	  	  2. 0  1. 0  2.;
		  	  0  0  0  1. 2.]
		@test AlphaStructures.deWall(P,P,AFL,axis,tetraDict) == []
	end

	@testset "cube" begin
		tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
		P = [	0. 1 0 1 0. 1 0 1;
				0. 0 1 1 0. 0 1 1;
				0. 0 0 0 1. 1 1 1]
		@test length(AlphaStructures.deWall(P,P,AFL,axis,tetraDict)) == 6
	end

end
