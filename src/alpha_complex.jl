export alphaFilter, alphaSimplex, delaunayTriangulation
#===============================================================================
#
#	src/alpha_complex.jl
#
#	This File Contains:
#
#	 - alphaFilter(
#			V::Lar.Points,
#			DT = Array{Int64,1}[];
#			digits=64
#		)::DataStructures.SortedMultiDict{}
#
#	 - alphaSimplex(
#			V::Lar.Points,
#			filtration::DataStructures.SortedMultiDict{},
#			α_threshold::Float64
#		)::Array{Lar.Cells,1}
#
#	 - delaunayTriangulation(
#			V::Lar.Points
#		)::Lar.Cells
#
===============================================================================#

"""
	alphaFilter(
		V::Lar.Points, DT = Array{Int64,1}[];
		digits=64
	)::DataStructures.SortedMultiDict{}

Return ordered collection of pairs `(alpha charatteristic, complex)`.

This method evaluates the ``\alpha``-filter over the sites `S`.
If a Delaunay Triangulation `DT` is not specified than it is evaluated
via `AlphaStructures.delaunayTriangulation()`.

# Examples
```jldoctest
julia> V = [1. 2. 1. 2.; 0. 0. 1. 2. ];

julia> AlphaStructures.alphaFilter(V)
SortedMultiDict(Base.Order.ForwardOrdering(),
	0.0 => [1],
	0.0 => [2],
	0.0 => [3],
	0.0 => [4],
	0.5 => [1, 2],
	0.5 => [1, 3],
	0.70710678118655 => [2, 3],
	0.70710678118655 => [3, 4],
	0.70710678118655 => [1, 2, 3],
	1.0 => [2, 4],
	1.0 => [2, 3, 4]
)

```
"""
function alphaFilter(
		V::Lar.Points,
		DT = Array{Int64,1}[];
		digits=64
	)::DataStructures.SortedMultiDict{}

	dim = size(V, 1)
	Cells = [Array{Array{Int64,1},1}() for i=1:dim]  #Generalize definition

	# 1 - Delaunay triangulation of ``V``
	if isempty(DT)
		Cells[dim] = AlphaStructures.delaunayTriangulation(V)
	else
		Cells[dim] = DT
	end

	# 2 - 1..d-1 Cells Construction
	# Cells[d] = Array{Int64}[]
	for d = dim-1 : -1 : 1
		for cell in Cells[dim]
			# It gives back combinations in natural order
			newCells = collect(Combinatorics.combinations(cell, d+1))
			push!(Cells[d], newCells...)
		end
		Cells[d] = unique(sort(Cells[d]))
	end

	# 3 - Evaluate Circumballs Radius

	α_char = [ zeros(length(Cells[i])) for i in 1 : dim ]
	for d = 1 : dim
		for i = 1 : length(Cells[d]) # simplex in Cells[d]
			simplex = Cells[d][i]
			α_char[d][i] = findRadius(V[:, simplex], digits=digits);
		end
	end

	# 4 - Evaluate Charatteristical α

	for d = dim-1 : -1 : 1
		for i = 1 : length(Cells[d])    # simplex in Cells[d]
			simplex = Cells[d][i]
			for j = 1 : length(Cells[d+1])  # up_simplex in Cells[d+1]
				up_simplex = Cells[d+1][j]
				if issubset(simplex, up_simplex) #contains(up_simplex, simplex)
					point = V[:, setdiff(up_simplex, simplex)]
					if vertexInCircumball(V[:, simplex], α_char[d][i], point)
						α_char[d][i] = α_char[d+1][j]
					end
				end
			end
		end
	end

	# 5 - Sorting Complex by Alpha
	filtration = DataStructures.SortedMultiDict{Float64, Array{Int64,1}}()

	# each point => α_char = 0.
	for i = 1 : size(V, 2)
		insert!(filtration, 0., [i])
	end

	for d = 1 : dim
		for i = 1 : length(Cells[d])
			insert!(filtration, α_char[d][i], Cells[d][i])
		end
	end

	return filtration
end

#-------------------------------------------------------------------------------

"""
	alphaSimplex(
		V::Lar.Points,
		filtration::DataStructures.SortedMultiDict{},
		α_threshold::Float64
	)::Array{Lar.Cells,1}

Return collection of all `d`-simplex, for `d ∈ [0,dimension]`,
	with characteristic α less than a given value `α_threshold`.
"""
function alphaSimplex(
		V::Lar.Points,
		filtration::DataStructures.SortedMultiDict{},
		α_threshold::Float64
	)::Array{Lar.Cells,1}

	dim = size(V, 1)
	# [VV, EV, FV, ...]
	simplexCollection = [ Array{Array{Int64,1},1}() for i = 1 : dim+1 ]

	for (k, v) in filtration
        if k <= α_threshold
        	push!(simplexCollection[length(v)], v)
    	else
			break
    	end
    end

	sort!.(simplexCollection)

	return simplexCollection
end

#-------------------------------------------------------------------------------

"""
	delaunayTriangulation(V::Lar.Points)::Lar.Cells

Return highest level simplices of Delaunay triangulation.
"""
function delaunayTriangulation(V::Lar.Points)::Lar.Cells
	dim = size(V, 1)
	@assert dim > 0 "Error: V do not contains points."
	@assert dim < 4 "Error: Function not yet Programmed."

	if dim == 1
		vertices = vcat(V...)
		p = sortperm(vertices)
		upper_simplex = [[p[i],p[i+1]] for i=1:length(p)-1]

	elseif dim == 2
		vertices = convert(Array{Float64,2},V')
		points_map = Array{Int64,1}(collect(1:1:size(vertices)[1]))
		@assert size(vertices, 1) > 3
		upper_simplex = Triangle.basic_triangulation(vertices, points_map)

	elseif dim == 3
		upper_simplex = AlphaStructures.delaunayWall(V)
	end

	sort!.(upper_simplex)

	return sort(upper_simplex)
end
