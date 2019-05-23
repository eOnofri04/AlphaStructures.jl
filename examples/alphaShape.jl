using Plasm, Triangle
using LinearAlgebraicRepresentation, DataStructures
Lar = LinearAlgebraicRepresentation

"""
	pointsRand(V, EV, n)
"""
#crea punti random all'interno e sul bordo della figura
function pointsRand(V::Lar.Points, EV, n=10000)
	result = V
	classify = Lar.pointInPolygonClassification(V,EV)
	k = 1
	while k < n
		queryPoint = [rand();rand()]
		inOut = classify(queryPoint)

		if inOut=="p_in" || inOut=="p_on"
			result=hcat(result,queryPoint)
			k = k + 1;
		end
	end
	return result, EV
end

#aggiunge gli spigoli nella lista di vertici
function addEdge(EV, i, j)

        if [i, j] in EV || [j, i] in EV
            return EV
	end
	return push!(EV,[i,j])
end


#calcola l'alphaShape con input una nuvola di punti e il parametro alpha
function alphaShape(points::Lar.Points,EW,alpha=0.05)
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



#carico il file
filename = "/home/terry/Desktop/Alpha shape/Lar2.svg"
W,EW = Plasm.svg2lar(filename)
Plasm.view(Plasm.numbering(.2)((W,[[[k] for k=1:size(W,2)], EW])))

#costruisco i punti dentro la figura
points,EV = pointsRand(W,EW,10000);

#calcolo l'alphaShape
V,EV=alphaShape(points,EV,0.02)

Plasm.view((V,EV))
