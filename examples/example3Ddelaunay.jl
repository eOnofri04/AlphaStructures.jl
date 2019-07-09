using AlphaStructures, DataStructures, LinearAlgebraicRepresentation, Plasm
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

AFL = Array{Int64,1}[]
axis = [1.,0.,0.] #se non trova niente con un asse provo con un altro
tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
DT = AlphaStructures.DeWall(V,V,AFL,axis,tetraDict)


Plasm.view(V,DT)
Plasm.viewexploded(V,DT)(5.,5.,5.)
