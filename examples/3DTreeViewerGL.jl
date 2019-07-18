using AlphaStructures
using  DataStructures, LinearAlgebraicRepresentation, ViewerGL
Lar = LinearAlgebraicRepresentation
GL = ViewerGL

#import data
filename = "examples/OBJ/lowpolytree.obj";
V,EVs,FVs = Lar.obj2lar(filename)

#view points
points = convert(Lar.Points,V')
GL.VIEW([
    GL.GLPoints(points)
	GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1))
]);

#construct Delaunay triangulation
AFL = Array{Int64,1}[]
axis = [1.,0.,0.]
tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
DT = AlphaStructures.deWall(V,V,AFL,axis,tetraDict);

#view 3D Delaunay triangulation
GL.VIEW([
    GL.GLGrid(V,DT,GL.Point4d(1,1,1,0.1)) # color and opacity cells
	GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1))
]);

#construct alpha complex
filtration = AlphaStructures.alphaFilter(V);
VV,EV,FV,CV = AlphaStructures.alphaSimplex(V,filtration,0.5)

#view edges
GL.VIEW([
    GL.GLLines(V,EV)
	GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1))
]);

#view faces
GL.VIEW([
      GL.GLPolyhedron(V, FV),
      GL.GLFrame2
]);

#view cells
GL.VIEW([
     GL.GLPolyhedron(V, CV),
	GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1))
]);


# view explode
CVs = [[CV[i]] for i = 1:length(CV)]
meshes = GL.GLExplode(V,CVs,1.2,1.2,1.2,1,1.);
GL.VIEW(meshes);
