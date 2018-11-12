function loadParametre()
    head = ""
    f = open("instances2018/parameters.txt")
    for line in eachline(f)
        # println("$(length(line)), $(line)")
        head = line
    end
    close(f)
    head = split(head)
    # println(head)
    Q = parse(Float64,head[1])
    alpha = parse(Float64,head[2])
    T = parse(Float64,head[3])
    width = parse(Float64,head[4])
    s = parse(Float64,head[5])
    # println("$Q, $alpha, $T, $width, $s")
    return Q,alpha,T,width,s
end
function loadInstance(fname)
    fname = "instances2018/"*fname
    f = open(fname)
    line = readline(f)
    # Vset = Set{Int}() push!(Vset, parse(Int,pointeurLine[1]))
    # Jset = Set{Int}()
    # Pset = Set{Int}()
    nodes = Int[]
    V = Int[]
    J = Int[]
    Jls = Int[]
    Js = Int[]
    Jl = Int[]
    P = Int[]
    # fill!(tableau, 42)
    latitude  = Float64[]
    longitude = Float64[]
    q  = Float64[]
    a  = Float64[]
    indice = 1
    for line in eachline(f)
        pointeurLine = split(line)
        # ajouter indice dans nodes et dans V
        push!(nodes, parse(Int, pointeurLine[1]))
        push!(V,indice)
        if pointeurLine[3] == "D"
            # Depot, ce bloc est executé une seule fois par instance
            push!(latitude ,parse(Float64,pointeurLine[4]))
            push!(longitude,parse(Float64,pointeurLine[5]))
        elseif pointeurLine[3] == "P"
            # Parking
            push!(P,indice)
            push!(latitude ,parse(Float64,pointeurLine[4]))
            push!(longitude,parse(Float64,pointeurLine[5]))
        elseif pointeurLine[3] == "L"
            # Clients deliver by long truck
            push!(J,indice)
            push!(Jl,indice)
            push!(q,parse(Float64,pointeurLine[2]))
            push!(latitude ,parse(Float64,pointeurLine[4]))
            push!(longitude,parse(Float64,pointeurLine[5]))
            push!(a,parse(Float64,pointeurLine[6]))
        elseif pointeurLine[3] == "LS"
            # Clients deliver by big or small truck
            push!(J,indice)
            push!(Jls,indice)
            push!(q,parse(Float64,pointeurLine[2]))
            push!(latitude ,parse(Float64,pointeurLine[4]))
            push!(longitude,parse(Float64,pointeurLine[5]))
            push!(a,parse(Float64,pointeurLine[6]))
        else
            # Clients deliver by small truck
            push!(J,indice)
            push!(Js,indice)
            push!(q,parse(Float64,pointeurLine[2]))
            push!(latitude ,parse(Float64,pointeurLine[4]))
            push!(longitude,parse(Float64,pointeurLine[5]))
            push!(a,parse(Float64,pointeurLine[6]))

        end
        indice = indice + 1
    end
    # ajout du sommet n+1 (dupliquer le sommet 0)
    push!(V,indice)
    push!(nodes,nodes[1])
    # Vset = union(Vset,Pset)
    println("\n ************* Data : *************")
    println("V : $V")
    println("P : $P")
    println("J : $J")
    println("Js : $Js")
    println("Jl : $Jl")
    println("Jls : $Jls")
    println("nodes : $nodes")
    println("Latitude Depot  : \n $latitude")
    println("Longitude Depot : \n $longitude")
    println("Demande : \n $q")
    println("Time window aj : \n $a")
    close(f)
    return V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a
end
function loadMatriceCost()
    f = open("instances2018/distancematrix98.txt")
    coutLine = Float64[]
    cout = zeros(0,98) # 98 est la taille en colonne de ma matrice de cout
    for line in eachline(f)
        matLigne = split(line)
        nb = length(matLigne)
        coutLine = zeros(nb)
        for i=1:nb
            coutLine[i] = parse(Float64,matLigne[i])
        end
        coutLine = reshape(coutLine,(1,nb))
        cout = vcat(cout,coutLine)
    end
    close(f)
    return cout
end

function loadData(fname)
    Q,alpha,T,width,s = loadParametre()
    V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a = loadInstance(fname)
    cout = loadMatriceCost()
    return Q,alpha,T,width,s,V,P,J,Js,Jl,Jls,nodes,latitude,longitude,q,a,cout
end
function affichageMatrice(matrice)
    n,m = size(matrice)
    for i = 1:n
        # print("i = $i")
        print("\t")
        for j= 1:m
            print(matrice[i,j])
            print("\t")
        end
        println()
    end
end
