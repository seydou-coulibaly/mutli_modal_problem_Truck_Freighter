# =========================================================================== #
function setUKP(solverSelected,Q,ALPHA,T,W,S,V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,demandeCl,latitudeCl,longitudeCl,timeWindowCl,demandeCs,latitudeCs,longitudeCs,timeWindowCs,cout)

  pUj = vcat(P,J)

  ip = Model(solver=solverSelected)
  #Variables definitions
  @variable(ip, Xs[1:n+2,1:n+2],Bin)
  @variable(ip, Xb[1:n+2,1:n+2],Bin)
  @variable(ip, Xr[1:n+2,1:n+2],Bin)
  @variable(ip, ws[1:n+2],Bin)
  @variable(ip, wb[1:n+2],Bin)
  @variable(ip, u[1:n+2],Bin)

  #Objectives functions
  @objective(ip, Max, sum(cout[i,j] (Xb[i,j] + ALPHA*Xb[i,j] - Xr[i,j]) for i=1:n+2, j=1:n+2))
  #Constraints of problem
  @constraint(ip, cte1[i in Js], sum(Xs[i,j] for j in V) == 1) # constraint 1
  @constraint(ip, cte2[i in Js], sum(Xb[i,j] for j in V) == 1)

  @constraint(ip, cte3[j in J], sum(Xs[i,j] for i in V) == sum(Xs[j,i] for i in V)) # constraint 2
  @constraint(ip, cte4[j in J], sum(Xb[i,j] for i in V) == sum(Xb[j,i] for i in V))

  @constraint(ip, sum(Xs[0,i] for i in pUj) == sum(Xs[i,n+1] for i in pUj) == 1) # constraint 3
  @constraint(ip, sum(Xs[0,i] for i in pUj) == sum(Xs[i,n+1] for i in pUj) == 1)

  @constraint(ip, cte5[i in jUp, j in jUp], ws[i] + S + ALPHA*cout[i,j] - ws[j] <= (1-xs[i,j]*maximum((timeWindowCs[i] + W + S + cout[i,j] - timeWindowCs[j]), 0)) # constraint 4
  @constraint(ip, cte6[i in jUp, j in jUp], wb[i] + S + ALPHA*cout[i,j] - wb[j] <= (1-xb[i,j]*maximum((timeWindowCl[i] + W + S + cout[i,j] - timeWindowCl[j]), 0))

  @constraint(ip, cte7[i in jUp, j in jUp], u[j] <= u[i] - demandeCs[i] + (1-xs[i,j])*Q) # constraint 5

  @constraint(ip, cte8[i in J], ws[i] <= ws[n+2]) # constraint 6
  @constraint(ip, cte9[i in J], wb[i] <= wb[n+2])

  @constraint(ip, cte10[i in Js], 0 <= u[i]) # constraint 7
  @constraint(ip, cte11[i in Js], u[i] <= Q)

  @constraint(ip, cte12[i in J], ws[i] <= (timeWindowCs[i] + W)) # constraint 8
  @constraint(ip, cte13[i in J], ws[i] >= (timeWindowCs[i]))
  @constraint(ip, cte14[i in J], wb[i] <= (timeWindowCb[i] + W))
  @constraint(ip, cte15[i in J], ws[i] >= (timeWindowCb[i]))

  @constraint(ip, cte16[i in Js, j in P], u[j] <= Q - demandeCs[i] + (1-Xs[i,j])*demandeCs[i]) # constraint 9

  # contrainte de relais @constraint(ip, ) # constraint 10

  @constraint(ip, cte18[i in Js, j in P], xr[i,j] >= xs[i,j] + xb[i,j] - 1) # constraint 11



  return ip, X
end

#-------------------------------------------------------------------------------
# Proceeding to the optimization
solverSelected = GLPKSolverMIP()

function glpk_jump(W,p,w)
  # GLPK et JUMP
  #println()
  #println(" ------- GLPK-JUMP  -------")
  x = zeros(length(p))
  ip,X = setUKP(solverSelected,W,p,w)
  println("The optimization problem to be solved is:")
  print(ip)
  println("Solving...");
  status = solve(ip)
  # Displaying the results
  if status == :Optimal
    #println("status = ", status)
    x = getvalue(X)
  end
  #println()
  return x
end
