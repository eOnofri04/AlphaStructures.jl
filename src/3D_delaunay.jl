# α è un piano perpendicolare agli assi e che si sposta a metà del pointset,
# piano ortogonale ad ogni chiamata di dewall

function pointsetPartition(P, axis, off)
    coord = findall(x->x==1,axis)[1]
    Pminus = P[:,findall(x-> x < off,P[coord,:])]
    Pplus = P[:,findall(x-> x > off,P[coord,:])]
    return Pminus,Pplus
end

function MakeFirstWallSimplex(P,α)

end

function Faces(t)

end

function Intersect(f,α)

end

function NegHalfspace(α)

end

function PosHalfspace(α)
    
end

function MakeSimplex(f,P)

end

function Update(element,list)
    if element ∈ list
        setdiff!(list, [element])
    else push!(list,element)
end

"""
 DeWall

 Given a vector v of n Point3 this function returns the tetrahedra list
 of the Delaunay triangulation of points. This Functions uses the
 MergeFirst Divide and Conquer algorithm DeWall [Cignoni 92].

 This algorithm make use of Speed up techniques suggested in the paper
 yelding an average linear performance (against a teorethical cubic worst
 case.

 [Cignoni 92]
P. Cignoni, C. Montani, R. Scopigno
"A Merge-First Divide and Conquer Algorithm for E^d  Delaunay Triangulation"
CNUCE Internal Report C92/16 Oct 1992
"""
#pseudocodice
function DeWall(P::Lar.Points,AFL::face_list,axis::Array{Int64,1})::simplex_tassellation

    @assert size(P,1) == 3  #in R^3
    @assert size(P,2) > 1 #almeno 2 punti

    # 0 - initialization of list
    AFL_α = []      #
    AFLplus = []    # face list:
    AFLminus = []   #
    DT = []

    # 1 - Define plane α by axis and a origin point off
    coord = findall(x->x==1,axis)[1] #forse si può migliorare
    cols = sortperm(P[coord,:])
    sortP = P[:,cols]
    numberPoint = size(sortP,2)
    off = (sortP[coord,floor(Int,numberPoint/2)] + sortP[coord,floor(Int,numberPoint/2)+1])/2

    # 2 - Partition of pointset
    Pminus,Pplus = pointsetPartition(P, axis, off)

    if isempty(AFL)
        t = MakeFirstWallSimplex(P,α) #ToDo
        AFL = Faces(t) # d-1 - facce di t #ToDo
        push!(DT,t)
    end
    for f in AFL
        if Intersect(f,α) #return true (se interseca) or false #ToDo
            push!(AFL_α,f)
        elseif f in NegHalfspace(α) #ToDo
            push!(AFLminus,f)
        elseif f in PosHalfspace(α) #ToDo
            push!(AFLplus,f)
        end
    end
    while !isempty(AFL_α)
        f = popfirst!(AFL_α)
        t = MakeSimplex(f,P) # return nothing iff f is in ConvexHull #ToDo
        if t != nothing
            push!(upper_simplex,t)
            for ff in Faces(t)-f #ToDo
                    if Intersect(f,α)
                        Update(ff,AFL_α)
                    elseif ff in NegHalfspace(α)
                        Update(ff,AFLminus)
                    elseif ff in PosHalfspace(α)
                        Update(ff,AFLplus)
                    end
            end
        end
    end

    newaxis = circshift(axis,1)
    if !isempty(AFLminus)
        DT = union(DT,DeWall(Pminus,AFLminus,newaxis))
    end
    if !isempty(AFLplus)
        DT = union(DT,DeWall(Pplus,AFLplus,newaxis))
    end
    return DT
end
