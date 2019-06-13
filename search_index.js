var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#AlphaShape.jl-1",
    "page": "Home",
    "title": "AlphaShape.jl",
    "category": "section",
    "text": "AlphaShape.jl is a Julia library to ...In this documentation it is explained a little brief of theory and how to apply it in computer science."
},

{
    "location": "index.html#Dependencies-1",
    "page": "Home",
    "title": "Dependencies",
    "category": "section",
    "text": "AlphaShape.jl has the following dependeces:Plasm\nLinear Algebraic Representation"
},

{
    "location": "index.html#Docstrings-conventions-1",
    "page": "Home",
    "title": "Docstrings conventions",
    "category": "section",
    "text": "Bold is used to point out theory concepts.\nMonospace is used for everything code related."
},

{
    "location": "index.html#Index-1",
    "page": "Home",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "gettingStarted.html#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": ""
},

{
    "location": "gettingStarted.html#Installation-1",
    "page": "Getting Started",
    "title": "Installation",
    "category": "section",
    "text": "If you have not done so already, download and install Julia.This package was developed with julia 1.1.0 but it should be supported also on julia 0.6.4.To install AlphaShape package first you have to download this repository.Then start julia and navigate to the folder called AlphaShape.jl (with the command ;cd); here runinclude(\"src/AlphaShape.jl\")\nusing AlphaShapeIf you want, you can test if everithyng is working fine by runninginclude(\"test/runtests.jl\")this will run all the tests written so far and checking all is working properly.If you want to use a Graphic Interface to preview the results you are going to build up you can also use Plasm package developed by CVD-LAB by running]add Plasm\nusing Plasm"
},

{
    "location": "gettingStarted.html#First-Steps-1",
    "page": "Getting Started",
    "title": "First Steps",
    "category": "section",
    "text": "!!! ToDo"
},

{
    "location": "theory.html#",
    "page": "Introduction to Alpha Structures",
    "title": "Introduction to Alpha Structures",
    "category": "page",
    "text": ""
},

{
    "location": "theory.html#Introduction-to-\\alpha-shapes-1",
    "page": "Introduction to Alpha Structures",
    "title": "Introduction to alpha-shapes",
    "category": "section",
    "text": "Let S a set of n sites in mathbb R^d (finite). Since we are interested in real situation we will restrict to the case d in 2 3; however the following description could be simply enlarged for a general d value.Suppose we want to build is something like \"the shape formed by these points\". Of course it could be done in many ways: alpha shapes are one of them.As Edelbrunner and Mücke said in their paper [1] alpha shapes could be thinked as the following. Imagine a huge mass of ice-cream making up the space mathbb R^d and containing the points S as \"hard\" chocolate pieces. Using one of these sphere-formed ice-cream spoons we carve out all parts of the ice-cream block we can reach without bumping into chocolate pieces, thereby even carving out holes in the inside (eg. parts not reachable by simply moving the spoon from the outside). We will eventually end up with a (not necessarily convex) object bounded by caps, arcs and points; we will call this object alpha-hull of S. If we now straighten all \"round\" faces to triangles and line segments, we have an intuitive description of what is called the alpha-shape of S, denoted by mathcal T.But what is alpha after all? In the ice-cream analogy above, alpha is the squared radius of the carving spoon. A very small value will allow us to eat up all of the ice-cream except the chocolate points themselves. Thus for alpha to 0 the alpha shape degenerates to the sites set S. On the other hand, a huge value of alpha will prevent us even from moving the spoon between two points since it is too large and we will never spoon up the ice-cream lying in the inside of the convex hull of S. Hence, the alpha-shape becomes the convex hull of S as alpha to infty."
},

{
    "location": "theory.html#Gemoetrical-Concept-1",
    "page": "Introduction to Alpha Structures",
    "title": "Gemoetrical Concept",
    "category": "section",
    "text": "We will shortly discuss all the geometrical concepts that are needed to understand what an alpha-shape is.In the following we assume that the set of sites S is made of points in a general position (no d+2 points of S lie on a common ball). Of course this condition is not general (regardless of the name); however there’s a technique called SoS which \"simulates an infinitesimal perturbation of the points\", so that they are in general position afterwards."
},

{
    "location": "theory.html#\\alpha-hulls-and-\\alpha-diagrams-1",
    "page": "Introduction to Alpha Structures",
    "title": "alpha-hulls and alpha-diagrams",
    "category": "section",
    "text": "First of all we need to identify what the spoon of the introduction is.definition: Definition\nFor each 0  alpha  infty let an alpha-ball be an open ball with radius alpha. We will identify with B_x(alpha) the alpha-ball centered in x. For completenes we could therefore impose that B_x(0) represents the point x. Now, a certain alpha-ball B (at a given location) is called empty if B cap S = emptyset.We can then define what an alpha-hull is, using the previous definition.definition: Definition\nFor each 0  alpha  infty we define the alpha-hull mathcal H_alpha of S as the complement of the union of all empty alpha-balls:    mathcal H_alpha = overline bigcup_x in mathbb R^d D_alpha(x) mid D_alpha(x) cap S = emptyset  It follows from the previous definition the following three facts:if alpha_1 leq alpha_2 then mathcal H_alpha_1 subseteq mathcal H_alpha_2;\nfor alphatoinfty we obtain that mathcal H_alpha corresponds to the convex hull of S;\nmathcal H_0 = S since only the sites are considered.One more usefull concept related to what we are introducing is the alpha-diagramm defined as followsdefinition: Definition\nFor each 0  alpha  infty we define the alpha-diagram mathcal U_alpha of S as the the union of all the alpha-balls centered in the sites of S:    mathcal U_alpha =  bigcup_s in S D_alpha(s)It is pretty clear that there is a strict relation between mathcal H_alpha and mathcal U_alpha. In fact a point x belongs to mathcal U_alpha if and only if B_x(alpha) cap mathcal H_alpha ne emptyset. Therefore we obtain the following relations	beginsplit\n		x in mathcal U_alpha iff B_x(alpha) cap mathcal H_alpha ne emptyset\n		x in mathcal H_alpha iff B_x(alpha) subseteq mathcal U_alpha\n	endsplit"
},

{
    "location": "theory.html#and-3-dimensional-problem-resolution-1",
    "page": "Introduction to Alpha Structures",
    "title": "2 and 3 dimensional problem resolution",
    "category": "section",
    "text": "In order to describe in a better way the procedure to build an alpha-complex we will restrict to the case d = 2 3. Of course the proposed method is totally general but this way we will keep the description simple."
},

{
    "location": "theory.html#Delunay-Triangulation-and-Voronoy-Diagrams-1",
    "page": "Introduction to Alpha Structures",
    "title": "Delunay Triangulation and Voronoy Diagrams",
    "category": "section",
    "text": "We can define a Delunay Triangulation mathcal D over the set S and, since the general position condition is satisfied by hypotesis, it follows that the thetrahedra decomposition of the convex hull it\'s unique.For 0 leq k leq 3 we can define F_k as the k-simplices set of mathcal D. It is pretty clear that if a simplex sigma in F_k belongs to mathcal T then it will also belong to mathcal D. It could however be proven that for all the k-simplices sigma of F_k there exists a baralpha such that sigma belongs to F_k baralpha (namely the baralpha-shape k-simplices):	F_k = bigcup_0 leq alpha leq infty F_k alpha qquad forall k in 0 1 2 3We will call baralpha as Charateristic alpha of the simplex sigma and we will denote it like alpha_sigma. It is usefull then to sort the simplices according to their alpha-charateristic.We then obtain a sorted finite set    A_S = alpha_sigma_i mid sigma_i in F_k exists k = 1 2 3However in order to determine A_S there is a better path than evaluate each single alpha-charateristic. This strategy relies on the dual contruction of Delaunay Triangulation: Voronoy Diagrams.Let mathcal V be the Voronoy Decomposition of S. For all site t in S we will denote V_t the Voronoy cell of t."
},

{
    "location": "theory.html#Dimension-2-1",
    "page": "Introduction to Alpha Structures",
    "title": "Dimension 2",
    "category": "section",
    "text": "alpha_sigma could be determined as follows:if sigma in F_0 then alpha_sigma = 0\nif sigma in F_2 then alpha_sigma is the radius of the circumcircle of the triangle\nif sigma = overlinest in F_1 then two cases arise:\nif overlinest intersect the Voronoy segment between V_s and V_t (namely overlinest cap V_s cap V_t ne emptyset) then alpha_sigma = sigma2\nif overlinest do not intersect the Voronoy segment then there exists u in S such that the angle s hatu t  pi2. Then alpha_sigma is the radius of the circumcircle of the triangle sut.It is trivial that 0-cells always are in the alpha-Complex.Moreover it is also pretty clear that if a 2-cell belongs to the alpha-complex then also its 1-cells are part of it."
},

{
    "location": "theory.html#Dimension-3-1",
    "page": "Introduction to Alpha Structures",
    "title": "Dimension 3",
    "category": "section",
    "text": "alpha_sigma could be determined as follows:if sigma in F_0 then alpha_sigma = 0\nif sigma in F_3 then alpha_sigma is the radius of the circumsphere of the tethrahedron.We can divide two kind of alpha-shapes:Basic alpha-shapes are based on the Delaunay triangulation.\nWeighted alpha-shapes are based on the regular triangulation, a Delunay generalization where the euclidean distance is replaced by the power to weighted points."
},

{
    "location": "authors.html#",
    "page": "Authors",
    "title": "Authors",
    "category": "page",
    "text": ""
},

{
    "location": "authors.html#Authors-1",
    "page": "Authors",
    "title": "Authors",
    "category": "section",
    "text": "This repository was developed by two students at RomaTre universisty."
},

{
    "location": "authors.html#[Elia-Onofri](https://github.com/eOnofri04)-1",
    "page": "Authors",
    "title": "Elia Onofri",
    "category": "section",
    "text": "Ln elia.onofri4@gmail.com"
},

{
    "location": "authors.html#[Maria-Teresa-Graziano](https://github.com/marteresagh)-1",
    "page": "Authors",
    "title": "Maria Teresa Graziano",
    "category": "section",
    "text": "marteresa28@gmail.com"
},

{
    "location": "authors.html#Mantainers-1",
    "page": "Authors",
    "title": "Mantainers",
    "category": "section",
    "text": "This repository would be maintained by the Computational Visual Design Laboratory (CVDLAB) of Università degli Studi di Roma Tre."
},

]}
