if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end


@testset "SplitValue" begin
	P = [ -1. -2.  3.  4.  5.  ;
		  -1.  2.  3. -2. -3.  ;
		   0.  0.  1.  1.  1.  ]

	@test AlphaShape.SplitValue(P,[1.,0,0]) == 1.0
	@test AlphaShape.SplitValue(P,[0,1.,0]) == -1.5
	@test AlphaShape.SplitValue(P,[0,0,1.]) == 0.5
end

@testset "pointsetPartition" begin
	P = [ -1. -2.  3.  4.  5. -6.  ;
		   0.  1.  3. -2. -4.  2.  ;
		   1. -3. -5.  7.  2.  3.  ]
	# axis X
	Pminus,Pplus = AlphaShape.pointsetPartition(P, [1.,0,0], 3.2)
	@test size(Pminus,2) == 4
	@test size(Pplus,2) == 2

	# axis Y
	Pminus,Pplus = AlphaShape.pointsetPartition(P, [0,1.,0], 3.2)
	@test size(Pminus,2) == 6
	@test size(Pplus,2) == 0

	# axis Z
	Pminus,Pplus = AlphaShape.pointsetPartition(P, [0,0,1.], 3.2)
	@test size(Pminus,2) == 5
	@test size(Pplus,2) == 1
end

@testset "MakeFirstWallSimplex" begin
	P = [  -1.  1    1.5  2   ;
			0.  0.2  1.3  1.  ;
			0.  0.   0.   1.   ]

	axis = [1.,0,0]
	off = AlphaShape.SplitValue(P,axis)
	@test AlphaShape.MakeFirstWallSimplex(P,axis,off) == [1,2,3,4]

	axis = [0,1.,0]
	off = AlphaShape.SplitValue(P,axis)
	@test AlphaShape.MakeFirstWallSimplex(P,axis,off) ==  [1,2,3,4]

	axis = [0,0,1.]
	off = AlphaShape.SplitValue(P,axis)
	@test AlphaShape.MakeFirstWallSimplex(P,axis,off) == [1,2,3,4]
end

@testset "Faces" begin
	@test AlphaShape.Faces([1,2]) == [[1],[2]]
	@test AlphaShape.Faces([1,2,3]) == [[1,2],[1,3],[2,3]]
	@test AlphaShape.Faces([1,2,3,4]) == [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
end

@testset "Intersect" begin
	P = [  -1. -2. 3.  4.  5. -6.  ;
			0.  1. 3. -2. -4.  2.  ;
			1.  8. -5.  7.  4.  3.  ]
	@test AlphaShape.Intersect(P, [2,4,6], [1.,0,0], 3.2) == 0
	@test AlphaShape.Intersect(P, [1,4,5], [0,1.,0], 3.2) == -1
	@test AlphaShape.Intersect(P, [2,4,5], [0,0,1.], 3.2) == 1
end

@testset "MakeSimplex" begin
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
	P = [  -1.  1    1.5  2   ;
			0.  0.2  1.3  1.  ;
			0.  0.   0.   1.   ]

	@test AlphaShape.DeWall(P,AFL,axis) == [[1,2,3,4]]

	T = [  -1. -2. 3.  4.  5. -6.  ;
			0.  1. 3. -2. -4.  2.  ;
			1.  8. -5.  7.  4.  3.  ]
	@test length(AlphaShape.DeWall(T,AFL,axis)) == 11
end
