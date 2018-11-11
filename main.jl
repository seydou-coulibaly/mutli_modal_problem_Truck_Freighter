
# Using the following packages
using JuMP, GLPKMathProgInterface
include("model.jl")
include("parser.jl")
# Proceeding to the optimization
solverSelected = GLPKSolverMIP()
# ------------------------------------------------------------------------------
#                     MAIN
# ------------------------------------------------------------------------------
fname = "C1-2-8.txt"
Q,ALPHA,T,W,S,V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,demandeCl,latitudeCl,longitudeCl,timeWindowCl,demandeCs,latitudeCs,longitudeCs,timeWindowCs,cout = loadData(fname)
ip, Xb, Xs, Xr = setmodel(solverSelected,Q,ALPHA,T,W,S,V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,demandeCl,latitudeCl,longitudeCl,timeWindowCl,demandeCs,latitudeCs,longitudeCs,timeWindowCs,cout)
println("The optimization problem to be solved is:")
print(ip)
println("Solving...");
status = solve(ip)
# Displaying the results
if status == :Optimal
  #println("status = ", status)
  xb = getvalue(Xb)
  xs = getvalue(Xs)
  xr = getvalue(Xr)
  z = getvalue(ip)
end
