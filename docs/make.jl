push!(LOAD_PATH,"../src/")

using Documenter, AlphaShape

makedocs(
	format = :html,
	sitename = "AlphaShape.jl",
	assets = ["assets/AlphaShape.css", "assets/logo.png"],
	pages = [
		"Home" => "index.md",
		"Getting Started" => "gettingStarted.md",
		"Authors" => "authors.md",
	]
)
