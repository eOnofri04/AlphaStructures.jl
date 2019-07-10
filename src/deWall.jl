#
#	This File Contains:
#
#
#

function firstDeWallSimplex(P::Lar.Points, ax::Int64, off::Float64)

	"""
        findSimplexPoint(Psimplex::Lar.Points, P::Lar.Points)

    Returnd the index of the closest point in `P` to the `Psimplex` points.
    """
    function findSimplexPoint(Psimplex::Lar.Points, P::Lar.Points)
        simplexDim = size(Psimplex, 2)
        @assert simplexDim <= size(Psimplex, 1) "Cannot add
			another point to the simplex"
        #if simplexDim == 1
        #    vector = P .- simplexDim[:, 1] ## P - point * ones(1, size(P, 2))
        #    dist = sum(abs2, vector, dims = 1)
        #    return findmin(dist[:])[2]
        #end

		###!!!!!!!!!! NaN error

        findmin(
            [
                findRadius([Psimplex P[:,col]])
                for col = 1 : size(P, 2)
            ]
    	)[2]
    end

	dim = size(P, 1)
    n = size(P, 2)

    # the first point of the simplex is the one with coordinate `ax` maximal
    #  such that it is less than `off` (closer to α from minus)
	Pselection = findall(x -> x < off, P[ax, :])
    newidx = Pselection[findmax(P[ax, Pselection])[2]]
    # indices will store the indices of the simplex ...
    indices = [newidx]                      #Array{Int64,1}
    # ... and `Psimplex` will store the corresponding points
    Psimplex = P[:, newidx][:,:]    #Array{Float64,2}

    # the second point must be seeken across those with coordinate `ax`
    #  grater than `off`
    Pselection = findall(x -> x > off, P[ax, :])

    for d = 1 : dim
        newidx = Pselection[findSimplexPoint(Psimplex, P[:, Pselection])]
        indices = [indices; newidx]
        Psimplex = [Psimplex P[:, newidx]]
        Pselection = [i for i = 1 : n if i ∉ indices]
    end

    # Correctness check
	center = findCenter(Psimplex)
	radius = Lar.norm(center - Psimplex[:, 1])
    for i = 1 : n
		@assert Lar.norm(center - P[:, i]) >= radius "ERROR:
			Unable to find first Simplex."
	end

	return indices
end

function delaunayWall(P::Lar.Points, ax = 1)

    """
        findMedian(P::Lar.Points, ax::Int64)::Float64

    Returns the median of the `P` points across the `ax` axis
    """
    function findMedian(P::Lar.Points, ax::Int64)::Float64
        xp = sort(unique(P[ax, :]))
        idx = Int64(floor(length(xp)/2))
        return (xp[idx] + xp[idx+1])/2
    end

    #---------------------------------------------------------------------------

    dim = size(P, 1)
    n = size(P, 2)

    off = findMedian(P, ax)

    indices = firstDeWallSimplex(P, ax, off)
end


"""
	findRadius(P::Lar.Points)

Utility function to change Lar.Points->{Array{Array,1},1}
Will be removed ?
"""
function findRadius(P::Lar.Points)::Float64
	AlphaStructures.foundRadius([P[:,i] for i = 1 : size(P, 2)])
end

"""
	findCenter(P::Lar.Points)

Utility function to change Lar.Points->{Array{Array,1},1}
Will be removed ?
"""
function findCenter(P::Lar.Points)::Array{Float64,2}
	AlphaStructures.foundCenter([P[:,i] for i = 1 : size(P, 2)])[:,:]
end
