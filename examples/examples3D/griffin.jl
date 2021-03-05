using AlphaStructures
using ViewerGL
GL =  ViewerGL

"""
Return points from file.
"""
function load_points(filename::String)::Matrix
    io = open(filename, "r")
    point = readlines(io)
    close(io)

    b = [tryparse.(Float64,split(point[i], " ")) for i in 1:length(point)]
    V = hcat(b...)
    return V
end

V = load_points("examples/examples3D/model/griffin.txt")

# view points
GL.VIEW([
	GL.GLPoints(permutedims(V))
])

filtration = AlphaStructures.alphaFilter(V);
VV, EV, FV, TV = AlphaStructures.alphaSimplex(V, filtration, 0.35)

#view all simplices
GL.VIEW(
	[
		GL.GLGrid(V, EV, GL.COLORS[1], 0.6) # White
		GL.GLGrid(V, FV, GL.COLORS[2], 0.8) # Red
		GL.GLGrid(V, TV, GL.COLORS[3], 0.6) # Green
	]
);
