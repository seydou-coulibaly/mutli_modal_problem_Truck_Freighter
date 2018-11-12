
# Using the following packages
using JuMP, GLPKMathProgInterface, CPLEX
include("model.jl")
include("parser.jl")
# Proceeding to the optimization
solverSelectedGLPK = GLPKSolverMIP()
solverSelectedCPLEX = CplexSolver()
# ------------------------------------------------------------------------------
#                     MAIN
# ------------------------------------------------------------------------------
fname = "C1-2-8.txt"
Q,alpha,T,width,s,V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a,cout = loadData(fname)
ip, Xb, Xs, ws, wbi, wbo, u = setmodel(solverSelectedCPLEX,Q,alpha,T,width,s,V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a,cout)
println("The optimization problem to be solved is:")
print(ip)
println("Solving...");
status = solve(ip)
# Displaying the results
if status == :Optimal
  #println("status = ", status)
  xb = getvalue(Xb)
  xs = getvalue(Xs)
  ws = getvalue(ws)
  wbi = getvalue(wbi)
  wbo = getvalue(wbo)
  u = getvalue(u)
  affichageMatrice(xb)
  println()
  affichageMatrice(xs)
  println()
  print("wb = \t");println(wbi)
  print("ws = \t");println(ws)
  print("u = \t");println(u)
  print("wbo = \t");println(wbo)
  println("z  = ", getobjectivevalue(ip))
end
