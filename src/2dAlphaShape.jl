export pointsRand

"""
	pointsRand(V, EV, n, m)

Generate random points inside and otuside `(V, EV)`.

Given a Lar complex `(V, EV)`, this method evaluates and gives back:
 - `Vi` made of `n` internal random points;
 - `Ve` made of `m` external random points;
 - `VVi` made of `n` single point 0-cells;
 - `VVe` made of `m` single point 0-cells.

---

# Arguments
 - `V::Lar.Points`: The coordinates of points of the original complex;
 - `EV::Lar.Cells`: The 1-cells of the original complex;
 - `n::Int64`: the number of internal points (*By default* = 1000);
 - `m::Int64`: the number of external points (*By default* = 0);

---

# Examples
```jldoctest
julia> Vi, Ve, VVi, VVe = AlphaShape.pointsRand(V, EV, 1000, 1000);
```
"""
function pointsRand(
		V::Lar.Points, EV::Lar.Cells, n = 1000, m = 0
	)::Tuple{Lar.Points, Lar.Points, Lar.Cells, Lar.Cells}
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
	VVi = [[i] for i = 1 : n]
	VVe = [[i] for i = 1 : m]
	return Vi[:, 2:end], Ve[:, 2:end], VVi, VVe
end
