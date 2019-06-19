"""
	delaunayTriangulation(V::Lar.Points)

Return highest level simplices of Delaunay triangulation.
"""
function delaunayTriangulation(V::Lar.Points)
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
		# To Do
	end

	sort!.(upper_simplex)

	return sort(upper_simplex)
end

"""
	found_alpha(T::Array{Array{Float64,1},1})::Float64

Return the value of the circumball radius of the given points.
If three or more points are collinear it returns `Inf`.
"""
function found_alpha(T::Array{Array{Float64,1},1})::Float64
	@assert length(T) > 0 "ERROR: at least one points is needed."
	dim = length(T[1])
	@assert dim < 4 "Error: Function not yet Programmed."
	k = length(T) - 1
	@assert k <= dim +1 "ERROR: too much points."
	if dim == 1
		alpha = 0
	elseif dim == 2
        if k == 1
			alpha = Lar.norm(T[1]-T[2])/2.
		end
		if k == 2	#calcolo del raggio della circonferenza circostritta
			a = Lar.norm(T[1] - T[2])
			b = Lar.norm(T[2] - T[3])
			c = Lar.norm(T[3] - T[1])
			s = (a + b + c) / 2.
			area = sqrt(s * (s - a) * (s - b) * (s - c))
			alpha = a * b * c / (4. * area)
		end
	elseif dim == 3
		if k == 1
			alpha = Lar.norm(T[1]-T[2])/2.
		end
		if k == 2	#calcolo del raggio della circonferenza circostritta
			a = Lar.norm(T[1] - T[2])
			b = Lar.norm(T[2] - T[3])
			c = Lar.norm(T[3] - T[1])
			area = 1/2*Lar.norm(Lar.cross(T[2]-T[1],T[3]-T[1]))
			alpha = a * b * c / (4. * area)
		end
		if k == 3
			#radius of the circumsphere of a tetrahedron
			#https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
			num = Lar.norm(Lar.norm(T[4]-T[1])^2*Lar.cross(T[2]-T[1],T[3]-T[1])+
				Lar.norm(T[3]-T[1])^2*Lar.cross(T[4]-T[1],T[2]-T[1])+
				Lar.norm(T[2]-T[1])^2*Lar.cross(T[3]-T[1],T[4]-T[1]))
			M=[T[2]-T[1] T[3]-T[1] T[4]-T[1]]
			den = abs(2*Lar.det(M))
			alpha = num/den
		end
	end
	return alpha
end

"""
	vertex_in_circumball(T::Array{Array{Float64,1},1}, alpha_char::Float64, point::Array{Float64,2})

Determine if a point is inner of the circumball determined by `T` points and radius `alpha_char`.

"""
function vertex_in_circumball(T::Array{Array{Float64,1},1}, alpha_char::Float64, point::Array{Float64,2})::Bool
	@assert length(T) > 0 "ERROR: at least one points is needed."
	dim = length(T[1])
	@assert dim < 4 "Error: Function not yet Programmed."
	if dim == 1
		center = T[1]
	elseif dim == 2
		center = (T[1] + T[2])/2
	elseif dim == 3
		k = length(T)-1
		if k == 1
			center = (T[1] + T[2])/2
		end
		if k == 2
			#https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
			#circumcenter of a triangle in R^3
			num = Lar.norm(T[3]-T[1])^2*Lar.cross(Lar.cross(T[2]-T[1],T[3]-T[1]),T[2]-T[1])+
					Lar.norm(T[2]-T[1])^2*Lar.cross(T[3]-T[1],Lar.cross(T[2]-T[1],T[3]-T[1]))
			den = 2*Lar.norm(Lar.cross(T[2]-T[1],T[3]-T[1]))^2
			center = T[1] + num/den
		end

	end
	return Lar.norm(point - center) <= alpha_char
end

"""
	function contains(sup_simpl::Array{Int64,1}, simpl::Array{Int64,1})::Bool

Determine if a `d`-simplex is in a `d+1`-simplex.

"""
function contains(sup_simpl::Array{Int64,1}, simpl::Array{Int64,1})::Bool
	flag = true
	for point in simpl
		if (point ∉ sup_simpl)
			flag = false
		end
	end
	return flag
end

"""
	AlphaFilter(V::Lar.Points)

"""
function AlphaFilter(V::Lar.Points)

	dim = size(V, 1)

	# 1 - Delaunay triangulation of ``V``

	Cells = [[],[]] # ToDo Generalize definition
	Cells[dim] = delaunayTriangulation(V)

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

	# 2 - Evaluate Circumballs Radius

	alpha_char = [ zeros(length(Cells[i])) for i in 1 : dim ]
	for d = 1 : dim
		for i = 1 : length(Cells[d]) # simplex in Cells[d]
			simplex = Cells[d][i]
			T = [ V[:, v] for v in simplex ] #coordinate dei punti del simplesso
			alpha_char[d][i] = found_alpha(T);
		end
	end

	# 3 - Evaluate Charatteristical Alpha

	for d = dim-1 : -1 : 1
		for i = 1 : length(Cells[d])    # simplex in Cells[d]
			simplex = Cells[d][i]
			for j = 1 : length(Cells[d+1])  # up_simplex in Cells[d+1]
				up_simplex = Cells[d+1][j]
				if contains(up_simplex, simplex)
					point = V[:, setdiff(up_simplex, simplex)]
					T = [ V[:, v] for v in simplex ]
					if vertex_in_circumball(T, alpha_char[d][i], point)
						alpha_char[d][i] = alpha_char[d+1][j]
					end
				end
			end
		end
	end

	# 4 - Sorting Complex by Alpha
	dict = DataStructures.SortedMultiDict{Float64,Array{Int64,1}}()

	for d = 1:dim
	   	for i = 1:length(Cells[d])
	   		insert!(dict, alpha_char[d][i], Cells[d][i])
		end
	end

	orderedCollection = collect(dict)

	complex = Array{Int64,1}[]
	alpha_value = Float64[]

	for i = 1:length(orderedCollection)
		push!(alpha_value, orderedCollection[i][1])
		push!(complex, orderedCollection[i][2])
	end

	return complex, alpha_value
end
