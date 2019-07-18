using AlphaStructures
using DataStructures, LinearAlgebraicRepresentation, Plasm
Lar = LinearAlgebraicRepresentation

function Point3D(n)
    V = rand(3)
    for i=1:n-1
        Point = rand(3)
        V=hcat(V,Point)
    end
    return V
end

P = Point3D(30)
VV = [[i] for i =1:size(P,2)]
Plasm.view(P,VV)

DT = AlphaStructures.deWall(P,P)

Plasm.view(P,DT)
