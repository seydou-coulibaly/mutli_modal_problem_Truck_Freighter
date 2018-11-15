
# Using the following packages
using JuMP, GLPKMathProgInterface, CPLEX, Gurobi, Cbc
include("model.jl")
include("parser.jl")
# Proceeding to the optimization
solverSelectedGLPK = GLPKSolverMIP()
solverSelectedCPLEX = CplexSolver()
solverSelectedCbc = CbcSolver()
solverSelectedGurobi = GurobiSolver()
solverSelected = solverSelectedGurobi
# ------------------------------------------------------------------------------
#                     MAIN
# ------------------------------------------------------------------------------
fname = "C1-2-8.txt"
# fname = "C1-3-10.txt"
# fname = "C1-3-12.txt"
# fname = "C2-2-8.txt"

# fname = "C2-3-10.txt"

# fname = "C2-3-12.txt"
# fname = "R1-2-8.txt"
# fname = "R1-3-10.txt"
# fname = "R1-3-12.txt"
# fname = "R2-2-8.txt"
# fname = "R2-3-10.txt"
# fname = "R2-3-12.txt"
# ifeasible R1-2-8,
#fname  = "instanceNantes.txt"
Q,alpha,T,width,s,V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a,cout = loadData(fname)
ip, Xb, Xs, ws, wbi, wbo, u = setmodel(solverSelected,Q,alpha,T,width,s,V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a,cout)
println("The optimization problem to be solved is:")
print(ip)
println("Solving...");
tic()
status = solve(ip)
tps = toc()
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
  if solverSelected == solverSelectedCPLEX || solverSelected == solverSelectedCbc
      println("Formattage de solution : necessaire avec CPLEX et Cbc")
      xs = formaterSol(xs)
      xb = formaterSol(xb)
  end

  affichageMatrice(xb)
  println()
  affichageMatrice(xs)

  passageXb = listparcours(xb)
  passageXs = listparcours(xs)
  println("Ordre de passage big truck")
  # print(passageXb);print(" \t correspond aux noeuds \t");
  println(nodes[passageXb])
  println("\nOrdre de passage small Freight")
  # print(passageXs);print(" \t correspond aux noeuds \t");
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
  println("Temps de resolution = $tps seconds")
end
#
