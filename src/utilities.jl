"""
	loadlas(fname::String...)::Tuple{Lar.Points,Array{LasIO.N0f16,2}}

Read more than one file `.las` and extrapolate the LAR model and the color of each point.

"""
function loadlas(fname::String...)::Tuple{Lar.Points,Array{Array{Int64,1},1},Array{LasIO.N0f16,2}}
	Vtot = Array{Float64,2}(undef, 3, 0)
	rgbtot = Array{LasIO.N0f16,2}(undef, 3, 0)
	for name in fname
		V,VV,rgb = AlphaStructures.las2lar(name)
		Vtot = hcat(Vtot,V)
		rgbtot = hcat(rgbtot,rgb)
	end
	return Vtot,[[i] for i in 1:size(Vtot,2)],rgbtot
end

"""
	las2lar(fname::String)::Tuple{Lar.Points,Array{LasIO.N0f16,2}}

Read data from a file `.las`:
- generate the LAR model `(V,VV)`
- extrapolate color associated to each point
"""
function las2lar(fname::String)::Tuple{Lar.Points,Array{Array{Int64,1},1},Array{LasIO.N0f16,2}}
	header, laspoints = LasIO.FileIO.load(fname)
	npoints = length(laspoints)
	x = [LasIO.xcoord(laspoints[k], header) for k in 1:npoints]
	y = [LasIO.ycoord(laspoints[k], header) for k in 1:npoints]
	z = [LasIO.zcoord(laspoints[k], header) for k in 1:npoints]
	if typeof(laspoints[1]) != LasPoint0 && typeof(laspoints[1]) != LasPoint1
		r = LasIO.ColorTypes.red.(laspoints)
		g = LasIO.ColorTypes.green.(laspoints)
		b = LasIO.ColorTypes.blue.(laspoints)
		return vcat(x',y',z'),[[i] for i in 1:npoints], vcat(r',g',b')
	end
	return vcat(x',y',z'), [[i] for i in 1:npoints], Array{LasIO.N0f16,2}(undef, 3, 0)
end

"""
	colorview(V::Lar.Points,CV::Lar.Cells,rgb::Lar.Points)::GL.GLMesh

Create the GLMesh to view points,edges,triangles and tetrahedrons with colors from each point.
"""
function colorview(V::Lar.Points,CV::Lar.Cells,rgb::Lar.Points)::GL.GLMesh

	function viewtetra(V::Lar.Points, CV::Lar.Cells,rgb)::GL.GLMesh
		triangles = Array{Int64,1}[]
		#data preparation
		for cell in CV
			newsimplex = collect(Combinatorics.combinations(cell,3))
			append!(triangles,newsimplex)
		end
		# mesh building
		unique!(sort!.(triangles))
		mesh = AlphaStructures.colorview(V,triangles,rgb);
	end

	n = size(V,1)  # space dimension
	points = GL.embed(3-n)((V,CV))[1]
	cells = CV
	len = length(cells[1])  # cell dimension

	vertices = Vector{Float32}()
	normals = Vector{Float32}()
	colors  = Vector{Float32}()

	if len == 1   # zero-dimensional grids
		ret = GL.GLMesh(GL.GL_POINTS)
		for k = 1:size(points,2)
			c1 = GL.Point4d(rgb[:,k]...,1)
			p1 = convert(GL.Point3d, points[:,k])
			append!(vertices,p1); #append!(normals,n)
			append!(colors,c1); #append!(normals,n)
		end
	elseif len == 2   # one-dimensional grids
		ret = GL.GLMesh(GL.GL_LINES)
		for k = 1:length(cells)
			p1,p2=cells[k]
			c1 = GL.Point4d(rgb[:,p1]...,1)
			c2 = GL.Point4d(rgb[:,p2]...,1)
			p1 = convert(GL.Point3d, points[:,p1]);
			p2 = convert(GL.Point3d, points[:,p2]);
			t = p2-p1;
			n = Lar.LinearAlgebra.normalize([-t[2];+t[1];t[3]])
			#n  = convert(GL.Point3d, n)
			append!(vertices,p1); append!(vertices,p2);
			append!(normals,n);   append!(normals,n);
			append!(colors,c1);    append!(colors,c2);
		end
	elseif len == 3
		ret = GL.GLMesh(GL.GL_TRIANGLES)
		for k = 1:length(cells)
			p1,p2,p3=cells[k]
			c1 = GL.Point4d(rgb[:,p1]...,1)
			c2 = GL.Point4d(rgb[:,p2]...,1)
			c3 = GL.Point4d(rgb[:,p3]...,1)
			p1 = convert(GL.Point3d, points[:,p1]);
			p2 = convert(GL.Point3d, points[:,p2]);
			p3 = convert(GL.Point3d, points[:,p3]);
			n = GL.computeNormal(p1,p2,p3)
			append!(vertices,p1); append!(vertices,p2); append!(vertices,p3);
			append!(normals,n);   append!(normals,n);   append!(normals,n);
			append!(colors,c1);   append!(colors,c2);   append!(colors,c3);
		end
	elseif len == 4
		return viewtetra(V,CV,rgb)
	end
 	ret.vertices = GL.GLVertexBuffer(vertices)
  	ret.normals  = GL.GLVertexBuffer(normals)
  	ret.colors  = GL.GLVertexBuffer(colors)
  	return ret
end
