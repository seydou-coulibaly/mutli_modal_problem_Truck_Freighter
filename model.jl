# =========================================================================== #
function setmodel(solverSelected, Q, ALPHA, T, W, S, V, P, J, Js, Jl, latitudeDepot, longitudeDepot, latitudeParking, longitudeParking, ql, latitudeCl, longitudeCl, al, qs, latitudeCs, longitudeCs, as, cout)

#  pUj = vcat(P[1],J[])
#  n = length(pUj)
n = length(V)

  ip = Model(solver=solverSelected)
  #Variables definitions
  @variable(ip, Xs[1:n+1,1:n+1],Bin)
  @variable(ip, Xb[1:n+1,1:n+1],Bin)
  @variable(ip, Xr[1:n+1,1:n+1],Bin)
  @variable(ip, ws[1:n+1] >= 0)
  @variable(ip, wb[1:n+1] >= 0)
  @variable(ip, u[1:n+1] >= 0)

  #Objectives functions
  @objective(ip, Max, sum(cout[i,j]*(Xb[i,j] + ALPHA*Xs[i,j] - Xr[i,j]) for i=1:n+1, j=1:n+1))
  #Constraints of problem
  @constraint(ip, cte1[i in Js[:,1]], sum(Xs[i,j] for j in V[:,1]) == 1) # constraint 1
  @constraint(ip, cte2[i in Jl[:,1]], sum(Xb[i,j] for j in V[:,1]) == 1)

  @constraint(ip, cte3[j in J], sum(Xs[i,j] for i in V[1]) == sum(Xs[j,i] for i in V[1])) # constraint 2
  @constraint(ip, cte4[j in J], sum(Xb[i,j] for i in V[1]) == sum(Xb[j,i] for i in V[1]))

  @constraint(ip, sum(Xs[1,i] for i in V) == sum(Xs[i,n+1] for i in V[:,1])) # constraint 3
  @constraint(ip, sum(Xb[1,i] for i in V) == sum(Xb[i,n+1] for i in V[:,1]))
  @constraint(ip, sum(Xs[1,i] for i in V) == 1)
  @constraint(ip, sum(Xb[1,i] for i in V) == 1)

  @constraint(ip, cte5[i in Js, j in Js], ws[i] + S + ALPHA*cout[i,j] - ws[j] <= (1-Xs[i,j]* max( ((as[findfirst(Js,i)]) + W + S + cout[i,j] - as[findfirst(Js,j)]), 0))) # constraint 4
  @constraint(ip, cte6[i in Jl, j in Jl], wb[i] + S + ALPHA*cout[i,j] - wb[j] <= (1-Xb[i,j]* max( ((al[findfirst(Jl,i)]) + W + S + cout[i,j] - al[findfirst(Jl,j)]), 0)))

  @constraint(ip, cte7[i in Js, j in Js], u[j] <= u[i] - qs[findfirst(Js,i)] + (1-Xs[i,j])*Q) # constraint 5

  @constraint(ip, cte8[i in J], ws[i] <= ws[n+1]) # constraint 6
  @constraint(ip, cte9[i in J], wb[i] <= wb[n+1])

  @constraint(ip, cte10[i in Js], 0 <= u[i]) # constraint 7
  @constraint(ip, cte11[i in Js], u[i] <= Q)

  @constraint(ip, cte12[i in Js], ws[i] <= (as[findfirst(Js,i)] + W)) # constraint 8
  @constraint(ip, cte13[i in Js], ws[i] >= (as[findfirst(Js,i)]))
  @constraint(ip, cte14[i in Jl], wb[i] <= (al[findfirst(Jl,i)] + W))
  @constraint(ip, cte15[i in Jl], wb[i] >= (al[findfirst(Jl,i)]))

  @constraint(ip, cte16[i in Js, j in P], u[j] <= Q - qs[findfirst(Js,i)] + (1-Xs[i,j])*qs[findfirst(Js,i)]) # constraint 9

  # contrainte de relais @constraint(ip, ) # constraint 10

  @constraint(ip, cte18[i in Js, j in P], Xr[i,j] >= Xs[i,j] + Xb[i,j] - 1) # constraint 11



  return ip, Xb, Xs, Xr
end
