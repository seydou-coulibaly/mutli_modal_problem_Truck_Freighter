
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
ip, Xb, Xs, ws, wbi, wbo, u = setmodel(solverSelectedGLPK,Q,alpha,T,width,s,V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a,cout)
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
  #--------------------------------------------------------------------------------
  # f = open("smallFreight.txt", "w");
  #  # for i = 1:length(yn[:,1])
  #  #     x1  = yn[i,indV1]
  #  #     x2  = yn[i,indV2]
  #  #     f1  = yn[i,indF1]
  #  #     f2  = yn[i,indF2]
  #  #     write(f,"$i \t $x1 \t $x2 \t $f1 \t $f2\n");
  #  # end
  #  close(f);
  #  f = open("bigTruck.txt", "w");
  #   # for i = 1:length(yn[:,1])
  #   #     x1  = yn[i,indV1]
  #   #     x2  = yn[i,indV2]
  #   #     f1  = yn[i,indF1]
  #   #     f2  = yn[i,indF2]
  #   #     write(f,"$i \t $x1 \t $x2 \t $f1 \t $f2\n");
  #   # end
  #   close(f);
  #   f = open("parking.txt", "w");
  #    # for i = 1:length(yn[:,1])
  #    #     x1  = yn[i,indV1]
  #    #     x2  = yn[i,indV2]
  #    #     f1  = yn[i,indF1]
  #    #     f2  = yn[i,indF2]
  #    #     write(f,"$i \t $x1 \t $x2 \t $f1 \t $f2\n");
  #    # end
  #    close(f);
end
# function listparcours(X)
#     n,m = size(X)
#     indice = 1
#     cond = 0
#     j = 1
#     while j < n
#         if 1 in X[i,:]
#             # cond = true et retourner indice
#         end
#     end
# end
