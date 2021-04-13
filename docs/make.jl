push!(LOAD_PATH,"../src/")
using Documenter, AlphaStructures

makedocs(
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true"
	),
	sitename = "AlphaStructures.jl",
	pages = [
		"1 - Home" => "index.md",
		"2 - Getting Started" => "gettingStarted.md",
		"Theory..." => [
			"3.0 - Theory Index" => "theory-index.md",
			"3.1 - Delaunay Triangulation" => "delaunay.md",
			"3.2 - Voronoi Diagrams" => "voronoi.md",
			"3.3 - Alpha Structures" => "alpha-structures.md",
		],
		"... and Practice" => [
			"4.0 - Module Introduction" => "this-module.md",
			"4.1 - DeWall Algorithm" => "delaunay-impl.md",
			"4.2 - Alpha Structures" => "alpha-structures-impl.md",
		],
		"A - About the Authors" => "authors.md",
		"B - Bibliography" => "bibliography.md"
	]
)

deploydocs(
    repo = "github.com/eOnofri04/AlphaStructures.jl.git",
)

# makedocs(
# 	format = :html,
# 	sitename = "AlphaStructures.jl",
# 	assets = ["assets/AlphaStructures.css", "assets/logo.png"],
# 	pages = [
# 		"1 - Home" => "index.md",
# 		"2 - Getting Started" => "gettingStarted.md",
# 		"Theory..." => [
# 			"3.0 - Theory Index" => "theory-index.md",
# 			"3.1 - Delaunay Triangulation" => "delaunay.md",
# 			"3.2 - Voronoi Diagrams" => "voronoi.md",
# 			"3.3 - Alpha Structures" => "alpha-structures.md",
# 			"3.4 - Persistent Homology" => "persistent-homology.md",
# 		],
# 		"... and Practice" => [
# 			"4.0 - Module Introduction" => "this-module.md",
# 			"4.1 - DeWall Algorithm" => "delaunay-impl.md",
# 			"4.2 - Alpha Structures" => "alpha-structures-impl.md",
# 			"4.3 - Persistent Homology" => "persistent-homology-impl.md",
# 		],
# 		"A - About the Authors" => "authors.md",
# 		"B - Bibliography" => "bibliography.md"
# 	]
# )
#

#
# makedocs(
#     modules = [AlphaStructures],
#     format = Documenter.HTML(
#         prettyurls = "deploy" in ARGS,
#     ),
#     sitename = "AlphaStructures.jl",
# 	pages = [
# 		"1 - Home" => "index.md",
# 		"2 - Getting Started" => "gettingStarted.md",
# 		"Theory..." => [
# 			"3.0 - Theory Index" => "theory-index.md",
# 			"3.1 - Delaunay Triangulation" => "delaunay.md",
# 			"3.2 - Voronoi Diagrams" => "voronoi.md",
# 			"3.3 - Alpha Structures" => "alpha-structures.md",
# 			"3.4 - Persistent Homology" => "persistent-homology.md",
# 		],
# 		"... and Practice" => [
# 			"4.0 - Module Introduction" => "this-module.md",
# 			"4.1 - DeWall Algorithm" => "delaunay-impl.md",
# 			"4.2 - Alpha Structures" => "alpha-structures-impl.md",
# 			"4.3 - Persistent Homology" => "persistent-homology-impl.md",
# 		],
# 		"A - About the Authors" => "authors.md",
# 		"B - Bibliography" => "bibliography.md"
# 	]
# )
#
# deploydocs(
#     repo = "github.com/eOnofri04/AlphaStructures.jl.git",
#     push_preview = true,
# )
