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

This method evaluates the `α`-filter over the sites `S`.
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
	)::DataStructures.SortedDict{}

	dim = size(V, 1)
	filtration = DataStructures.SortedDict{Array{Int64,1},Float64}()

	# 1 - Each point => alpha_char = 0.
	for i = 1 : size(V, 2)
		insert!(filtration, [i], 0.)
	end

	# 2 - Delaunay triangulation of ``V``
	if isempty(DT)
		DT = AlphaStructures.delaunayTriangulation(V)
	end

	n_upsimplex = length(DT)

	# 3 - process all upper simplex
	ind = 1
	for upper_simplex in DT
		if ind % 500000 == 0
			println(ind," simplices processed of ", n_upsimplex)
		end
		AlphaStructures.processuppersimplex(V,upper_simplex,filtration; digits = digits)
		ind = ind + 1
	end

	return filtration
end

"""
	processuppersimplex(
		V::Lar.Points,
		up_simplex::Array{Int64,1},
		filtration::DataStructures.SortedDict{};
		digits=64
		)

Process the upper simplex.
"""
function processuppersimplex(
		V::Lar.Points,
		up_simplex::Array{Int64,1},
		filtration::DataStructures.SortedDict{};
		digits=64
		)

	α_char = AlphaStructures.findRadius(V[:, up_simplex], digits=digits);
	insert!(filtration, up_simplex, α_char)

	d = length(up_simplex)-1
	if d > 1
		# It gives back combinations in natural order
		newsimplex = collect(Combinatorics.combinations(up_simplex,d))
		for lowsimplex in newsimplex
			AlphaStructures.processlowsimplex(V, up_simplex, lowsimplex, filtration; digits=digits)
		end
	end
end

"""
	processlowsimplex(
		V::Lar.Points,
		up_simplex::Array{Int64,1},
		lowsimplex::Array{Int64,1},
		filtration::DataStructures.SortedDict{};
		digits=64
		)

Process the lower simplex knowing the upper.
"""
function processlowsimplex(
	V::Lar.Points,
	up_simplex::Array{Int64,1},
	lowsimplex::Array{Int64,1},
	filtration::DataStructures.SortedDict{};
	digits=64)

	α_char = AlphaStructures.findRadius(V[:, lowsimplex], digits=digits)
	point = V[:, setdiff(up_simplex, lowsimplex)]

	if AlphaStructures.vertexInCircumball(V[:, lowsimplex], α_char, point)
		filtration[lowsimplex] = filtration[up_simplex]

	elseif !haskey(filtration, lowsimplex)
		filtration[lowsimplex] = α_char

	end

	d = length(lowsimplex)-1
	if d > 1
		# It gives back combinations in natural order
		newsimplex = collect(Combinatorics.combinations(lowsimplex,d))
		for simplex in newsimplex
			 AlphaStructures.processlowsimplex(V, lowsimplex, simplex, filtration, digits=digits)
		end
	end
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
		filtration::DataStructures.SortedDict{},
		α_threshold::Float64
	)::Array{Lar.Cells,1}

	dim = size(V, 1)
	# [VV, EV, FV, ...]
	simplexCollection = [ Array{Array{Int64,1},1}() for i = 1 : dim+1 ]

	for (k, v) in filtration
        if v <= α_threshold
        	push!(simplexCollection[length(k)], k)
    	end
    end

	sort!.(simplexCollection)

	return simplexCollection
end
