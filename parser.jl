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
    ALPHA = parse(Float64,head[2])
    T = parse(Float64,head[3])
    W = parse(Float64,head[4])
    S = parse(Float64,head[5])
    println("$Q, $ALPHA, $T, $W, $S")
    return Q,ALPHA,T,W,S
end
function loadInstance(fname)
    fname = "instances2018/"*fname
    f = open(fname)
    line = readline(f)
    # Vset = Set{Int}() push!(Vset, parse(Int,pointeurLine[1]))
    # Jset = Set{Int}()
    # Pset = Set{Int}()

    temp = zeros(0,2)
    V = Int[]
    J = Int[]
    Js = Int[]
    Jl = Int[]
    P = Int[]
    # fill!(tableau, 42)
    latitudeDepot = longitudeDepot = 0
    latitudeParking  = Float64[]
    longitudeParking = Float64[]
    latitudeCs  = Float64[]
    longitudeCs = Float64[]
    qs   = Float64[]
    as = Float64[]
    latitudeCl  = Float64[]
    longitudeCl = Float64[]
    ql = Float64[]
    al = Float64[]


    i = 1
    for line in eachline(f)
        pointeurLine = split(line)
        temp = vcat(temp, reshape([i, parse(Float64, pointeurLine[1])],(:,2)))
        i += 1
    end
    close(f)
    f = open(fname)
    line = readline(f)


    for line in eachline(f)
        pointeurLine = split(line)
        if pointeurLine[3] == "D"
            # Depot, ce bloc est executé une seule fois par instance
            push!(V, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            latitudeDepot = parse(Float64,pointeurLine[4])
            longitudeDepot = parse(Float64,pointeurLine[5])
        elseif pointeurLine[3] == "P"
            # Parking
            push!(V, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(P, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(latitudeParking ,parse(Float64,pointeurLine[4]))
            push!(longitudeParking,parse(Float64,pointeurLine[5]))
        elseif pointeurLine[3] == "L"
            # Clients
            push!(V, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(J, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(Jl, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(ql,parse(Float64,pointeurLine[2]))
            push!(latitudeCl ,parse(Float64,pointeurLine[4]))
            push!(longitudeCl,parse(Float64,pointeurLine[5]))
            push!(al,parse(Float64,pointeurLine[6]))
        elseif pointeurLine[3] == "LS"
            # Clients
            push!(V, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(J, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(Js, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(Jl, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(ql,parse(Float64,pointeurLine[2]))
            push!(latitudeCl ,parse(Float64,pointeurLine[4]))
            push!(longitudeCl,parse(Float64,pointeurLine[5]))
            push!(al,parse(Float64,pointeurLine[6]))
            push!(qs,parse(Float64,pointeurLine[2]))
            push!(latitudeCs ,parse(Float64,pointeurLine[4]))
            push!(longitudeCs,parse(Float64,pointeurLine[5]))
            push!(as,parse(Float64,pointeurLine[6]))

        else
            # Clients
            push!(V, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(J, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(Js, findfirst(temp[:,2], parse(Float64, pointeurLine[1])))
            push!(qs,parse(Float64,pointeurLine[2]))
            push!(latitudeCs ,parse(Float64,pointeurLine[4]))
            push!(longitudeCs,parse(Float64,pointeurLine[5]))
            push!(as,parse(Float64,pointeurLine[6]))

        end
    end
    # Vset = union(Vset,Pset)
    println("\n ************* Data : *************")
    println("temp: ", temp)
    println("V : $V")
    println("P : $P")
    println("J : $J")
    println("Js : $Js")
    println("Jl : $Jl")
    println("Latitude Depot  : \n $latitudeDepot")
    println("Longitude Depot : \n $longitudeDepot")

    println("Latitude Parking  : \n $latitudeParking")
    println("Longitude Parking : \n $longitudeParking")

    println("Demande stisfies by big truck  : \n $ql")
    println("Latitude doing by big truck  : \n $latitudeCl")
    println("Longitude doing by big truck : \n $longitudeCl")
    println("Time window by big truck : \n $al")

    println("Demande stisfies by Small truck : \n $qs")
    println("Latitude doing by Small truck  : \n $latitudeCs")
    println("Longitude doing by Small truck : \n $longitudeCs")
    println("Time window by Small truck : \n $as")
    close(f)
    return V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,ql,latitudeCl,longitudeCl,al,qs,latitudeCs,longitudeCs,as
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
    Q,ALPHA,T,W,S = loadParametre()
    V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,ql,latitudeCl,longitudeCl,al,qs,latitudeCs,longitudeCs,as = loadInstance(fname)
    cout = loadMatriceCost()
    return Q,ALPHA,T,W,S,V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,ql,latitudeCl,longitudeCl,al,qs,latitudeCs,longitudeCs,as,cout
end
