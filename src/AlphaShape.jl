module AlphaShape
	using LinearAlgebraicRepresentation, Triangle, Combinatorics
	Lar = LinearAlgebraicRepresentation

	export pointsRand

	include("2dAlphaShape.jl")
	include("alpha_complex.jl")
end
