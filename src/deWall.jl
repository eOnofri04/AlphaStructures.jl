export deWall;
#===============================================================================
#
#	src/deWall.jl
#
#	This File Contains:
#
#	 - delaunayWall(
#			P::Lar.Points,
#			ax = 1,
#			AFL = Array{Int64,1}[];
#			DEBUG = false
#		)::Lar.Cells
#
#	 - firstDeWallSimplex(
#			P::Lar.Points,
#			ax::Int64,
#			off::Float64;
#			DEBUG = false
#		)::Array{Int64,1}
#
#	 - findWallSimplex(
#			P::Lar.Points,
#			face::Array{Int64,1},
#			oppoint::Array{Float64,1};
#			DEBUG = false
#		)::Union{Array{Int64,1}, Nothing}
#
#	 - recursiveDelaunayWall(
# 			P::Lar.Points,
# 			tetraDict::DataStructures.Dict{Array{Int64,1},Array{Float64,1}},
# 			AFL::Array{Array{Int64,1},1},
# 			ax::Int64,
# 			off::Float64,
# 			positive::Bool;
# 			DEBUG = false
# 		)::Lar.Cells
#
#	 - updateAFL!(
#			P::Lar.Points
#			new::Array{Int64,1}[],
#			AFLα = Array{Int64,1}[],
#			AFLplus = Array{Int64,1}[],
#			AFLminus = Array{Int64,1}[],
#			ax::Int64,
#			off::Float64;
# 			DEBUG = false
#		)::Bool
#
#	 - updatelist!(
#			list,
#			element
#		)::Bool
#
#	 - updateTetraDict!(
#			P::Lar.Points,
#			tetraDict::DataStructures.Dict{Array{Int64,1},Array{Float64,1}},
#			AFL::Array{Array{Int64,1},1},
#			σ::Array{Int64,1}
#		)::Nothing
#
===============================================================================#

"""
	delaunayWall(
		P::Lar.Points, ax = 1, AFL = Array{Int64,1}[];
		DEBUG = false
	)::Lar.Cells

Return the Delaunay Triangulation of sites `P` via Delaunay Wall algorithm.
The optional argument `ax` specify on wich axis it will build the Wall.
The optional argument `AFL` is used in recursive call.
If the keyword argument `DEBUG` is set to true than all the procedure is shown.
"""

function delaunayWall(
		P::Lar.Points,
		ax = 1,
		AFL = Array{Int64,1}[],
		tetraDict = DataStructures.Dict{Array{Int64,1},Array{Float64,1}}();
		DEBUG = false
	)::Lar.Cells

	if DEBUG @show "Delaunay Wall with parameters" P ax AFL tetraDict end

	# 0 - Data Reading and Container definition
	DT = Array{Int64,1}[]		# Delaunay Triangulation
	AFLα = Array{Int64,1}[]		# (d-1)faces intersecting the Wall
	AFLplus = Array{Int64,1}[]  # (d-1)faces in positive Wall half-space
	AFLminus = Array{Int64,1}[] # (d-1)faces in positive Wall half-space
	off = AlphaStructures.findMedian(P, ax)

	# 1 - Determine first simplex (if necessary)
	if isempty(AFL)
		σ = sort(AlphaStructures.firstDeWallSimplex(P, ax, off, DEBUG = DEBUG))
		push!(DT, σ)
		AFL = AlphaStructures.simplexFaces(σ)
		AlphaStructures.updateTetraDict!(P, tetraDict, AFL, σ)
	end

	# 2 - Build `AFL*` according to the axis `ax` with contant term `off`
	AlphaStructures.updateAFL!(
		P, AFL, AFLα, AFLplus, AFLminus, ax, off, DEBUG = DEBUG
	)

	# 4 - Build simplex Wall
	while !isempty(AFLα)
		# if face ∈ keys(tetraDict) oppoint = tetraDict[face]
		# else Pselection = setdiff([i for i = 1 : n], face) end
		if ( σ = AlphaStructures.findWallSimplex(
				P, AFLα[1], tetraDict[AFLα[1]], DEBUG=DEBUG
			) ) != nothing
			push!(DT, σ)
			AFL = AlphaStructures.simplexFaces(σ)
			AlphaStructures.updateTetraDict!(P, tetraDict, AFL, σ)
			# Split σ's Faces according in semi-spaces
			AlphaStructures.updateAFL!(
				P, AFL, AFLα, AFLplus, AFLminus, ax, off, DEBUG=DEBUG
			)
		else
			@assert AlphaStructures.updatelist!(AFLα, AFLα[1]) == false "ERROR:
				Something unespected happends while removing a face."
		end
	end

	# 5 - Change the axis `ax` and repeat until there are no faces but exposed.
	#      A.K.A. Divide & Conquer phase.
	if !isempty(AFLminus)
		union!(DT, recursiveDelaunayWall(
			P, tetraDict, AFLminus, ax, off, false; DEBUG = DEBUG
		))
	end
	if !isempty(AFLplus)
		union!(DT, recursiveDelaunayWall(
			P, tetraDict, AFLplus, ax, off, true; DEBUG = DEBUG
		))
	end

	return DT
end

#-------------------------------------------------------------------------------
"""
	findWallSimplex(
		P::Lar.Points, face::Array{Int64,1}, oppoint::Array{Float64,1};
		DEBUG = false
	)::Union{Array{Int64,1}, Nothing}

Returns the simplex 'σ' build with `face` and a point from `P`
such that it is in the opposite half plane of `oppoint`.
If such a simplex do not exists it returns `nothing`.
If the keyword argument `DEBUG` is set to true than all the procedure is shown.
"""
function findWallSimplex(
		P::Lar.Points,
		face::Array{Int64,1},
		oppoint::Array{Float64,1};
		DEBUG = false
	)::Union{Array{Int64,1}, Nothing}

	if DEBUG @show "find Wall Simplex of" face oppoint end
	# Find the points in the halfspace defined by `face` that do not
	#  containsother the other point of the simplex.
	Pselection =
		AlphaStructures.oppositeHalfSpacePoints(P, face, oppoint)

	if DEBUG @show Pselection end

	# If there are no such points than the face is part of the convex hull.
	if isempty(Pselection)
		return nothing
	end

	# Find the Closest Point in the other halfspace with respect to σ
	#  according to dd-distance.
	idxbase = AlphaStructures.findClosestPoint(
		P[:, face], P[:, Pselection], metric = "dd"
	)

	@assert !isnothing(idxbase)
	# if isnothing(idxbase)
	# 	return nothing
	# end

	σ = sort([face; Pselection[idxbase]])
	if DEBUG @show "Found face" σ end

	# Check the simplex correctness
	radius, center = AlphaStructures.findRadius(P[:, σ], true)
	for i = 1 : size(P, 2)
		if Lar.norm(center - P[:, i]) < radius
			@assert i ∉ Pselection "ERROR: Numerical error
				evaluating minimum radius for $σ"
			@show σ "discarded due to a closer point."
			return nothing
		end
	end

	return σ
end


#-------------------------------------------------------------------------------

"""
 	firstDeWallSimplex(
		P::Lar.Points, ax::Int64, off::Float64;
		DEBUG = false
	)::Array{Int64,1}

Returns the indices array of the points in `P` that form the first thetrahedron
built over the Wall if the `ax` axes with contant term `off`.
If the keyword argument `DEBUG` is set to true than all the procedure is shown.

# Examples
```jldoctest

julia> V = [
	0.0 1.0 0.0 0.0 2.0
	0.0 0.0 1.0 0.0 2.0
	0.0 0.0 0.0 1.0 2.0
];

julia> firstDeWallSimplex(V, 1, AlphaStructures.findMedian(V,1))
4-element Array{Int64,1}:
 1
 2
 3
 4

```
"""
function firstDeWallSimplex(
		P::Lar.Points,
		ax::Int64,
		off::Float64;
		DEBUG = false
	)::Array{Int64,1}

	dim = size(P, 1)
    n = size(P, 2)

	if DEBUG println("Determine first Simplex with ax = $ax") end
    # the first point of the simplex is the one with coordinate `ax` maximal
    #  such that it is less than `off` (closer to α from minus)
	Pselection = findall(x -> x < off, P[ax, :])
	# it gives an error if no point are less than `off`
	#  in fact it means that all the points are located on the median,
	#  with respect to `ax`.
	@assert !isempty(Pselection) "ERROR: not able to build the first Delaunay
		dimplex; all the points have the same `ax` coordinate."
    newidx = Pselection[findmax(P[ax, Pselection])[2]]
    # indices will store the indices of the simplex ...
    indices = [newidx]                      #Array{Int64,1}
    # ... and `Psimplex` will store the corresponding points
    Psimplex = P[:, newidx][:,:]    #Array{Float64,2}

    # the second point must be seeken across those with coordinate `ax`
    #  grater than `off`
    Pselection = findall(x -> x > off, P[ax, :])

    for d = 1 : dim
		idxbase = AlphaStructures.findClosestPoint(Psimplex, P[:, Pselection])
		@assert !isnothing(idxbase) "ERROR:
			not able to determine first Delaunay Simplex"
        newidx = Pselection[idxbase]
        indices = [indices; newidx]
        Psimplex = [Psimplex P[:, newidx]]
        Pselection = [i for i = 1 : n if i ∉ indices]
    end

    # Correctness check
	radius, center = AlphaStructures.findRadius(Psimplex, true)
    for i = 1 : n
		@assert Lar.norm(center - P[:, i]) >= radius "ERROR:
			Unable to find first Simplex."
	end

	if DEBUG println("First Simplex = $indices") end

	return indices
end

#-------------------------------------------------------------------------------

"""
	recursiveDelaunayWall(
		P::Lar.Points,
		tetraDict::DataStructures.Dict{Array{Int64,1},Array{Float64,1}},
		AFL::Array{Array{Int64,1},1},
		ax::Int64,
		off::Float64,
		positive::Bool;
		DEBUG = false
	)::Lar.Cells

Utility function that prepeares the Divide phase for Delaunay Wall.
Returns the Delaunay Triangulation for the positve or negative subspace of `P`
(according to `positive`) determined by the hyperplane with normal `ax` and
constant term `off`.
If the keyword argument `DEBUG` is set to true than all the procedure is shown.
"""
function recursiveDelaunayWall(
		P::Lar.Points,
		tetraDict::DataStructures.Dict{Array{Int64,1},Array{Float64,1}},
		AFL::Array{Array{Int64,1},1},
		ax::Int64,
		off::Float64,
		positive::Bool;
		DEBUG = false
	)::Lar.Cells

	dim, n = size(P)
	newaxis = mod(ax, dim) + 1

	if DEBUG println("Divide Plus/Minus $positive") end

	Psubset = findall(x -> (x > off) == positive, P[ax, :])

	if DEBUG println("Step In") end

	DT = AlphaStructures.delaunayWall(
			P[:, Psubset],
			newaxis,
			[[findall(Psubset.==p)[1] for p in σ] for σ in AFL],
			Dict([
				[findall(Psubset.==p)[1] for p in k] => v
				for (k,v) in tetraDict
					if k ⊆ Psubset
			])
		)

	if DEBUG @show "Step Out with " DT end

	return [[Psubset[i] for i in σ] for σ in DT]
end

#-------------------------------------------------------------------------------

"""
	updateAFL!(
		P::Lar.Points
		new::Array{Int64,1}[],
		AFLα = Array{Int64,1}[],
		AFLplus = Array{Int64,1}[],
		AFLminus = Array{Int64,1}[],
		ax::Int64, off::Float64;
		DEBUG = false
	)::Bool

Modify the `AFL*` lists of faces by adding to them the faces inside `new`
(that refers to the points `P`) according to their position with respect
to the axis defined by the normal direction `ax` and the contant term `off`.
The function returns a Bool value that states if the operation was succesfully.
If the keyword argument `DEBUG` is set to true than all the procedure is shown.
"""
function updateAFL!(
		P::Lar.Points,
		newσ::Array{Array{Int64,1},1},
		AFLα::Array{Array{Int64,1},1},
		AFLplus::Array{Array{Int64,1},1},
		AFLminus::Array{Array{Int64,1},1},
		ax::Int64, off::Float64;
		DEBUG = false
	)::Bool

	for face in newσ
		inters = AlphaStructures.planarIntersection(P, face, ax, off)
    	if inters == 0 # intersected by plane α
			AlphaStructures.updatelist!(AFLα, face)
		elseif inters == -1 # in NegHalfspace(α)
        	AlphaStructures.updatelist!(AFLminus, face)
    	elseif inters == 1 # in PosHalfspace(α)
        	AlphaStructures.updatelist!(AFLplus, face)
    	else
			return false
		end
	end

	if DEBUG @show AFLα AFLminus AFLplus end

	return true

end

#-------------------------------------------------------------------------------

"""
	updatelist!(list, element)::Bool

If `element` is in `list` then it is removed (returns `false`);
If `element` is not in `list` then it is added (returns `true`).

# Examples
```jldoctest
julia> list = [[1, 2, 3, 4], [2, 3, 4, 5]]
2-element Array{Array{Int64,1},1}:
 [1, 2, 3, 4]
 [2, 3, 4, 5]

julia> updatelist!(list, [1, 2, 4, 5])
true

julia> list
3-element Array{Array{Int64,1},1}:
 [1, 2, 3, 4]
 [2, 3, 4, 5]
 [1, 2, 4, 5]

julia> updatelist!(list, [1, 2, 4, 5])
false

julia> list
2-element Array{Array{Int64,1},1}:
 [1, 2, 3, 4]
 [2, 3, 4, 5]

```
"""

function updatelist!(list, element)::Bool
	if element ∈ list
		setdiff!(list, [element])
		return false
	else
		push!(list, element)
		return true
	end
end

#-------------------------------------------------------------------------------

"""
	updateTetraDict!(
		P::Lar.Points,
		tetraDict::DataStructures.Dict{Array{Int64,1},Array{Float64,1}},
		AFL::Array{Array{Int64,1},1},
		σ::Array{Int64,1}
	)::Nothing

Update the content of `tetraDict` by adding the outer points of the faces of `σ`
in the dictionary.
"""
function updateTetraDict!(
		P::Lar.Points,
		tetraDict::DataStructures.Dict{Array{Int64,1},Array{Float64,1}},
		AFL::Array{Array{Int64,1},1},
		σ::Array{Int64,1}
	)::Nothing
	for cell in AFL
		point = setdiff(σ, cell)
		@assert length(point) == 1 "Error during update of TetraDict"
		tetraDict[ cell ] = P[:, point[1]]
	end
end
