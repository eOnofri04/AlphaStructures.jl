# α è un piano perpendicolare agli assi e che si sposta a metà del pointset,
# piano ortogonale ad ogni chiamata di dewall

function pointsetPartition(P,α)

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
function DeWall(P::Lar.Points,AFL::face_list,α::plane)::simplex_tassellation
    AFL_α = []
    AFLplus = []
    AFLminus = []
    DT = []
    Pminus,Pplus = pointsetPartition(P,α) #ToDo
    if isempty(AFL)
        t = MakeFirstWallSimplex(P,α)#ToDo
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
    if !isempty(AFLminus)
        DT = union(DT,DeWall(Pminus,AFLminus))
    end
    if !isempty(AFLplus)
        DT = union(DT,DeWall(Pplus,AFLplus))
    end
    return DT
end
