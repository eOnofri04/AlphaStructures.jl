export pointsRand

"""
	pointsRand(V, EV, n, m)

Generate random points inside and otuside `(V, EV)`.

Given a Lar complex `(V, EV)`, this method evaluates and gives back:
 - `V` adjoint with `n` non-external random points;
 - `W` made of `m` external random points;
 - `EV` adjoint with single point cells;
 - `EW` made of `m` single point 1-cells.

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
function pointsRand(V::Lar.Points, EV::Lar.Cells, n = 1000, m = 0)::Tuple{Lar.Points, Lar.Points, Lar.Cells, Lar.Cells}
	classify = Lar.pointInPolygonClassification(V, EV)
	p = size(V, 2)
	W = [0.0; 0.0]
	k1 = 0
	k2 = 0
	while k1 < n || k2 < m
		queryPoint = [rand();rand()]
		inOut = classify(queryPoint)

		if k1 < n && (inOut == "p_in" || inOut == "p_on")
			V = hcat(V, queryPoint)
			k1 = k1 + 1;
		end
		if k2 < m && inOut == "p_out"
			W = hcat(W, queryPoint)
			k2 = k2 + 1;
		end
	end
	EV = vcat(EV, [[i] for i = p : p+n])
	EW = [[i] for i = 1 : m]
	return V, W[:, 2:end], EV, EW
end
