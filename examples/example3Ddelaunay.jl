#using AlphaStructures
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

P = Point3D(70)
VV = [[i] for i =1:size(P,2)]
Plasm.view(P,VV)

DT = AlphaStructures.deWall(P,P)


Plasm.view(P,DT)

"""
open("dati.txt", "w") do f
    for j=1:3
           for i in 1:size(P,2)
               p=P[j,i]
              write(f, "$p ")
           end
            write(f, "; \n")
       end
   end

model=(P,[VV,[],[],DT])
Plasm.view(Plasm.numbering(2.)(model))


AFL = Array{Int64,1}[]
axis = [1.,0.,0.] #se non trova niente con un asse provo con un altro
tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
DT = AlphaStructures.deWall(V,V,AFL,axis,tetraDict)


Plasm.view(V,DT)
Plasm.viewexploded(V,DT)(5.,5.,5.)



#prove

P = [
			0.0 1.0 0.0 2.0 0.0 1.0 0.0 2.0;
			0.0 0.0 1.0 2.0 0.0 0.0 1.0 2.0;
			0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0
		]


DT = AlphaStructures.deWall(P,P)
"""
