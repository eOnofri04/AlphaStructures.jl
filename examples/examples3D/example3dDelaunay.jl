using AlphaStructures
using ViewerGL
GL = ViewerGL

function Point3D(n)
    V = rand(3)
    for i = 1:n-1
        Point = rand(3)
        V = hcat(V,Point)
    end
    return V
end


V = Point3D(50)
VV = [[i] for i = 1:size(V,2)]
GL.VIEW([ GL.GLGrid(V,VV) ])
DT = AlphaStructures.delaunayWall(V)

GL.VIEW([ GL.GLGrid(V, DT) ])
GL.VIEW(
    GL.GLExplode(
        V,
        [[σ] for σ in DT],
        1,1,1,	# Explode Ratio
        99, 1.		# Colors
    )
)
