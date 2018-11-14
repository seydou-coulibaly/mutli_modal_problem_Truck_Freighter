
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
# fname = "C1-2-8.txt"
# fname = "R2-3-12.txt"
# ifeasible R1-2-8,
fname  = "instanceNantes.txt"
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
  # passageXb = nodes[listparcours(xb)]
  # passageXs = nodes[listparcours(xs)]
  println("Formattage de solution : necessaire avec CPLEX")
  xs = formaterSol(xs)
  xb = formaterSol(xb)

  affichageMatrice(xb)
  println()
  affichageMatrice(xs)

  passageXb = listparcours(xb)
  passageXs = listparcours(xs)
  println("Ordre de passage big truck")
  println(passageXb)
  println(nodes[passageXb])
  println()
  println("Ordre de passage small Freight")
  println(passageXs)
  println(nodes[passageXs])
  #--------------------------------------------------------------------------------
  println("------------------------------------------------------------------")
  if passageXb[end] == length(V)
      passageXb[end] = passageXb[1]
  end
  # println(passageXb)
  genSol(passageXs,fname,1)
  println()
  genSol(passageXb,fname,2)
end
#
