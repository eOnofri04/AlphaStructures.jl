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

filename = "examples/examples2D/model/lar_text.txt";
V = load_points(filename);

# view points
GL.VIEW([
	GL.GLPoints(permutedims(V))
])

# points by columns
filtration = AlphaStructures.alphaFilter(V);
VV,EV,FV = AlphaStructures.alphaSimplex(V, filtration, 0.01)

# View triangle
GL.VIEW([
	GL.GLGrid(V, FV, GL.COLORS[1], 0.8)
])
