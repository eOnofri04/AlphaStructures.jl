push!(LOAD_PATH,"../src/")

using Documenter, AlphaStructures

makedocs(
	format = :html,
	sitename = "AlphaStructures.jl",
	assets = ["assets/AlphaStructures.css", "assets/logo.png"],
	pages = [
		"1 - Home" => "index.md",
		"2 - Getting Started" => "gettingStarted.md",
		"Theory..." => [
			"3.0 - Theory Index" => "theory-index.md",
			"3.1 - Delaunay Triangulation" => "delaunay.md",
			"3.2 - Voronoy Diagrams" => "voronoy.md",
			"3.3 - Alpha Structures" => "alpha-structures.md",
			"3.4 - Persistent Homology" => "persistent-homology.md",
		],
		"... and Practice" => [
			"4.0 - Module Introduction" => "this-module.md",
			"4.1 - DeWall Algorithm" => "delaunay-impl.md",
			"4.2 - Alpha Structures" => "alpha-structures-impl.md",
			"4.3 - Persistent Homology" => "persistent-homology-impl.md",
		],
		"A - About the Authors" => "authors.md",
		"B - Bibliography" => "bibliography.md"
	]
)
