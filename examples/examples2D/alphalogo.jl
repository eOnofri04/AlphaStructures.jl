using AlphaStructures
using LinearAlgebraicRepresentation,DataStructures
Lar = LinearAlgebraicRepresentation
using ViewerGL
GL = ViewerGL
using PointClouds

function pointsRand(
		V::Lar.Points, EV::Lar.Cells, n = 1000, m = 0
	)::Tuple{Lar.Points, Lar.Points, Lar.Cells, Lar.Cells}
	classify = Lar.pointInPolygonClassification(V, EV)
	Vi = [0;0]
	Ve = [0;0]
	k1 = 0
	k2 = 0
	while k1 < n || k2 < m
		queryPoint = [rand();rand()]
		inOut = classify(queryPoint)

		if k1 < n && inOut == "p_in"
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
	return Vi[:,2:end], Ve[:,2:end], VVi, VVe
end

function pointsRandPoisson(d,
		V::Lar.Points, EV::Lar.Cells, n = 1000
	)::Lar.Points
	classify = Lar.pointInPolygonClassification(V, EV)
	Vi = [0;0]
	k1 = 0
	while k1 < n
		queryPoint = [rand();rand()]
		inOut = classify(queryPoint)
		flag = true
		if k1 < n && inOut == "p_in"
			for i in 2:size(Vi,2)
				if Lar.norm(queryPoint-Vi[:,i])<=d
					flag = false
					break
				end
			end
			if flag
				Vi = hcat(Vi, queryPoint)
				k1 = k1 + 1;
			end
		end
	end
	return Vi[:,2:end]
end

include("./svg_files/logoLines.jl")

V,EV = Lar.lines2lar(convert(Array{Float64,2},lines'))
V = Lar.normalize(V)
#Vi,Ve,VVi,VVe = pointsRand(V,EV,1000,0)

Vi = pointsRandPoisson(0.001, V, EV, 5000)

DT= PointClouds.delaunayMATLAB(Vi)
filtration = AlphaStructures.alphaFilter(Vi,DT);
α = 0.05
VV,EV,FV = AlphaStructures.alphaSimplex(Vi,filtration,α)


GL.VIEW(
	[
		GL.GLGrid(Vi,FV,GL.COLORS[2],0.7)
		GL.GLPoints(convert(Lar.Points,Vi'),GL.COLORS[6])
		#GL.GLGrid(Vi,EV,GL.COLORS[3],0.7)
	]
);



points = [[p] for p in VV]
faces = [[f] for f in FV]
edges = [[e] for e in EV]
GL.VIEW( GL.GLExplode(Vi, [edges; faces], 1., 1., 1., 99, 1) );
GL.VIEW([
    GL.GLLines(Vi,EV)
	GL.GLFrame2
]);
