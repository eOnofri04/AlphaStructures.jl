export pointsRand

"""
	pointsRand(V, EV, n, m)

Generate random points inside and otuside `(V, EV)`.

Given a Lar complex `(V, EV)`, this method evaluates and gives back:
 - `Vi` made of `n` internal random points;
 - `Ve` made of `m` external random points;
 - `EVi` made of `n` single point 0-cells;
 - `EVe` made of `m` single point 0-cells.

---

# Arguments
 - `V::Lar.Points`: The coordinates of points of the original complex;
 - `EV::Lar.Cells`: The 1-cells of the original complex;
 - `n::Int64`: the number of internal points (*By default* = 1000);
 - `m::Int64`: the number of external points (*By default* = 0);

---

# Examples
```jldoctest
julia> Vi, Ve, EVi, EVe = AlphaShape.pointsRand(V, EV, 1000, 1000);
```
"""
function pointsRand(V::Lar.Points, EV::Lar.Cells, n = 1000, m = 0)::Tuple{Lar.Points, Lar.Points, Lar.Cells, Lar.Cells}
	classify = Lar.pointInPolygonClassification(V, EV)
	p = size(V, 2)
	Vi = [0.0; 0.0]
	Ve = [0.0; 0.0]
	k1 = 0
	k2 = 0
	while k1 < n || k2 < m
		queryPoint = [rand();rand()]
		inOut = classify(queryPoint)

		if k1 < n && (inOut == "p_in")
			Vi = hcat(Vi, queryPoint)
			k1 = k1 + 1;
		end
		if k2 < m && inOut == "p_out"
			Ve = hcat(Ve, queryPoint)
			k2 = k2 + 1;
		end
	end
	EVi = [[i] for i = 1 : n]
	EVe = [[i] for i = 1 : m]
	return Vi[:, 2:end], Ve[:, 2:end], EVi, EVe
end


"""
	alphaShape(points, EW, alpha)

---

# Arguments
 - `V::Lar.Points`: The 0-cells of the original complex;
 - `EV::Lar.Cells`: The 1-cells of the original complex;
 - `n::Int64`: the number of new non-external points (*By default* = 1000);
 - `m::Int64`: the number of external points (*By default* = 0);

---

# Examples
```jldoctest
julia> Vi, Ve, EVi, EVe = AlphaShape.pointsRand(V, EV, 1000, 1000);
```
"""
function alphaShape(points::Lar.Points, EW::Lar.Cells, alpha=0.05)

	# The following function adds the edge betwen `i` and `j` if is not present.
	function addEdge(EV, i, j)

	        if [i, j] in EV || [j, i] in EV
	            return EV
		end
		return push!(EV,[i,j])
	end


	V = convert(Array{Float64,2},points')
	vertices = DataStructures.OrderedDict();

	#creazione del dizionario dei vertici
    	for id in 1:size(V,1)
       		vertices[id] =V[id,:]
        end

	@assert  size(V,1) > 3 #per usare la funzione di triangolazione devo avere almeno 4 punti

	points_map = Array{Int64,1}(collect(1:1:size(V)[1]))
	edges_list=vcat(EW'...)

	triangles = Triangle.constrained_triangulation(V,points_map,edges_list)
 	EV = Array{Int64,1}[]

	for k=1:size(triangles,1)
		#i tre punti del triangolo
		ia=triangles[k][1]
		ib=triangles[k][2]
		ic=triangles[k][3]

		#gli indici associati a tre punti del triangolo
		pa=vertices[ia]
		pb=vertices[ib]
		pc=vertices[ic]

		#calcolo del raggio della circonferenza circostritta
		a = sqrt((pa[1] - pb[1]) ^ 2 + (pa[2] - pb[2]) ^ 2)
		b = sqrt((pb[1] - pc[1]) ^ 2 + (pb[2] - pc[2]) ^ 2)
		c = sqrt((pc[1] - pa[1]) ^ 2 + (pc[2] - pa[2]) ^ 2)
		s = (a + b + c) / 2.0
		area = sqrt(s * (s - a) * (s - b) * (s - c))
		circum_r = a * b * c / (4.0 * area)

		if circum_r < alpha #alpha test
		    addEdge(EV, ia, ib)
		    addEdge(EV, ib, ic)
		    addEdge(EV, ic, ia)
		end
	end
	return convert(Lar.Points,V'),EV
end
