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
    "page": "Teorethical Description",
    "title": "Teorethical Description",
    "category": "page",
    "text": ""
},

{
    "location": "theory.html#Theoretical-Introduction-to-\\alpha-shapes-1",
    "page": "Teorethical Description",
    "title": "Theoretical Introduction to alpha-shapes",
    "category": "section",
    "text": "Let S a set of n sites in mathbb R^d (finite). Suppose we want to build is something like \"the shape formed by these points\". Of course it could be done in many ways: alpha shapes are one of them.As Edelbrunner and Mücke said in their paper [1] alpha shapes could be thinked as the following. Imagine a huge mass of ice-cream making up the space mathbb R^d and containing the points S as \"hard\" chocolate pieces. Using one of these sphere-formed ice-cream spoons we carve out all parts of the ice-cream block we can reach without bumping into chocolate pieces, thereby even carving out holes in the inside (eg. parts not reachable by simply moving the spoon from the outside). We will eventually end up with a (not necessarily convex) object bounded by caps, arcs and points; we will call this object alpha-hull of S. If we now straighten all \"round\" faces to triangles and line segments, we have an intuitive description of what is called the alpha-shape of S.But what is alpha after all? In the ice-cream analogy above, alpha is the squared radius of the carving spoon. A very small value will allow us to eat up all of the ice-cream except the chocolate points themselves. Thus for alpha to 0 the alpha shape degenerates to the sites set S. On the other hand, a huge value of alpha will prevent us even from moving the spoon between two points since it is too large and we will never spoon up the ice-cream lying in the inside of the convex hull of S. Hence, the alpha-shape becomes the convex hull of S as alpha to infty."
},

{
    "location": "theory.html#Introduction-1",
    "page": "Teorethical Description",
    "title": "Introduction",
    "category": "section",
    "text": "In the following we assume that the set of sites S is made of points in a general position (no d+2 points of S lie on a common ball). Of course this condition is not general (regardless of the name); however there’s a technique called SoS which \"simulates an infinitesimal perturbation of the points\", so that they are in general position afterwards.First of all we need to identify what the spoon of the introduction is.definition: Definition\nFor each 0  alpha  infty let an alpha-ball be an open ball with radius alpha. We will identify with B_x(alpha) the alpha-ball centered in x. For completenes we could therefore impose that B_x(0) represents the point x. Now, a certain alpha-ball B (at a given location) is called empty if bB cap S = emptyset.We can then define what an alpha-hull is, using the previous definition.definition: Definition\nFor each 0  alpha  infty we define the alpha-hull mathcal H_alpha of S as the complement of the union of all empty alpha-balls:    mathcal H_alpha = overline bigcup_x in mathbb R^d D_alpha(x) mid D_alpha(x) cap S = emptyset  It follows from the previous definition the following three facts:if alpha_1 leq alpha_2 then mathcal H_alpha_1 subseteq mathcal H_alpha_2;\nfor aplhatoinfty we obtain that mathcal H_alpha corresponds to the convex hull of S;\nmathcal H_0 = S since only the sites are considered.One more usefull concept related to what we are introducing is the alpha-diagramm defined as followsdefinition: Definition\nFor each 0  alpha  infty we define the alpha-diagram mathcal U_alpha of S as the the union of all the alpha-balls centered in the sites of S:    mathcal U_alpha =  bigcup_s in S D_alpha(s)It is pretty clear that there is a strict relation between mathcal H_alpha and mathcal U_alpha. In fact a point x belongs to mathcal U_alpha if and only if B_x(alpha) cap mathcal H_alpha ne emptyset. Therefore we obtain the following relations	beginsplit\n		x in mathcal U_alpha iff B_x(alpha) cap mathcal H_alpha ne emptyset\n		x in mathcal H_alpha iff B_x(alpha) subseteq mathcal U_alpha\n	endsplitWe can divide two kind of alpha-shapes:Basic alpha-shapes are based on the Delaunay triangulation.\nWeighted alpha-shapes are based on the regular triangulation, a Delunay generalization where the euclidean distance is replaced by the power to weighted points."
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
