if VERSION < VersionNumber("1.0.0")
	using Base.Test
else
	using Test
end

@testset "update" begin
	@test AlphaStructures.update(1,[2,3,4]) == [2,3,4,1]
	@test AlphaStructures.update(4,[2,3,4]) == [2,3]
	@test AlphaStructures.update([3,4],[[1,2],[2,3]]) == [[1,2],[2,3],[3,4]]
	@test AlphaStructures.update([1,2],[[1,2],[2,3]]) == [[2,3]]
end

@testset "sidePlane" begin
	@test AlphaStructures.sidePlane([-4.,5.,6.],[1.,0,0],3.) == -1
	@test AlphaStructures.sidePlane([1.,1.,0.],[1.,1.,1.],2.) == 0
	@test AlphaStructures.sidePlane([0.,0.,0.],[1.,3.,5.],-1.) == 1
end

@testset "splitValue" begin
	P = [ -1. -2.  3.  4.  5.  ;
		  -1.  2.  3. -2. -3.  ;
		   0.  0.  1.  1.  1.  ]

	@test AlphaStructures.splitValue(P,[1.,0,0]) == 1.0
	@test AlphaStructures.splitValue(P,[0,1.,0]) == -1.5
	@test AlphaStructures.splitValue(P,[0,0,1.]) == 0.5
end

@testset "pointsetPartition" begin
	P = [ -1. -2.  3.  4.  5. -6.  ;
		   0.  1.  3. -2. -4.  2.  ;
		   1. -3. -5.  7.  2.  3.  ]
	# axis X
	Pminus,Pplus = AlphaStructures.pointsetPartition(P, [1.,0,0], 3.2)
	@test size(Pminus,2) == 4
	@test size(Pplus,2) == 2

	# axis Y
	Pminus,Pplus = AlphaStructures.pointsetPartition(P, [0,1.,0], 3.2)
	@test size(Pminus,2) == 6
	@test size(Pplus,2) == 0

	# axis Z
	Pminus,Pplus = AlphaStructures.pointsetPartition(P, [0,0,1.], 3.2)
	@test size(Pminus,2) == 5
	@test size(Pplus,2) == 1
end

@testset "simplexFaces" begin
	@test AlphaStructures.simplexFaces([1,2]) == [[1],[2]]
	@test AlphaStructures.simplexFaces([1,2,3]) == [[1,2],[1,3],[2,3]]
	@test AlphaStructures.simplexFaces([1,2,3,4]) == [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
end

@testset "distPointPlane" begin
	@test AlphaStructures.distPointPlane([-4.,2.,3.],[1.,0.,0.],3.) == 7.
	@test AlphaStructures.distPointPlane([1.,2.,10.],[1.,1.,0.],3.) == 0.
	@test isapprox(AlphaStructures.distPointPlane([1.,1.,1.],[1.,1.,1.],0.),sqrt(3))
end

@testset "planarIntersection" begin
	P = [  -1. -2. 3.  4.  5. -6.  ;
			0.  1. 3. -2. -4.  2.  ;
			1.  8. -5.  7.  4.  3.  ]
	@test AlphaStructures.planarIntersection(P, P, [2,4,6], [1.,0,0], 3.2) == 0
	@test AlphaStructures.planarIntersection(P, P, [1,4,5], [0,1.,0], 3.2) == -1
	@test AlphaStructures.planarIntersection(P, P, [2,4,5], [0,0,1.], 3.2) == 1
end

@testset "Found Center" begin

	@testset "Points Found Center" begin
		@test AlphaStructures.foundCenter([[1.]]) == [1.]
		@test AlphaStructures.foundCenter([[1., 1.]]) == [1., 1.]
		@test AlphaStructures.foundCenter([[1., 1., 1.]]) == [1., 1., 1.]
		# @test AlphaStructures.foundCenter(([[1., 1., 1., 1.]])) == [1., 1., 1., 1.]
	end

	@testset "Edges Found Center" begin
		@test AlphaStructures.foundCenter([[1.], [3.]]) == [2.0]
		@test AlphaStructures.foundCenter([[1.,1.], [3.,3.]]) == [2.0, 2.0]
		@test AlphaStructures.foundCenter([[1.,1.,1.], [3.,3.,3.]]) == [2.0, 2.0, 2.0]
	end

	@testset "Triangles Found Center" begin
		@test AlphaStructures.foundCenter([[0.,0.], [0.,1.], [1.,0.]]) == [0.5, 0.5]
		@test AlphaStructures.foundCenter([[0.,0.,0.], [0.,1.,0.], [1.,0.,0.]]) == [0.5,0.5,0.0]
	end

	@testset "Tetrahedrons Found Center" begin
		@test AlphaStructures.foundCenter([[0.,0.,0.], [1.,0.,0.], [0.,1.,0.], [0.,0.,1.]]) == [0.5, 0.5, 0.5]
	end

end

@testset "Found Radius" begin

	@testset "Points Found Radius" begin
		@test AlphaStructures.foundRadius(([[1.]])) == 0.0
		@test AlphaStructures.foundRadius(([[1., 1.]])) == 0.0
		@test AlphaStructures.foundRadius(([[1., 1., 1.]])) == 0.0
		# @test AlphaStructures.foundRadius(([[1., 1., 1., 1.]])) == 0.0
	end

	@testset "1D Found Radius" begin
		@test AlphaStructures.foundRadius(([[1.], [3.]])) == 1.0
		@test AlphaStructures.foundRadius(([[1.], [1.]])) == 0.0
	end

	@testset "2D Found Radius" begin
		T = [[1., 1.], [2., 2.]]
		P = [[1., 0.], [2., 0.], [3., 0.]]
		Q = [[0., 0.], [2., 0.], [0., 2.]]
		@test AlphaStructures.foundRadius(T) == sqrt(2)/2
		@test AlphaStructures.foundRadius(P) == Inf
		@test isapprox(AlphaStructures.foundRadius(Q), sqrt(2), atol=1e-4)
	end

	@testset "3D Found Radius" begin
		T = [[1., 1., 0.], [2., 2., 0.]]
		P = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.]]
		Q = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.], [0. ,0. ,1.]]
		R = [[-1., 0., 0.], [1., 0., 0.], [0, 1., 0.], [0. ,0. ,0.]]
		@test AlphaStructures.foundRadius(T) == sqrt(2)/2
		@test isapprox(AlphaStructures.foundRadius(P), 1., atol=1e-4)
		@test isapprox(AlphaStructures.foundRadius(Q),1.)
		@test AlphaStructures.foundRadius(R) == Inf
	end

end

@testset "Vertex in Circumball" begin

	@testset "2D Vertex in Circumball" begin
		V=[
			0. 1. 0.;
			0. 0. 1.
		]
		simplex = [2, 3]
		up_simplex = [1, 2, 3]
		point = V[:, setdiff(up_simplex, simplex)]
		T=[ V[:, v] for v in simplex ]
		@test AlphaStructures.vertexInCircumball(T, AlphaStructures.foundRadius(T), point)
	end

	@testset "3D Vertex in Circumball" begin

		@testset "edge and triangle" begin
			V=[
				0. 1. 0.;
				0. 0. 1.;
				0. 0. 0.
			]
			simplex = [2, 3]
			up_simplex = [1, 2, 3]
			point = V[:, setdiff(up_simplex, simplex)]
			T=[ V[:, v] for v in simplex ]
			@test AlphaStructures.vertexInCircumball(T, AlphaStructures.foundRadius(T), point)
		end

		@testset "triangle and tetrahedron" begin
			V=[
				0. 1. 0. 0.;
				0. 0. 1. 0.;
				0. 0. 0. 1.
			]
			simplex = [2, 3, 4]
			up_simplex = [1, 2, 3, 4]
			point = V[:, setdiff(up_simplex, simplex)]
			T=[ V[:, v] for v in simplex ]
			@test AlphaStructures.vertexInCircumball(T, AlphaStructures.foundRadius(T), point)
		end

	end

end
