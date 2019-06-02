module AlphaShape
	if VERSION >= VersionNumber("1.0.0")
		using Pkg
		Pkg.add(PackageSpec(url="https://github.com/cvdlab/LinearAlgebraicRepresentation.jl", rev="julia-1.0"))
	end
	using LinearAlgebraicRepresentation, Triangle
	Lar = LinearAlgebraicRepresentation

	export pointsRand

	include("2dAlphaShape.jl")
end
