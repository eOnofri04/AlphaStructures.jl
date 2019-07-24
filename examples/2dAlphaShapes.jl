using AlphaStructures
using LinearAlgebraicRepresentation, ViewerGL
Lar = LinearAlgebraicRepresentation
GL =  ViewerGL

"""
	pointsRand(V, EV, n, m)

Generate random points inside and otuside `(V, EV)`.

Given a Lar complex `(V, EV)`, this method evaluates and gives back:
 - `Vi` made of `n` internal random points;
 - `Ve` made of `m` external random points;
 - `VVi` made of `n` single point 0-cells;
 - `VVe` made of `m` single point 0-cells.

---

# Arguments
 - `V::Lar.Points`: The coordinates of points of the original complex;
 - `EV::Lar.Cells`: The 1-cells of the original complex;
 - `n::Int64`: the number of internal points (*By default* = 1000);
 - `m::Int64`: the number of external points (*By default* = 0);

"""
function pointsRand(
		V::Lar.Points, EV::Lar.Cells, n = 1000, m = 0
	)::Tuple{Lar.Points, Lar.Points, Lar.Cells, Lar.Cells}
	classify = Lar.pointInPolygonClassification(V, EV)
	Vi = [0;0]
	Ve = [0;0]
	k1 = 0
	k2 = 0
	while k1 < n || k2 < m
		queryPoint = [rand();rand()]
		inOut = classify(queryPoint)

		if k1 < n && inOut == "p_in"
			Vi = hcat(Vi, queryPoint)
			k1 = k1 + 1;
		end
		if k2 < m && inOut == "p_out"
			Ve = hcat(Ve, queryPoint)
			k2 = k2 + 1;
		end
	end
	VVi = [[i] for i = 1 : n]
	VVe = [[i] for i = 1 : m]
	return Vi[:,2:end], Ve[:,2:end], VVi, VVe
end


#filename = "examples/svg_files/Lar2.svg";
#V,EV = Plasm.svg2lar(filename);

V = [0.0118152 0.0 0.0 0.0485141 0.0485141 0.0378625 0.0902256 0.0785893 0.0785893 0.127103 0.127103 0.115736 0.185374 0.185374 0.231293 0.231293 0.402256 0.402256 0.615557 0.610825 0.606135 0.601487 0.596877 0.592307 0.587774 0.583277 0.578817 0.57439 0.569996 0.565563 0.561071 0.556519 0.551908 0.547239 0.54251 0.537722 0.532875 0.527969 0.523004 0.5149 0.507181 0.499849 0.492902 0.486338 0.480159 0.474364 0.468952 0.463921 0.459273 0.455041 0.451259 0.447926 0.44504 0.442602 0.44061 0.439061 0.437957 0.437295 0.437075 0.437158 0.437408 0.437824 0.438407 0.439156 0.440072 0.441154 0.442402 0.443818 0.445399 0.447142 0.448987 0.450934 0.452982 0.455133 0.457386 0.459741 0.462198 0.464757 0.467419 0.47019 0.473026 0.475928 0.478895 0.48193 0.485032 0.488201 0.491438 0.494745 0.49812 0.500747 0.50363 0.506772 0.510172 0.513829 0.517744 0.521917 0.526348 0.531037 0.535983 0.546023 0.555521 0.564476 0.572889 0.58076 0.588088 0.594874 0.601117 0.606818 0.611976 0.612027 0.612073 0.612113 0.612148 0.612178 0.612202 0.612221 0.612234 0.612242 0.612245 0.612124 0.611762 0.611157 0.610311 0.609224 0.607895 0.606324 0.604511 0.602457 0.600161 0.596727 0.592976 0.58891 0.584527 0.579832 0.574821 0.569496 0.563859 0.557909 0.551647 0.545788 0.540242 0.535008 0.53009 0.525488 0.521202 0.517235 0.513586 0.510258 0.50725 0.504452 0.501805 0.499307 0.49696 0.494764 0.492718 0.490822 0.489076 0.487481 0.486037 0.444415 0.445615 0.446961 0.448453 0.450091 0.451878 0.453811 0.455892 0.458123 0.460503 0.463033 0.465755 0.468713 0.471906 0.47533 0.478988 0.482876 0.486993 0.491341 0.495915 0.500716 0.505711 0.510865 0.516179 0.52165 0.527278 0.533062 0.539 0.545093 0.551337 0.557734 0.564057 0.57014 0.57598 0.581579 0.586936 0.592052 0.596925 0.601557 0.605948 0.610097 0.614017 0.617724 0.621216 0.624495 0.627562 0.630417 0.633059 0.635491 0.637713 0.639724 0.641548 0.643259 0.644859 0.646346 0.647725 0.648992 0.650149 0.651199 0.652139 0.652972 0.653377 0.653736 0.654048 0.654315 0.654538 0.654718 0.654857 0.654953 0.655012 0.65503 0.65503 0.655057 0.655139 0.655275 0.655465 0.655713 0.656017 0.656377 0.656795 0.657271 0.657805 0.658396 0.659094 0.6599 0.660813 0.661833 0.662961 0.664196 0.665539 0.666989 0.668546 0.62406 0.622769 0.621577 0.620487 0.619494 0.6186 0.617803 0.6171 0.616493 0.615978 0.611976 0.6071 0.601761 0.595959 0.589694 0.582965 0.57577 0.568111 0.559987 0.551395 0.542338 0.537252 0.532469 0.527987 0.52381 0.519938 0.516372 0.513114 0.510163 0.507522 0.505192 0.503065 0.501036 0.499104 0.49727 0.495535 0.493901 0.492365 0.49093 0.489596 0.488364 0.487241 0.486237 0.485351 0.484583 0.483933 0.483401 0.482988 0.482692 0.482515 0.482456 0.482585 0.482972 0.483616 0.484518 0.485678 0.487096 0.488772 0.490705 0.492897 0.495346 0.498044 0.500984 0.504164 0.507585 0.511245 0.515143 0.519281 0.523656 0.528269 0.533119 0.538003 0.542776 0.547436 0.551985 0.556425 0.560754 0.564972 0.569083 0.573084 0.576978 0.580692 0.584206 0.587521 0.590636 0.593548 0.59626 0.598771 0.601079 0.603183 0.605084 0.606408 0.607589 0.608625 0.609521 0.610276 0.610891 0.611368 0.611706 0.611909 0.611976 0.720641 0.720641 0.758951 0.758951 0.761881 0.764762 0.767595 0.77038 0.773116 0.775804 0.778443 0.781035 0.783578 0.786072 0.788594 0.791164 0.793782 0.796448 0.799163 0.801926 0.804738 0.807598 0.810506 0.813462 0.817767 0.822087 0.826424 0.830777 0.835146 0.839531 0.843932 0.848349 0.852783 0.857232 0.842553 0.839435 0.836314 0.833188 0.830062 0.826933 0.823805 0.820678 0.817553 0.814432 0.811314 0.808551 0.805846 0.803199 0.80061 0.798077 0.795601 0.793182 0.790817 0.788507 0.786251 0.784087 0.782051 0.780142 0.778362 0.776708 0.775179 0.773777 0.7725 0.771347 0.770319 0.768968 0.767761 0.766699 0.765781 0.765004 0.76437 0.763878 0.763528 0.763317 0.763247 0.763247 0.884712 0.872897 0.872897 0.921411 0.921411 0.910759 0.963033 0.951486 0.951486 1.0 1.0 0.988632; 0.22986 0.295918 0.352757 0.352757 0.295918 0.22986 0.22986 0.295918 0.352757 0.352757 0.295918 0.22986 0.0056391 0.352757 0.352757 0.0466344 0.0466344 0.0056391 0.0366989 0.0327891 0.0291165 0.0256812 0.022483 0.0195238 0.0168045 0.0143233 0.0120829 0.0100832 0.00832438 0.00674275 0.0053276 0.00407895 0.00299678 0.0020811 0.0013319 0.00074919 0.00033298 8.324e-5 0.0 0.0002014 0.00080648 0.00181525 0.00322771 0.00504654 0.00726996 0.00989885 0.012935 0.0163784 0.0202291 0.024394 0.0287809 0.0333888 0.0382214 0.0432778 0.0485598 0.0540691 0.0598049 0.0657707 0.0719656 0.0756149 0.0792043 0.0827336 0.086203 0.0896097 0.0929556 0.0962397 0.0994603 0.102617 0.105711 0.10871 0.111587 0.114341 0.116973 0.119484 0.121874 0.124143 0.126293 0.128324 0.130236 0.132019 0.133716 0.135328 0.136853 0.138292 0.139646 0.140913 0.142095 0.14319 0.1442 0.144844 0.145488 0.14613 0.146772 0.147411 0.148047 0.148681 0.14931 0.149935 0.150555 0.151812 0.153113 0.154458 0.155851 0.157291 0.158778 0.160316 0.161903 0.163543 0.165235 0.166918 0.168477 0.16991 0.171216 0.172395 0.173445 0.174364 0.175154 0.17581 0.176334 0.18139 0.186139 0.190582 0.194717 0.198543 0.202061 0.205269 0.208168 0.210755 0.213033 0.215788 0.218253 0.220428 0.222313 0.223908 0.225213 0.226228 0.226953 0.227388 0.227533 0.227426 0.227105 0.226571 0.225826 0.22487 0.223705 0.222332 0.22075 0.218963 0.216971 0.214691 0.212093 0.209174 0.205934 0.20237 0.198481 0.194266 0.189723 0.18485 0.179646 0.185374 0.190616 0.195653 0.200484 0.205111 0.209531 0.213743 0.21775 0.221548 0.225137 0.228518 0.231743 0.234813 0.237728 0.240489 0.243097 0.245551 0.247853 0.250003 0.252001 0.253849 0.255557 0.257083 0.258427 0.25959 0.260573 0.261377 0.262 0.262445 0.262711 0.2628 0.262722 0.26249 0.262103 0.261566 0.260875 0.260035 0.259046 0.257907 0.256623 0.255192 0.253648 0.252023 0.250318 0.248532 0.246666 0.244719 0.242692 0.240584 0.238395 0.236126 0.233782 0.231314 0.228723 0.226008 0.22317 0.220208 0.217122 0.213913 0.210581 0.207125 0.204775 0.202076 0.199026 0.195627 0.191874 0.187771 0.183316 0.178508 0.173346 0.16783 0.110992 0.0995578 0.0889948 0.0793027 0.0704816 0.0625331 0.0554583 0.0492553 0.0439268 0.0394728 0.0358933 0.0327408 0.0296187 0.0265279 0.0234649 0.0204305 0.017423 0.0144406 0.0114841 0.00854995 0.0056391 0.0056391 0.00834318 0.0111377 0.0140226 0.0169978 0.0200609 0.0232134 0.0264545 0.0297825 0.0331973 0.131847 0.129995 0.128195 0.12645 0.124758 0.12312 0.121536 0.120005 0.118528 0.117105 0.115736 0.114973 0.11419 0.113386 0.112562 0.111719 0.110857 0.109977 0.109079 0.108164 0.107232 0.106247 0.105171 0.104005 0.102748 0.101404 0.0999696 0.098447 0.0968376 0.0951414 0.0933584 0.0915136 0.0896303 0.0877086 0.0857483 0.0837469 0.0817061 0.079625 0.0775018 0.0753366 0.0731293 0.0697753 0.0665351 0.0634085 0.0603956 0.0574991 0.0547171 0.0520507 0.0495014 0.0470695 0.0447547 0.0425877 0.0406507 0.0389438 0.0374669 0.0362173 0.0351969 0.0344048 0.0338391 0.0334998 0.033387 0.0334945 0.0338167 0.0343537 0.0351056 0.0360723 0.0372538 0.0386502 0.0402614 0.0420874 0.0441282 0.046357 0.0487469 0.0512979 0.05401 0.0568833 0.0599177 0.0631131 0.0664697 0.0699875 0.0736663 0.0766792 0.0799705 0.0835401 0.0873881 0.0915127 0.095913 0.100591 0.105543 0.110771 0.116273 0.0056391 0.257071 0.257071 0.21894 0.224125 0.228941 0.233387 0.237463 0.241173 0.244513 0.247486 0.250092 0.252333 0.254207 0.25584 0.2573 0.258589 0.259706 0.260652 0.261425 0.262026 0.262456 0.262714 0.2628 0.262663 0.262251 0.261565 0.260603 0.259364 0.25785 0.256059 0.253989 0.251642 0.249015 0.209542 0.211279 0.212837 0.214218 0.215416 0.216434 0.217269 0.21792 0.218387 0.218667 0.218761 0.218675 0.218419 0.217992 0.217398 0.216635 0.215706 0.214612 0.213353 0.211932 0.210347 0.208591 0.206706 0.204692 0.202549 0.200277 0.197877 0.195347 0.192689 0.189902 0.186985 0.182404 0.177737 0.172984 0.168145 0.163221 0.15821 0.153113 0.147931 0.142662 0.137308 0.0056391 0.22986 0.295918 0.352757 0.352757 0.295918 0.22986 0.22986 0.295918 0.352757 0.352757 0.295918 0.22986];
EV = Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 1], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 7], [13, 14], [14, 15], [15, 16], [16, 17], [17, 18], [18, 13], [19, 20], [20, 21], [21, 22], [22, 23], [23, 24], [24, 25], [25, 26], [26, 27], [27, 28], [28, 29], [29, 30], [30, 31], [31, 32], [32, 33], [33, 34], [34, 35], [35, 36], [36, 37], [37, 38], [38, 39], [39, 40], [40, 41], [41, 42], [42, 43], [43, 44], [44, 45], [45, 46], [46, 47], [47, 48], [48, 49], [49, 50], [50, 51], [51, 52], [52, 53], [53, 54], [54, 55], [55, 56], [56, 57], [57, 58], [58, 59], [59, 60], [60, 61], [61, 62], [62, 63], [63, 64], [64, 65], [65, 66], [66, 67], [67, 68], [68, 69], [69, 70], [70, 71], [71, 72], [72, 73], [73, 74], [74, 75], [75, 76], [76, 77], [77, 78], [78, 79], [79, 80], [80, 81], [81, 82], [82, 83], [83, 84], [84, 85], [85, 86], [86, 87], [87, 88], [88, 89], [89, 90], [90, 91], [91, 92], [92, 93], [93, 94], [94, 95], [95, 96], [96, 97], [97, 98], [98, 99], [99, 100], [100, 101], [101, 102], [102, 103], [103, 104], [104, 105], [105, 106], [106, 107], [107, 108], [108, 109], [109, 110], [110, 111], [111, 112], [112, 113], [113, 114], [114, 115], [115, 116], [116, 117], [117, 118], [118, 119], [119, 120], [120, 121], [121, 122], [122, 123], [123, 124], [124, 125], [125, 126], [126, 127], [127, 128], [128, 129], [129, 130], [130, 131], [131, 132], [132, 133], [133, 134], [134, 135], [135, 136], [136, 137], [137, 138], [138, 139], [139, 140], [140, 141], [141, 142], [142, 143], [143, 144], [144, 145], [145, 146], [146, 147], [147, 148], [148, 149], [149, 150], [150, 151], [151, 152], [152, 153], [153, 154], [154, 155], [155, 156], [156, 157], [157, 158], [158, 159], [159, 160], [160, 161], [161, 162], [162, 163], [163, 164], [164, 165], [165, 166], [166, 167], [167, 168], [168, 169], [169, 170], [170, 171], [171, 172], [172, 173], [173, 174], [174, 175], [175, 176], [176, 177], [177, 178], [178, 179], [179, 180], [180, 181], [181, 182], [182, 183], [183, 184], [184, 185], [185, 186], [186, 187], [187, 188], [188, 189], [189, 190], [190, 191], [191, 192], [192, 193], [193, 194], [194, 195], [195, 196], [196, 197], [197, 198], [198, 199], [199, 200], [200, 201], [201, 202], [202, 203], [203, 204], [204, 205], [205, 206], [206, 207], [207, 208], [208, 209], [209, 210], [210, 211], [211, 212], [212, 213], [213, 214], [214, 215], [215, 216], [216, 217], [217, 218], [218, 219], [219, 220], [220, 221], [221, 222], [222, 223], [223, 224], [224, 225], [225, 226], [226, 227], [227, 228], [228, 229], [229, 230], [230, 231], [231, 232], [232, 233], [233, 234], [234, 235], [235, 236], [236, 237], [237, 238], [238, 239], [239, 240], [240, 241], [241, 242], [242, 243], [243, 244], [244, 245], [245, 246], [246, 247], [247, 248], [248, 249], [249, 250], [250, 251], [251, 252], [252, 253], [253, 254], [254, 255], [255, 256], [256, 257], [257, 258], [258, 259], [259, 260], [260, 261], [261, 19], [262, 263], [263, 264], [264, 265], [265, 266], [266, 267], [267, 268], [268, 269], [269, 270], [270, 271], [271, 272], [272, 273], [273, 274], [274, 275], [275, 276], [276, 277], [277, 278], [278, 279], [279, 280], [280, 281], [281, 282], [282, 283], [283, 284], [284, 285], [285, 286], [286, 287], [287, 288], [288, 289], [289, 290], [290, 291], [291, 292], [292, 293], [293, 294], [294, 295], [295, 296], [296, 297], [297, 298], [298, 299], [299, 300], [300, 301], [301, 302], [302, 303], [303, 304], [304, 305], [305, 306], [306, 307], [307, 308], [308, 309], [309, 310], [310, 311], [311, 312], [312, 313], [313, 314], [314, 315], [315, 316], [316, 317], [317, 318], [318, 319], [319, 320], [320, 321], [321, 322], [322, 323], [323, 324], [324, 325], [325, 326], [326, 327], [327, 328], [328, 329], [329, 330], [330, 331], [331, 332], [332, 333], [333, 334], [334, 335], [335, 336], [336, 337], [337, 338], [338, 339], [339, 340], [340, 341], [341, 342], [342, 343], [343, 344], [344, 345], [345, 346], [346, 347], [347, 348], [348, 349], [349, 350], [350, 351], [351, 352], [352, 262], [353, 354], [354, 355], [355, 356], [356, 357], [357, 358], [358, 359], [359, 360], [360, 361], [361, 362], [362, 363], [363, 364], [364, 365], [365, 366], [366, 367], [367, 368], [368, 369], [369, 370], [370, 371], [371, 372], [372, 373], [373, 374], [374, 375], [375, 376], [376, 377], [377, 378], [378, 379], [379, 380], [380, 381], [381, 382], [382, 383], [383, 384], [384, 385], [385, 386], [386, 387], [387, 388], [388, 389], [389, 390], [390, 391], [391, 392], [392, 393], [393, 394], [394, 395], [395, 396], [396, 397], [397, 398], [398, 399], [399, 400], [400, 401], [401, 402], [402, 403], [403, 404], [404, 405], [405, 406], [406, 407], [407, 408], [408, 409], [409, 410], [410, 411], [411, 412], [412, 413], [413, 414], [414, 415], [415, 416], [416, 417], [417, 418], [418, 419], [419, 420], [420, 421], [421, 422], [422, 423], [423, 424], [424, 425], [425, 426], [426, 427], [427, 428], [428, 353], [429, 430], [430, 431], [431, 432], [432, 433], [433, 434], [434, 429], [435, 436], [436, 437], [437, 438], [438, 439], [439, 440], [440, 435]]

Vi, Ve, VVi, VVe = pointsRand(V, EV, 1000, 10000);

GL.VIEW([
	GL.GLGrid(Vi, VVi, GL.COLORS[1], 1)
	GL.GLGrid(Ve, VVe, GL.COLORS[12], 1)
])

filtration = AlphaStructures.alphaFilter(Vi);
VV,EV,FV = AlphaStructures.alphaSimplex(Vi, filtration, 0.02)

points = [[p] for p in VV]
faces = [[f] for f in FV]
edges = [[e] for e in EV]
GL.VIEW( GL.GLExplode(Vi, [edges; faces], 1.5, 1.5, 1.5, 99, 1) )

filter_key = unique(keys(filtration))

granular = 15

reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]
reduced_filter = [reduced_filter; 1.]

#
# Arlecchino's Lar
#

for α in reduced_filter
	VV,EV,FV = AlphaStructures.alphaSimplex(Vi, filtration, α)
	GL.VIEW(
		GL.GLExplode(
			Vi,
			[[[f] for f in FV]; [[e] for e in EV]],
			1., 1., 1.,	# Explode Ratio
			99, 1		# Colors
		)
	)
end

for i = 1000 : 150 : length(filter_key)
	VV,EV,FV = AlphaStructures.alphaSimplex(Vi, filtration, filter_key[i])
	GL.VIEW(
		GL.GLExplode(
			Vi,
			[[[f] for f in FV]; [[e] for e in EV]],
			1., 1., 1.,	# Explode Ratio
			99, 1		# Colors
		)
	)
end


#
# Appearing Colors
#

reduced_filter = [
	0.001;	0.002;	0.003;	0.004;	0.005
	0.006;	0.007;	0.008;	0.009;	0.010
	0.013;	0.015;	0.020;	0.050;	1.000
]

for i = 2 : length(reduced_filter)
	VV0, EV0, FV0 = AlphaStructures.alphaSimplex(VS, filtration, reduced_filter[i-1])
	VV,  EV,  FV  = AlphaStructures.alphaSimplex(VS, filtration, reduced_filter[i])
	EV0mesh = GL.GLGrid(Vi, EV0)
	FV0mesh = GL.GLGrid(Vi, FV0)
	EVmesh = GL.GLGrid(Vi, setdiff(EV, EV0), GL.COLORS[2], 1)
	FVmesh = GL.GLGrid(Vi, setdiff(FV, FV0), GL.COLORS[7], 1)
	GL.VIEW([EV0mesh; FV0mesh; EVmesh; FVmesh])
end
