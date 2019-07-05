if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "SidePlane" begin
	@test AlphaShape.SidePlane([-4.,5.,6.],[1.,0,0],3.) == -1
	@test AlphaShape.SidePlane([1.,1.,0.],[1.,1.,1.],2.) == 0
	@test AlphaShape.SidePlane([0.,0.,0.],[1.,3.,5.],-1.) == 1
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

@testset "Faces" begin
	@test AlphaShape.Faces([1,2]) == [[1],[2]]
	@test AlphaShape.Faces([1,2,3]) == [[1,2],[1,3],[2,3]]
	@test AlphaShape.Faces([1,2,3,4]) == [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
end

@testset "distPointPlane" begin
	@test AlphaShape.distPointPlane([-4.,2.,3.],[1.,0.,0.],3.) == 7.
	@test AlphaShape.distPointPlane([1.,2.,10.],[1.,1.,0.],3.) == 0.
	@test isapprox(AlphaShape.distPointPlane([1.,1.,1.],[1.,1.,1.],0.),sqrt(3))
end

@testset "Intersect" begin
	P = [  -1. -2. 3.  4.  5. -6.  ;
			0.  1. 3. -2. -4.  2.  ;
			1.  8. -5.  7.  4.  3.  ]
	@test AlphaShape.Intersect(P, [2,4,6], [1.,0,0], 3.2) == 0
	@test AlphaShape.Intersect(P, [1,4,5], [0,1.,0], 3.2) == -1
	@test AlphaShape.Intersect(P, [2,4,5], [0,0,1.], 3.2) == 1
end

@testset "Found Center" begin

	@testset "Points Found Center" begin
		@test AlphaShape.foundCenter([[1.]]) == [1.]
		@test AlphaShape.foundCenter([[1., 1.]]) == [1., 1.]
		@test AlphaShape.foundCenter([[1., 1., 1.]]) == [1., 1., 1.]
	end

	@testset "Edges Found Center" begin
		@test AlphaShape.foundCenter([[1.], [3.]]) == [2.0]
		@test AlphaShape.foundCenter([[1.,1.], [3.,3.]]) == [2.0, 2.0]
		@test AlphaShape.foundCenter([[1.,1.,1.], [3.,3.,3.]]) == [2.0, 2.0, 2.0]
	end

	@testset "Triangles Found Center" begin
		@test AlphaShape.foundCenter([[0.,0.], [0.,1.], [1.,0.]]) == [0.5, 0.5]
		@test AlphaShape.foundCenter([[0.,0.,0.], [0.,1.,0.], [1.,0.,0.]]) == [0.5,0.5,0.0]
	end

	@testset "Tetrahedrons Found Center" begin
		@test AlphaShape.foundCenter([[0.,0.,0.], [1.,0.,0.], [0.,1.,0.], [0.,0.,1.]]) == [0.5, 0.5, 0.5]
	end

end

@testset "Found α" begin

	@testset "Points Found α" begin
		@test AlphaShape.foundAlpha(([[1.]])) == 0.0
		@test AlphaShape.foundAlpha(([[1., 1.]])) == 0.0
		@test AlphaShape.foundAlpha(([[1., 1., 1.]])) == 0.0
		# @test AlphaShape.foundAlpha(([[1., 1., 1., 1.]])) == 0.0
	end

	@testset "1D Found α" begin
		@test AlphaShape.foundAlpha(([[1.], [3.]])) == 1.0
		@test AlphaShape.foundAlpha(([[1.], [1.]])) == 0.0
	end

	@testset "2D Found α" begin
		T = [[1., 1.], [2., 2.]]
		P = [[1., 0.], [2., 0.], [3., 0.]]
		Q = [[0., 0.], [2., 0.], [0., 2.]]
		@test AlphaShape.foundAlpha(T) == round(sqrt(2)/2,sigdigits=14)
		@test isnan(AlphaShape.foundAlpha(P))
		@test isapprox(AlphaShape.foundAlpha(Q), sqrt(2), atol=1e-4)
	end

	@testset "3D Found α" begin
		T = [[1., 1., 0.], [2., 2., 0.]]
		P = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.]]
		Q = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.], [0. ,0. ,1.]]
		R = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.], [0. ,0. ,0.]]
		@test AlphaShape.foundAlpha(T) == round(sqrt(2)/2,sigdigits=14)
		@test isapprox(AlphaShape.foundAlpha(P), 1., atol=1e-4)
		@test AlphaShape.foundAlpha(Q) == 1.
		@test isnan(AlphaShape.foundAlpha(R))
	end

end