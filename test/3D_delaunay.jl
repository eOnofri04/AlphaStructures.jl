if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

using DataStructures

@testset "MakeFirstWallSimplex" begin
	P = [  -1.  1    1.5  2   ;
			0.  0.2  1.3  1.  ;
			0.  0.   0.   1.   ]

	axis = [1.,0,0]
	off = AlphaShape.SplitValue(P,axis)
	@test AlphaShape.MakeFirstWallSimplex(P,P,axis,off) == [1,2,3,4]

	axis = [0,1.,0]
	off = AlphaShape.SplitValue(P,axis)
	@test AlphaShape.MakeFirstWallSimplex(P,P,axis,off) ==  [1,2,3,4]

	axis = [0,0,1.]
	off = AlphaShape.SplitValue(P,axis)
	@test AlphaShape.MakeFirstWallSimplex(P,P,axis,off) == [1,2,3,4]
end

@testset "MakeSimplex" begin
	P = [ 0. 1. 0  0  2.;
	 	  0  0  1. 0  2.;
		  0  0  0  1. 2.]
	@test AlphaShape.MakeSimplex([2,3,4],[1,2,3,4],P,P) == [2,3,4,5]
	@test AlphaShape.MakeSimplex([2,3,5],[2,3,4,5],P,P) == nothing
	@test AlphaShape.MakeSimplex([2,3,4],[2,3,4,5],P,P) == [1,2,3,4]
end

@testset "Update" begin
	@test AlphaShape.Update(1,[2,3,4]) == [2,3,4,1]
	@test AlphaShape.Update(4,[2,3,4]) == [2,3]
	@test AlphaShape.Update([3,4],[[1,2],[2,3]]) == [[1,2],[2,3],[3,4]]
	@test AlphaShape.Update([1,2],[[1,2],[2,3]]) == [[2,3]]
end

@testset "DeWall" begin
	AFL = Array{Int64,1}[]
	axis = [1.,0.,0.]

	@testset "one tetrahedron" begin
		tetraDict = DataStructures.Dict{Array{Array{Int64,1},1},Array{Int64,1}}()
		P = [  -1.  1    1.5  2   ;
				0.  0.2  1.3  1.  ;
				0.  0.   0.   1.   ]
		@test AlphaShape.DeWall(P,P,AFL,axis,tetraDict) == [[1,2,3,4]]
	end

	@testset "generic examples" begin
		tetraDict = DataStructures.Dict{Array{Array{Int64,1},1},Array{Int64,1}}()
		P = [  -1. -2. 3.  4.  5. -6.  ;
				0.  1. 3. -2. -4.  2.  ;
				1.  8. -5.  7.  4.  3.  ]
		@test length(AlphaShape.DeWall(P,P,AFL,axis,tetraDict)) == 5
	end

	@testset "two tetrahedron" begin
		tetraDict = DataStructures.Dict{Array{Array{Int64,1},1},Array{Int64,1}}()
		P = [ 0. 1. 0  0  2.;
		 	  0  0  1. 0  2.;
			  0  0  0  1. 2.]
		@test AlphaShape.DeWall(P,P,AFL,axis,tetraDict) == [[1,2,3,4],[2,3,4,5]]
	end

	@testset "points on a plane" begin
		tetraDict = DataStructures.Dict{Array{Array{Int64,1},1},Array{Int64,1}}()
		P = [ 0. 0. 0  0  0.;
	 	  	  2. 0  1. 0  2.;
		  	  0  0  0  1. 2.]
		@test AlphaShape.DeWall(P,P,AFL,axis,tetraDict) == []
	end

	@testset "cube" begin
		tetraDict = DataStructures.Dict{Array{Array{Int64,1},1},Array{Int64,1}}()
		P = [	0. 1 0 1 0. 1 0 1;
				0. 0 1 1 0. 0 1 1;
				0. 0 0 0 1. 1 1 1]
		@test length(AlphaShape.DeWall(P,P,AFL,axis,tetraDict)) == 6
	end
	
end
