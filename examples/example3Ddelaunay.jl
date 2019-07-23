using AlphaStructures
using Plasm

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
Plasm.view(V,VV)
DT = AlphaStructures.delaunayWall(V)

Plasm.view(V,DT)
Plasm.viewexploded(V,DT)(1.2,1.2,1.2)
