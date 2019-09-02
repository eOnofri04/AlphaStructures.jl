
using ViewerGL
GL = ViewerGL

function Point2D(n)
    V = rand(2)
    for i = 1:n-1
        Point = rand(2)
        V = hcat(V,Point)
    end
    return V
end

V = [   0.502828  0.826357  0.382718  0.294096  0.915404  0.826495 ;
      0.38892   0.271417  0.160461  0.14537   0.131448  0.352661 ]
V = Point2D(6)
VV = [[i] for i = 1:size(V,2)]
GL.VIEW([ GL.GLGrid(V,VV) ])
DT = AlphaStructures.delaunayWall(V)

#GL.VIEW([ GL.GLGrid(V, DT) ])
GL.VIEW(
    GL.GLExplode(
        V,
        [[σ] for σ in DT],
        1., 1., 1.,	# Explode Ratio
        99, 0.3		# Colors
    )
)
