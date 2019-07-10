#
#	This File Contains:
#
#
#

function firstDeWallSimplex(P::Lar.Points, ax::Array{Float64,1}, off::Float64)

end

function delaunayWall(P::Lar.Points, ax = 1)

    function findMedian(P::Lar.Points, ax::Int64)::Float64
        xp = sort(unique(P[ax, :]))
        idx = Int64(floor(length(xp)/2))
        return (xp[idx] + xp[idx+1])/2
    end

    """

    Returns the index of the closet point in `P` to `point`
    """
    function closerPoint(minor::Array{Float64, 1}, P::Lar.Points)::Int64
        vector = P .- minor ## P - minor * ones(1, size(P, 2))
        dist = sum(abs2, vector, dims = 1)
        return findmin(dist[:])[2]
    end

    dim = size(P, 1)
    n = size(P, 2)

    off = findMedian(P, ax)

    Pminor = findall(x -> x < off, P[ax, :])
    Pmajor = findall(x -> x > off, P[ax, :])



    #idxmajor = closerPoint(minor, P[:,Pmajor])
    #major = P[:, Pmajor[idxmajor]]
    #indices = [idxminor idxmajor]
    #Psimplex = [minor major]

    idxminor = findmax(P[ax, Pminor])[2]
    indices = [idxminor]
    Psimplex = P[:, Pminor[idxminor]][:,:]  #Array{Float64,2}
    # idxmajor = findSimplexPoint(Psimplex, P[:, Pmajor])
    # indices = [indices; idxmajor]           #Array{Int64,1}
    # Psimplex = [Psimplex P[:, Pmajor[idxmajor]]]

    pointsSelection = Pmajor

    for d = 1 : dim+1
        newidx = findSimplexPoint(Psimplex, P[:, pointsSelection])
        indices = [indices; newidx]
        Psimplex = [Psimplex P[:, newidx]]
        pointsSelection = [i for i = 1 : n if i ∉ indices]
    end
end

function findSimplexPoint(Psimplex::Lar.Points, P::Lar.Points)
    simplexDim = size(Psimplex, 2)
    assert(simplexDim <= size(Psimplex, 1),
        "Cannot add another point to the simplex"
    )
    if simplexDim == 1
        vector = P .- simplexDim[:, 1] ## P - point * ones(1, size(P, 2))
        dist = sum(abs2, vector, dims = 1)
        idx = findmin(dist[:])[2]
    else
        idx = findmin([AlphaStructures.findRadius([Psimplex P[:,col]]) for col = 1 : size(P, 2)])[2]
    end

    return idx
end

function findRadius(P::Lar.Points)
    AlphaStructures.foundRadius([P[:,i] for i = 1 : size(P, 2)])
end
