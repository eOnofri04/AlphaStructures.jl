# 2 - Installation

If you have not done so already, download and install [Julia](https://julialang.org/downloads/).

This package was developed with `julia 1.1.0` ([![Build Status Julia-1.1](https://travis-ci.org/eOnofri04/AlphaStructures.jl.svg?branch=master)](https://travis-ci.org/eOnofri04/AlphaStructures.jl)) but it should be supported also on `julia 0.6.4`.

To install AlphaStructures package first you have to download [this](https://github.com/eOnofri04/AlphaStructures.jl) repository.

Then start julia and navigate to the folder called `AlphaStructures.jl` (with the command `;cd`); here run:
```julia
include("src/AlphaStructures.jl")
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