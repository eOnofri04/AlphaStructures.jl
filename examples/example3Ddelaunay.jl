using Plasm, LinearAlgebraicRepresentation, DataStructures
Lar = LinearAlgebraicRepresentation

function Point3D(n)
    V=[0.;0.;0.]
    for i=1:n-1
        Point = [rand();rand();rand()]
        V=hcat(V,Point)
    end
    return V
end

V = Point3D(50)
VV = [[i] for i =1:size(V,2)]
Plasm.view(V,VV)
Ptot=copy(P)
AFL = Array{Int64,1}[]
axis = [1.,0.,0.]
tetraDict = DataStructures.Dict{Array{Array{Int64,1},1},Array{Int64,1}}()
DT = AlphaShape.DeWall(V,V,AFL,axis,tetraDict)
Plasm.view(V,DT)
Plasm.viewexploded(V,DT)(2.,2.,2.)
