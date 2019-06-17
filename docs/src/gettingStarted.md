# Installation

If you have not done so already, download and install [Julia](https://julialang.org/downloads/).

This package was developed with `julia 1.1.0` but it should be supported also on `julia 0.6.4`.


To install AlphaShape package first you have to download [this](https://github.com/eOnofri04/AlphaShape.jl) repository.

Then start julia and navigate to the folder called `AlphaShape.jl` (with the command `;cd`);
here run
```julia
include("src/AlphaShape.jl")
using AlphaShape
```

If you want, you can test if everithyng is working fine by running
```julia
include("test/runtests.jl")
```

this will run all the tests written so far and checking all is working properly.

If you want to use a Graphic Interface to preview the results you are going to build up
you can also use [Plasm](https://github.com/cvdlab/Plasm.jl) package developed by [CVD-LAB](https://github.com/cvdlab) by running
```julia
]add Plasm
using Plasm
```

# First Steps

!!! ToDo