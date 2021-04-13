"""
	findCenter(P::Matrix)::Array{Float64,1}

Evaluates the circumcenter of the `P` points.

If the points lies on a `d-1` circumball then the function is not able
to perform the evaluation and therefore returns a `NaN` array.

# Examples

```jldoctest
julia> V = [
 0.0 1.0 0.0 0.0
 0.0 0.0 1.0 0.0
 0.0 0.0 0.0 1.0
];

julia> AlphaStructures.findCenter(V)
3-element Array{Float64,1}:
 0.5
 0.5
 0.5

```
"""
function findCenter(P::Matrix)::Array{Float64,1}
	dim, n = size(P)
	@assert n > 0		"findCenter: at least one points is needed."
	@assert dim >= n-1	"findCenter: Too much points"

	@assert dim < 4		"findCenter: Function not yet Programmed."

	if n == 1
		center = P[:, 1]

	elseif n == 2
		#for each dimension
		center = (P[:, 1] + P[:, 2]) / 2

	elseif n == 3
		#https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
		if dim == 2
			denom = 2 * LinearAlgebra.det([ P[:, 2] - P[:, 1]  P[:, 3] - P[:, 1] ])
			deter = (P[:, 2] - P[:, 1]) * LinearAlgebra.norm(P[:, 3] - P[:, 1])^2 -
					(P[:, 3] - P[:, 1]) * LinearAlgebra.norm(P[:, 2] - P[:, 1])^2
			numer = [- deter[2], deter[1]]
			center = P[:, 1] + numer / denom

		elseif dim == 3
			#circumcenter of a triangle in R^3
			numer = LinearAlgebra.norm(P[:, 3] - P[:, 1])^2 * LinearAlgebra.cross(
						LinearAlgebra.cross(P[:, 2] - P[:, 1], P[:, 3] - P[:, 1]),
						P[:, 2] - P[:, 1]
					) +
					LinearAlgebra.norm(P[:, 2] - P[:, 1])^2 * LinearAlgebra.cross(
				  		P[:, 3] - P[:, 1],
						LinearAlgebra.cross(P[:, 2] - P[:, 1], P[:, 3] - P[:, 1]
					)
			)
			denom = 2 * LinearAlgebra.norm(
				LinearAlgebra.cross(P[:, 2] - P[:, 1], P[:, 3] - P[:, 1])
			)^2
			center = P[:, 1] + numer / denom
		end

	elseif n == 4 #&& dim = 3
		# https://people.sc.fsu.edu/~jburkardt/presentations
		#	/cg_lab_tetrahedrons.pdf
		# page 6 (matrix are transposed)
		α = LinearAlgebra.det([P; ones(1, 4)])
		sq = sum(abs2, P, dims = 1)
		Dx = LinearAlgebra.det([sq; P[2:2,:]; P[3:3,:]; ones(1, 4)])
		Dy = LinearAlgebra.det([P[1:1,:]; sq; P[3:3,:]; ones(1, 4)])
		Dz = LinearAlgebra.det([P[1:1,:]; P[2:2,:]; sq; ones(1, 4)])
		center = [Dx; Dy; Dz]/2α
	end

	return center
#	AlphaStructures.foundCenter([P[:,i] for i = 1 : size(P, 2)])[:,:]
end

"""
	findRadius(
		P::Matrix, center=false; digits=64
	)::Union{Float64, Tuple{Float64, Array{Float64,1}}}

Returns the value of the circumball radius of the given points.
If the function findCenter is not able to determine the circumcenter
than the function returns `Inf`.

If the optional argument `center` is set to `true` than the function
returns also the circumcenter cartesian coordinates.

_Obs._ Due to numerical approximation errors, the radius is choosen
as the smallest distance between a point in `P` and the center.
"""
function findRadius(
		P::Matrix, center=false; digits=64
	)::Union{Float64, Tuple{Float64, Array{Float64,1}}}

 	c = AlphaStructures.findCenter(P)
	if any(isnan, c)
		r = Inf
	else
		r = round(
			findmin([LinearAlgebra.norm(c - P[:, i]) for i = 1 : size(P, 2)])[1],
			digits = digits
		)
	end
	if center
		return r, c
	end
	return r
end

"""
	matrixPerturbation(
		M::Array{Float64,2};
		atol = 1e-10,
		row = [0],
		col = [0]
	)::Array{Float64,2}

Returns the matrix `M` with a ±`atol` perturbation on each value determined
by the `row`-th rows and `col`-th columns.
If `row` / `col` are set to `[0]` (or not specified) then all the
rows / columns are perturbated.
"""
function matrixPerturbation(
		M::Array{Float64,2};
		atol=1e-10, row = [0], col = [0]
	)::Array{Float64,2}

	if atol == 0.0
		println("Warning: no perturbation has been performed.")
		return M
	end

	if row == [0]
		row = [i for i = 1 : size(M, 1)]
	end
	if col == [0]
		col = [i for i = 1 : size(M, 2)]
	end

	N = copy(M)
	perturbation = mod.(rand(Float64, length(row), length(col)), 2*atol).-atol
	N[row, col] = M[row, col] + perturbation
	return N
end

"""
	simplexFaces(σ::Array{Int64,1})::Array{Array{Int64,1},1}

Returns the faces of the simplex `σ`.

_Obs._ The faces are ordered by the index value.
"""
function simplexFaces(σ::Array{Int64,1})::Array{Array{Int64,1},1}
    sort!(sort!.(collect(Combinatorics.combinations(σ, length(σ)-1))))
end

"""
	vertexInCircumball(
		P::Matrix,
		α_char::Float64,
		point::Array{Float64,2}
	)::Bool

Determine if a point is inner of the circumball determined by `P` points
and radius `α_char`.

"""
function vertexInCircumball(
		P::Matrix,
		α_char::Float64,
		point::Array{Float64,2}
	)::Bool

	center = AlphaStructures.findCenter(P)
	return LinearAlgebra.norm(point - center) <= α_char
end

"""
	apply_matrix(affineMatrix::Matrix, V::Matrix) -> Matrix

Apply affine transformation `affineMatrix` to points `V`.
"""
function apply_matrix(affineMatrix::Matrix, V::Matrix)
	m,n = size(V)
	W = [V; fill(1.0, (1,n))]
	T = (affineMatrix * W)[1:m,1:n]
	return T
end

function apply_matrix(affineMatrix, V::Array{Float64,1})
	T = reshape(V,3,1)
	return apply_matrix(affineMatrix, T)
end

"""
	traslation(args...) -> Matrix

Return an *affine transformation Matrix* in homogeneous coordinates.
Such `translation` Matrix has ``d+1`` rows and ``d+1`` columns,
where ``d`` is the number of translation parameters in the `args` array.

"""
function traslation(args...)
	d = length(args)
	mat = Matrix{Float64}(LinearAlgebra.I, d+1, d+1)
	for k in range(1, length=d)
			mat[k,d+1]=args[k]
	end
	return mat
end
