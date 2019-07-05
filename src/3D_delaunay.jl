"""
    MakeFirstWallSimplex(P::Lar.Points, axis::Array{Float64,1}, off::Float64)::Array{Int64,1}

Return the first simplex of Delaunay triangulation.

---
The MakeFirstWallSimplex function selects the point p1 ∈ `P` nearest to the plane `α`.
Then it selects a second point p2 such that:
(a) p2 is on the other side of α from p1, and
(b) p2 is the point in P with the minimum Euclidean distance from p1.
Then, it seeks the point p3 at which the radius of the circum-circle
about 1-face (p1 , p2 ) and point p3 is minimized:
the points (p1 , p2 , p3 ) are a 2-face of the DT(P).
The process continues in the same way until the required first d-simplex is built.
"""
function MakeFirstWallSimplex(Ptot::Lar.Points,P::Lar.Points, axis::Array{Float64,1}, off::Float64)::Array{Int64,1}

	d = size(P,1)+1 # dimension of upper_simplex
	@assert d < 5 "Error: Function not yet Programmed."
	indices = Int64[]

    Pminus,Pplus = AlphaShape.pointsetPartition(P, axis, off)

	@assert !isempty(Pminus) "Error: Not enough points."
    #The first point of the face is the nearest to middle plane in negative halfspace.
    #for point in Pminus
	distPoint = [AlphaShape.distPointPlane(P[:,i],axis, off) for i = 1:size(Pminus,2)]
	indMin = findmin(distPoint)[2]
	p1 = Pminus[:, indMin]
    index = findall(x -> x == [p1...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
	push!(indices,index)

	@assert !isempty(Pplus) "Error: Not enough points."
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
		radius = [AlphaShape.foundRadius([simplexPoint...,P[:,i]]) for i = 1:size(P,2)]
    	minRad = min(filter(p-> !isnan(p) && p!=0,radius)...)
    	ind = findall(x->x == minRad, radius)[1]
    	p = P[:, ind]
		index = findall(x -> x == [p...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
		@assert p ∉ simplexPoint  "Error: Planar dataset, unable to build first simplex."
		push!(simplexPoint,p)
		push!(indices,index)
	end

    return sort(indices)
end

"""
	MakeSimplex(f::Array{Int64,1},P::Lar.Points)

Given a face `f`, return the adjacent simplices.
One of halfspace associated with `f` contains no point iff face `f` is part of
the Convex Hull of the pointset P;
in this case the algorithm correctly returns no adjacent simplex and returns `nothing`.
"""
function MakeSimplex(f::Array{Int64,1},Ptot::Lar.Points, P::Lar.Points)
	#DA MIGLIORARE
	df = length(f) 	#dimension face
	d = size(P,1)+1 #dimension upper_simplex
	axis = Lar.cross(Ptot[:,f[2]]-Ptot[:,f[1]],Ptot[:,f[3]]-Ptot[:,f[1]])
	off = Lar.dot(axis,Ptot[:,f[1]])
	Pminus,Pplus = AlphaShape.pointsetPartition(P,axis,off)

	simplexPoint = [Ptot[:,v] for v in f]

	if !isempty(Pminus)
		for dim = df+1:d
			radius = [AlphaShape.foundRadius([simplexPoint...,Pminus[:,i]]) for i = 1:size(Pminus,2)]
	    	minRad = min(filter(p-> !isnan(p) && p!=0 && p!=Inf,radius)...)
	    	ind = findall(x->x == minRad, radius)[1]
	    	p = Pminus[:, ind]
			@assert p ∉ simplexPoint " Planar dataset"
		    index = findall(x -> x == [p...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
			t1 = sort([f...,index])
		end
	else t1 = nothing
	end

	if !isempty(Pplus)
		for dim = df+1:d
			radius = [AlphaShape.foundRadius([simplexPoint...,Pplus[:,i]]) for i = 1:size(Pplus,2)]
	    	minRad = min(filter(p-> !isnan(p) && p!=0 && p!=Inf,radius)...)
	    	ind = findall(x->x == minRad, radius)[1]
	    	p = Pplus[:, ind]
			@assert p ∉ simplexPoint " Planar dataset"
		    index = findall(x -> x == [p...], [Ptot[:,i] for i = 1:size(Ptot,2)])[1]
			t2 = sort([f...,index])
		end
	else t2 = nothing
	end

	return t1,t2
end

"""
	Update(element,list)

Return update `list`: if `element` ∈ `list`, delete `element`, else push the `element`.
"""
function Update(element,list)
    if element ∈ list
        setdiff!(list, [element])
    else push!(list,element)
	end
	return list
end

"""
	DeWall(P::Lar.Points,AFL::Array{Array{Int64,1},1},axis::Array{Float64,1})::Array{Array{Int64,1},1}

Given a set of points this function returns the upper simplex list
of the Delaunay triangulation.
"""
function DeWall(Ptot::Lar.Points,P::Lar.Points,AFL::Array{Array{Int64,1},1},axis::Array{Float64,1})::Array{Array{Int64,1},1}
	#se punti planari o pochi punti deve tornare DT=[] e non fermare il corso dell'algoritmo
    @assert size(P,1) == 3  #in R^3

    # 0 - initialization of list
    AFL_α = Array{Int64,1}[]      # (d-1)faces intersected by plane α;
    AFLplus = Array{Int64,1}[]    # (d-1)faces completely contained in PosHalfspace(α);
    AFLminus = Array{Int64,1}[]   # (d-1)faces completely contained in NegHalfspace(α).
    DT = Array{Int64,1}[]

    # 1 - Select the splitting plane α; defined by axis and an origin point `off`
    off = AlphaShape.SplitValue(P,axis)
	if off == nothing
		return DT
	end

	# 2 - construct two subsets P− and P+ ;
    Pminus,Pplus = AlphaShape.pointsetPartition(P, axis, off)

	# 3 - construct first tetrahedra if necessary
    if isempty(AFL)
        t = AlphaShape.MakeFirstWallSimplex(Ptot,P,axis,off) #ToDo da migliorare
        AFL = AlphaShape.Faces(t) # d-1 - faces of t
        push!(DT,t)
    end

    for f in AFL
		inters = AlphaShape.Intersect(Ptot, P, f, axis, off)
        if inters == 0 #intersected by plane α
            push!(AFL_α,f)
        elseif inters == -1 #in NegHalfspace(α)
            push!(AFLminus,f)
        elseif inters == 1 #in PosHalfspace(α)
            push!(AFLplus,f)
        end
    end

	# 4 - construct Sα, simplexWall
    while !isempty(AFL_α) #The Sα construction terminates when the AFL_α is empty
        f = popfirst!(AFL_α)
        T = AlphaShape.MakeSimplex(f, Ptot, P) #ne trova 2 devo prendere quello che non sta in DT
		for t in T
			if t != nothing && t ∉ DT
	            push!(DT,t)
	            for ff in setdiff(AlphaShape.Faces(t),[f])
					inters = AlphaShape.Intersect(Ptot,P, ff, axis, off)
	                if inters == 0
	                    AFL_α = AlphaShape.Update(ff,AFL_α)
	                elseif inters == -1
	                    AFLminus = AlphaShape.Update(ff,AFLminus)
	                elseif inters == 1
	                    AFLplus = AlphaShape.Update(ff,AFLplus)
	                end
	            end
	        end
		end
    end

    newaxis = circshift(axis,1)
    if !isempty(AFLminus)
        DT = union(DT,AlphaShape.DeWall(Ptot,Pminus,AFLminus,newaxis))
    end
    if !isempty(AFLplus)
        DT = union(DT,AlphaShape.DeWall(Ptot,Pplus,AFLplus,newaxis))
    end
    return DT
end
