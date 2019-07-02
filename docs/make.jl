push!(LOAD_PATH,"../src/")

using Documenter, AlphaShape

makedocs(
	format = :html,
	sitename = "AlphaShape.jl",
	assets = ["assets/AlphaShape.css", "assets/logo.png"],
	pages = [
		"Home" => "index.md",
		"Getting Started" => "gettingStarted.md",
		"Theory..." => [
			"Delaunay Triangulation" => "delaunay.md",
			"Voronoy Diagrams" => "voronoy.md",
			"Alpha Structures" => "alpha-structures.md",
			"Persistent Homology" => "persistent-homology.md"
		],
		"... and Practice" => [
			"Module Introduction" => "this-module.md"
		],
		"About the Authors" => "authors.md",
	]
)
