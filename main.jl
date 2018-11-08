
# Using the following packages
using JuMP, GLPKMathProgInterface
include("model.jl")
include("parser.jl")
# Proceeding to the optimization
solverSelected = GLPKSolverMIP()
# ------------------------------------------------------------------------------
#                     MAIN
# ------------------------------------------------------------------------------
