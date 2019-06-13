

function AlphaFilter(V::Lar.Points)

    function contains(sup_simpl::Array{Int64,1}, simpl::Array{Int64,1})::Bool
        flag = true
        for point in simpl
            if (point ∉ sup_simpl)
                flag = false
            end
        end
        return flag
    end

    dim = size(V, 1)
    # 1 - Delaunay triangulation of ``V``

    D = delaunayTriangulation(V, dim)

    Cells = [[],[],[]]; # ToDo
    for simplex in D
        push!(Cells[length(simplex)-1], simplex)
    end

    # 2 - Evaluate Circumballs Radius

    for d = 1 : dim
        for i = 1 : length(Cells[d])    # simplex in Cells[d]
            T = ...
            alpha_char[i] = found_alpha(T); # To Do
        end
    end

    # 3 - Evaluate Charatteristical Alpha

    for d = dim-1 : -1 : 1
        for i = 1 : length(Cells[d])    # simplex in Cells[d]
            simplex = Cells[d][i]
            for j = 1 : length(Cells[d+1])  # up_simplex in Cells[d+1]
                up_simplex = Cells[d+1][j]
                if contains(up_simplex, simplex)
                    point = V[diff(up_simplex, simplex)] # ToDo
                    T = ... # ToDo
                    if vertex_in_circumball(T, alpha_char[d][i], point) # ToDo
                        alpha_char[d][i] = alpha_char[d+1][j]
                    end
                end
            end
        end
    end

    # 4 - Sorting Complex by Alpha

    # ToDo

end
