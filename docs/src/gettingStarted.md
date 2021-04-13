# 2 - Installation

If you have not done so already, download and install [Julia](https://julialang.org/downloads/).

To install a Julia package you have to use the package manager Pkg. Enter the Pkg REPL by pressing `]` from the Julia REPL and then use the command `add`.

This package is not in a registry, it can be added by instead of the package name giving the URL to the repository to add.

 ```julia-repl
  ] add https://github.com/eOnofri04/AlphaStructures.jl
 ```

If you want, you can test if everything is working fine by running

```julia-repl
  ] test AlphaStructures
```

this will run all the tests written so far and checking all is working properly.

## Plots

If you want to use a Graphic Interface to preview the results you are going to build up, you can also use [ViewerGL](https://github.com/cvdlab/ViewerGL.jl) package developed by [CVD-LAB](https://github.com/cvdlab) by running

```julia-repl
  ] add ViewerGL
  using ViewerGL
```

### Missing nmake in Triangle.jl installation

On windows you will need [Windows SDK](https://developer.microsoft.com/cs-cz/windows/downloads/windows-10-sdk). Then you need to start julia in `x64 Native Tools Command Prompt for VS 2017` and build the package.

```julia-repl
  ] add Triangle
  ] build Triangle
```

Then you can start julia from `cmd`.
