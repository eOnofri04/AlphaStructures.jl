using  DataStructures, LinearAlgebraicRepresentation, Plasm
Lar = LinearAlgebraicRepresentation

filename = "examples/OBJ/lowpolytree.obj";
V,EVs,FVs = Lar.obj2lar(filename)

Plasm.view(V,[[i] for i = 1:size(V,2)])

AFL = Array{Int64,1}[]
axis = [1.,0.,0.]
tetraDict = DataStructures.Dict{Lar.Cells,Array{Int64,1}}()
DT = AlphaStructures.deWall(V,V,AFL,axis,tetraDict)

#to view Delaunay Triangulation
Plasm.view(V,DT)
Plasm.viewexploded(V,DT)(2.,2.,2)


filtration = AlphaStructures.alphaFilter(V);

VV,EV,FV,CV = AlphaStructures.alphaSimplex(V,filtration,0.5)

#to view alpha complex
Plasm.view(V, VV)
Plasm.view(V, EV)
Plasm.view(V, FV)
Plasm.view(V, CV)
Plasm.viewexploded(V,CV)(2.,2.,2)

# view colored, different colors for each cell
CVs = [[CV[i]] for i = 1:length(CV)]
Plasm.viewcolor(V, CVs)

#possiamo fare la stessa cosa
filter_key = unique(keys(filtration))

granular = 15

reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]

for α in reduced_filter
	VV,EV,FV,CV = AlphaStructures.alphaSimplex(V, filtration, α)
	Plasm.view(V, CV)
end
