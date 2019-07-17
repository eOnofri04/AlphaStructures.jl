#
#	This file contains:
#	 - makeFirstWallSimplex(
#			Ptot::Lar.Points,
#			P::Lar.Points,
#			axis::Array{Float64,1},
#			off::Float64
#		)::Array{Int64,1}
#	 - makeSimplex(f::Array{Int64,1},tetra::Array{Int64,1},Ptot::Lar.Points, P::Lar.Points)
#	 - deWall(
#			Ptot::Lar.Points,
#			P::Lar.Points,
#			AFL::Array{Array{Int64,1},1},
#			axis::Array{Float64,1},
#			lista::DataStructures.Dict{Lar.Cells,1},Array{Int64,1}}
#		)::Lar.Cells
#

"""
    makeFirstWallSimplex(
    	Ptot::Lar.Points,
    	P::Lar.Points,
    	axis::Array{Float64,1},
    	off::Float64
    )::Array{Int64,1}

Return the first simplex of Delaunay triangulation.

---
The makeFirstWallSimplex function selects the point p1 ∈ `P` nearest to the plane `α`.
Then it selects a second point p2 such that:
(a) p2 is on the other side of α from p1, and
(b) p2 is the point in P with the minimum Euclidean distance from p1.
Then, it seeks the point p3 at which the radius of the circum-circle
about 1-face (p1 , p2 ) and point p3 is minimized:
the points (p1 , p2 , p3 ) are a 2-face of the DT(P).
The process continues in the same way until the required first d-simplex is built.
"""
function makeFirstWallSimplex(Ptot::Lar.Points,P::Lar.Points, axis::Array{Float64,1}, off::Float64)
	d = size(P,1)+1 # dimension of upper_simplex
	@assert d < 5 "makeFirstWallSimplex: Function not yet Programmed."
	indices = Int64[]
	found = true

	Pminus,Pplus = AlphaStructures.pointsetPartition(P, axis, off)

	@assert !isempty(Pminus) "makeFirstWallSimplex: Not enough points."
	#The first point of the face is the nearest to middle plane in negative halfspace.
	#for point in Pminus
	distPoint = [AlphaStructures.distPointPlane(Pminus[:,i],axis, off) for i = 1:size(Pminus,2)]
	indMin = findmin(distPoint)[2]
	p1 = Pminus[:, indMin]
	index = findall(x -> x == [p1...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
	push!(indices,index)

	@assert !isempty(Pplus) "makeFirstWallSimplex: Not enough points."
	#The 2nd point of the face is the euclidean nearest to first point that is in the positive halfspace
	#for point in Pplus
	distance = [Lar.norm(p1-Pplus[:,i]) for i = 1:size(Pplus,2)]
	ind2 = findmin(distance)[2]
	p2 = Pplus[:, ind2]
	index = findall(x -> x == [p2...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
	push!(indices,index)

	#The other points are that with previous ones builds the smallest hypersphere.
	#for point in P

	simplexPoint = [p1,p2]

	for dim = length(simplexPoint)+1:d
		try
			radius = [AlphaStructures.foundRadius([simplexPoint...,P[:,i]]) for i = 1:size(P,2)]

			minRad = min(filter(p-> p!=Inf && p!=0,radius)...)
			ind = findall(x->x == minRad, radius)[1]
			p = P[:, ind]

			index = findall(x -> x == [p...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
			push!(simplexPoint,p)
			push!(indices,index)
		catch
			return nothing
		end
	end

	#no points inside the circumball
	for i = 1:size(Ptot,2)
		if AlphaStructures.vertexInCircumball(simplexPoint,AlphaStructures.foundRadius(simplexPoint)-1.e-14,Ptot[:,[i]])
			found = false
		end
	end

    @assert found "makeFirstWallSimplex: first tetrahedron is not found"

	return sort(indices)
end

"""
	makeSimplex(f::Array{Int64,1},tetra::Array{Int64,1},Ptot::Lar.Points, P::Lar.Points)

Given a face `f`, return the adjacent simplices in the outer halfspace,
that is in the opposite halfspace of where `tetra` lies.
One of halfspace associated with `f` contains no point iff face `f` is part of
the Convex Hull of the pointset `P`;
in this case the algorithm correctly returns no adjacent simplex and returns `nothing`.
"""
function makeSimplex(f::Array{Int64,1},tetra::Array{Int64,1},Ptot::Lar.Points, P::Lar.Points)

	found = true
	t = Int64[]
	df = length(f) 	#dimension face
	d = size(P,1)+1 #dimension upper_simplex

	axis = Lar.cross(Ptot[:,f[2]]-Ptot[:,f[1]],Ptot[:,f[3]]-Ptot[:,f[1]])
	off = Lar.dot(axis,Ptot[:,f[1]])
	Pminus,Pplus = AlphaStructures.pointsetPartition(P,axis,off)

	pointIn = Ptot[:,setdiff(tetra,f)]

	simplexPoint = [Ptot[:,v] for v in f]

	if [pointIn...] in [Pplus[:,v] for v in 1:size(Pplus,2)]
		if !isempty(Pminus)
			for dim = df+1:d
				try #da verificare queste
					radius = [AlphaStructures.foundRadius([simplexPoint...,Pminus[:,i]]) for i = 1:size(Pminus,2)]
					minRad = min(filter(p-> p!=0 && p!=Inf,radius)...)
					ind = findall(x->x == minRad, radius)[1]
					p = Pminus[:, ind]
					push!(simplexPoint,p)
					index = findall(x -> x == [p...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
					t = sort([f...,index])
				catch
					return nothing
				end
			end
		else
			return nothing
		end
	else
		if !isempty(Pplus)
			for dim = df+1:d
				try
					radius = [AlphaStructures.foundRadius([simplexPoint...,Pplus[:,i]]) for i = 1:size(Pplus,2)]
					minRad = min(filter(p-> p!=0 && p!=Inf,radius)...)
					ind = findall(x->x == minRad, radius)[1]
					p = Pplus[:, ind]
					push!(simplexPoint,p)
					index = findall(x -> x == [p...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
					t = sort([f...,index])
				catch
					return nothing
				end
			end
		else
			return nothing
		end
	end

	#no points inside the circumball
	for i = 1:size(Ptot,2)
		if AlphaStructures.vertexInCircumball(simplexPoint,AlphaStructures.foundRadius(simplexPoint)-1.e-14,Ptot[:,[i]])
			println("non trovato")
			return nothing
		end
	end

	return t
end


"""
	deWall(
		Ptot::Lar.Points,
		P::Lar.Points,
		AFL::Array{Array{Int64,1},1},
		axis::Array{Float64,1},
		lista::DataStructures.Dict{Lar.Cells,1},Array{Int64,1}}
	)::Lar.Cells

Given a set of points this function returns the upper simplex list
of the Delaunay triangulation.
"""
function deWall(
		Ptot::Lar.Points,
		P::Lar.Points,
		AFL=Array{Int64,1}[]::Array{Array{Int64,1},1},
		axis=[1., 0, 0]::Array{Float64,1},
		tetraDict=DataStructures.Dict{Lar.Cells,Array{Int64,1}}()::DataStructures.Dict{Lar.Cells,Array{Int64,1}}
	)::Lar.Cells

	#se punti planari o pochi punti deve tornare DT=[] e non fermare il corso dell'algoritmo
	@assert size(P,1) == 3  #in R^3

	# 0 - initialization of list
	AFL_α = Array{Int64,1}[]    # (d-1)faces intersected by plane α;
	AFLplus = Array{Int64,1}[]  # (d-1)faces completely contained in PosHalfspace(α);
	AFLminus = Array{Int64,1}[] # (d-1)faces completely contained in NegHalfspace(α).
	DT = Array{Int64,1}[]		# Delaunay triangulation
	tetra = Int64[]# definition
	f = Int64[] # definition

	# 1 - Select the splitting plane α; defined by axis and an origin point `off`
	off = AlphaStructures.splitValue(P,axis)
	if off == nothing
		return DT
	end

	# 2 - construct two subsets P− and P+ ;
	Pminus,Pplus = AlphaStructures.pointsetPartition(P, axis, off)

	# 3 - construct first tetrahedra if necessary
	if isempty(AFL)
		t = AlphaStructures.makeFirstWallSimplex(Ptot,P,axis,off)
		AFL = AlphaStructures.simplexFaces(t)# d-1 - faces of t
		tetraDict[ AFL ] = t
		push!(DT,t)
	end

	for f in AFL
		inters = AlphaStructures.planarIntersection(Ptot, P, f, axis, off)
    		if inters == 0 #intersected by plane α
        		push!(AFL_α, f)
		elseif inters == -1 #in NegHalfspace(α)
        		push!(AFLminus, f)
    		elseif inters == 1 #in PosHalfspace(α)
        		push!(AFLplus, f)
    		end
	end

	# 4 - construct Sα, simplexWall
	while !isempty(AFL_α) #The Sα construction terminates when the AFL_α is empty

		f = popfirst!(AFL_α)

		for (k,v) in tetraDict
			if f in k
				tetra = v
			end
		end

    	T = AlphaStructures.makeSimplex(f, tetra, Ptot, P)

		if T != nothing && T ∉ DT #serve
			push!(DT,T)

			faces = setdiff(AlphaStructures.simplexFaces(T), [f]) # d-1 - faces of t
			tetraDict[ faces ] = T

			for ff in faces
				inters = AlphaStructures.planarIntersection(Ptot, P, ff, axis, off)
				if inters == 0
					AFL_α = AlphaStructures.update(ff, AFL_α)
				elseif inters == -1
					AFLminus = AlphaStructures.update(ff, AFLminus)
				elseif inters == 1
					AFLplus = AlphaStructures.update(ff, AFLplus)
				end
			end
		end

	end

	newaxis = circshift(axis,1)

	if !isempty(AFLminus)
    	DT = union(DT,AlphaStructures.deWall(Ptot,Pminus,AFLminus,newaxis,tetraDict))
	end

	if !isempty(AFLplus)
		DT = union(DT,AlphaStructures.deWall(Ptot,Pplus,AFLplus,newaxis,tetraDict))
	end

	return DT
end
