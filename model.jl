# =========================================================================== #
function setmodel(solverSelected,Q,alpha,T,width,s,V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a,cout)
    n = length(V)
    m = length(P)
    ip = Model(solver=solverSelected)
    #Variables definitions
    @variable(ip, Xs[1:n,1:n],Bin)
    @variable(ip, Xb[1:n,1:n],Bin)
    @variable(ip, 0 <= ws[1:n] <= T)
    @variable(ip, 0 <= wbi[1:n] <= T)
    @variable(ip, 0 <= wbo[1:m] <= T)
    @variable(ip, 0 <= u[1:n] <= Q)

    #Objectives functions
    @objective(ip, Min, sum(cout[nodes[i],nodes[j]]*(Xb[i,j] + alpha*Xs[i,j]) for i in V, j in V))

    # Constraints of problem
    # constraint1 : Visit all customers
    @constraint(ip,[i in Jls], sum(Xs[i,j] for j in V) + sum(Xb[i,j] for j in V) >= 1)
    @constraint(ip,[i in Js], sum(Xs[i,j] for j in V) == 1)
    @constraint(ip,[i in Jl], sum(Xb[i,j] for j in V) == 1)
    @constraint(ip,[i in V], Xb[i,i] == 0)
    @constraint(ip,[i in V], Xs[i,i] == 0)
    @constraint(ip,[i in V, j in V], Xs[i,j] + Xb[i,j] <= 1)
    # constraint2 : Flow conservation
    # 1) cas où i in J
    @constraint(ip,[i in J], sum(Xb[i,j] for j in V) == sum(Xb[j,i] for j in V))
    @constraint(ip,[i in J], sum(Xs[i,j] for j in V) == sum(Xs[j,i] for j in V))
    # 2) cas où i in P
    @constraint(ip,[i in P], sum(Xb[i,j] for j in V) == sum(Xb[j,i] for j in V))
    @constraint(ip, sum(Xs[i,j] for i in V, j in P) == sum(Xs[j,i] for i in V, j in P))
    # 2) cas sur le depot
    @constraint(ip, sum(Xb[1,i] for i in union(J,P)) == sum(Xb[i,n] for i in union(J,P)))
    @constraint(ip, sum(Xb[1,i] for i in union(J,P)) == 1)
    @constraint(ip, sum(Xs[1,i] for i in union(J,P)) == sum(Xs[i,n] for i in  union(J,P)))
    @constraint(ip, sum(Xs[1,i] for i in union(J,P)) == 0)
    # constraint  3 : fenetre de temps
    @constraint(ip,[i in V, j in J], ws[i] + s + alpha*cout[nodes[i],nodes[j]] <= ws[j] + (1-Xs[i,j])*T)
    @constraint(ip,[i in V, j in V], wbi[i] + s + alpha*cout[nodes[i],nodes[j]] <= wbi[j] + (1-Xb[i,j])*T)

    # Ajout de la fenetre de temps sur wbo
    @constraint(ip,[i=1:m, j in V], wbo[i] <= ws[j] + (1-Xs[P[i],j])*T)
    @constraint(ip,[i=1:m, j in V], wbo[i] <= wbi[j] + (1-Xb[P[i],j])*T)
    # constraint 4 :
    @constraint(ip,[i in J, j in J], u[j] <= u[i] - q[findfirst(J,i)] + (1-Xs[i,j])*Q)
    @constraint(ip,[j in P], u[j] == Q)

    # bloc de constraint  5
    @constraint(ip,[i in union(J,P)], ws[i] <= ws[n])
    @constraint(ip,[i in union(J,P)], wbi[i] <= wbi[n])
    @constraint(ip,[i in union(J,P)], ws[1] <= ws[i])
    @constraint(ip,[i in union(J,P)], wbi[1] <= wbi[i])
    @constraint(ip,wbi[n] == ws[n])
    @constraint(ip,wbi[1] == ws[1])

    # bloc de constraint  6
    @constraint(ip,[i in union(Js,Jls)], a[findfirst(J,i)] <= ws[i])
    @constraint(ip,[i in union(Jl,Jls)], a[findfirst(J,i)] <= wbi[i])

    # constraint 7 : attente client / parking
    @constraint(ip,[i=1:m], wbo[i] >= ws[P[i]])
    @constraint(ip,[i=1:m], wbo[i] >= wbi[P[i]])
    @constraint(ip,[i=1:m, j in J], T*(1-Xs[P[i],j]) + wbo[i] >= ws[j] - alpha*cout[nodes[P[i]],nodes[j]])
    # @constraint(ip,[i=1:m, j in J], wbi[i] <= ws[j] - alpha*cout[nodes[P[i]],nodes[j]] + T*(1-Xs[P[i],j])) # review
    # constraint 8 : si small truck au parking alors forcement big truck est active sur une ligne
    @constraint(ip,[i in P], sum(Xs[i,j] for j in V) <= sum(Xb[i,j] for j in V))
    @constraint(ip,[j in P], sum(Xs[i,j] for i in V) <= sum(Xb[i,j] for i in V))



    return ip, Xb, Xs, ws, wbi, wbo, u
end
