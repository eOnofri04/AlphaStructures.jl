# α è un piano perpendicolare agli assi e che si sposta a metà del pointset,
# piano ortogonale ad ogni chiamata di dewall

function pointsetPartition(P, axis, off)
    coord = findall(x->x==1,axis)[1]
    Pminus = P[:,findall(x-> x < off,P[coord,:])]
    Pplus = P[:,findall(x-> x > off,P[coord,:])]
    return Pminus,Pplus
end

"""
The MakeFirstWallSimplex function selects the point p1 ∈ P nearest to the plane α. Then it selects a
second point p2 such that: (a) p2 is on the other side of α from p1 , and (b) p2 is the point in P with the
minimum Euclidean distance from p1 . Then, it seeks the point p3 at which the radius of the circum-circle
about 1-face (p1 , p2 ) and point p3 is minimized: the points (p1 , p2 , p3 ) are a 2-face of the DT(P). The
process continues in the same way until the required first d-simplex is built.
"""
function MakeFirstWallSimplex(P,axis,off)
    #migliorare un po' il codice
    coord = findall(x->x==1,axis)[1]
    Pminus,Pplus = pointsetPartition(P, axis, off)

    #The first point of the face is the nearest to middle plane in negative halfspace.
    #for point in Pminus
    maxcoord = max( Pminus[coord,:]...)
    index1 = findall(x->x==maxcoord,P[coord,:])[1]
    p1 = P[:,index1]

    #The 2nd point of the face is the euclidean nearest to first point that is in the positive halfspace
    #for point in Pplus
    distance = [Lar.norm(p1-Pplus[:,i]) for i = 1:size(Pplus,2)]
    minDist = min(filter(p-> !isnan(p) && p!=0,distance)...)
    ind2 = findall(x->x == minDist, distance)[1]
    p2 = Pplus[:, ind2]
    index2 = findall(x->x == [p2...], [P[:,i] for i =1:size(P,2)])[1]


    #The 3rd point is that with previous ones builds the smallest circle.
    #for point in P
    radius = [AlphaShape.foundAlpha([p1,p2,P[:,i]]) for i = 1:size(P,2)]
    minRad = min(filter(p-> !isnan(p) && p!=0,radius)...)
    index3 = findall(x->x == minRad, radius)[1]
    p3 = P[:, index3]
    @assert p3!=p2 && p3!=p1 "FirstTetra, Planar dataset, unable to build first tetrahedron."

    #The 4th point is that with previous ones builds the smallest sphere.
    #for point in P
    radiusSphere = [AlphaShape.foundAlpha([p1,p2,p3,P[:,i]]) for i = 1:size(P,2)]
    minRadSph = min(filter(p-> !isnan(p) && p!=0,radiusSphere)...)
    index4 = findall(x->x == minRadSph, radiusSphere)[1]
    p4 = P[:, index4]
    @assert p4!=p2 && p4!=p1 && p4!=p3 "FirstTetra, Planar dataset, unable to build first tetrahedron."

    return [index1,index2,index3,index4] #gli indici devono essere quelli in P
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
    AFL_α = []      # (d-1)faces intersected by plane α;
    AFLplus = []    # (d-1)faces completely contained in PosHalfspace(α);
    AFLminus = []   # (d-1)faces completely contained in NegHalfspace(α).
    DT = []

    # 1 - Select the splitting plane α; defined by axis and an origin point `off`
    coord = findall(x->x==1,axis)[1] #forse si può migliorare
    cols = sortperm(P[coord,:])
    sortP = P[:,cols]
    numberPoint = size(sortP,2)
    off = (sortP[coord,floor(Int,numberPoint/2)] + sortP[coord,floor(Int,numberPoint/2)+1])/2

    # 2 - construct Sα and the two subsets P− and P+ ;
    Pminus,Pplus = pointsetPartition(P, axis, off)

    if isempty(AFL)
        t = MakeFirstWallSimplex(P,axis,off) #ToDo
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
    while !isempty(AFL_α) #The Sα construction terminates when the AFL_α is empty
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
