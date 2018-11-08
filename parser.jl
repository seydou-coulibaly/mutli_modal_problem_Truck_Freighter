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
    demandeCs   = Float64[]
    timeWindowCs = Float64[]
    latitudeCl  = Float64[]
    longitudeCl = Float64[]
    demandeCl = Float64[]
    timeWindowCl = Float64[]
    for line in eachline(f)
        pointeurLine = split(line)
        if pointeurLine[3] == "D"
            # Depot, ce bloc est executé une seule fois par instance
            push!(V, parse(Int,pointeurLine[1]))
            latitudeDepot  = parse(Float64,pointeurLine[4])
            longitudeDepot = parse(Float64,pointeurLine[5])
        elseif pointeurLine[3] == "P"
            # Parking
            push!(V, parse(Int,pointeurLine[1]))
            push!(P,parse(Int,pointeurLine[1]))
            push!(latitudeParking ,parse(Float64,pointeurLine[4]))
            push!(longitudeParking,parse(Float64,pointeurLine[5]))
        elseif pointeurLine[3] == "L"
            # Clients
            push!(V, parse(Int,pointeurLine[1]))
            push!(J,parse(Int,pointeurLine[1]))
            push!(Jl,parse(Int,pointeurLine[1]))
            push!(demandeCl,parse(Float64,pointeurLine[2]))
            push!(latitudeCl ,parse(Float64,pointeurLine[4]))
            push!(longitudeCl,parse(Float64,pointeurLine[5]))
            push!(timeWindowCl,parse(Float64,pointeurLine[6]))
        elseif pointeurLine[3] == "LS"
            # Clients
            push!(V, parse(Int,pointeurLine[1]))
            push!(J,parse(Int,pointeurLine[1]))
            push!(Js,parse(Int,pointeurLine[1]))
            push!(Jl,parse(Int,pointeurLine[1]))
            push!(demandeCl,parse(Float64,pointeurLine[2]))
            push!(latitudeCl ,parse(Float64,pointeurLine[4]))
            push!(longitudeCl,parse(Float64,pointeurLine[5]))
            push!(timeWindowCl,parse(Float64,pointeurLine[6]))
            push!(demandeCs,parse(Float64,pointeurLine[2]))
            push!(latitudeCs ,parse(Float64,pointeurLine[4]))
            push!(longitudeCs,parse(Float64,pointeurLine[5]))
            push!(timeWindowCs,parse(Float64,pointeurLine[6]))

        else
            # Clients
            push!(V, parse(Int,pointeurLine[1]))
            push!(J,parse(Int,pointeurLine[1]))
            push!(Js,parse(Int,pointeurLine[1]))
            push!(demandeCs,parse(Float64,pointeurLine[2]))
            push!(latitudeCs ,parse(Float64,pointeurLine[4]))
            push!(longitudeCs,parse(Float64,pointeurLine[5]))
            push!(timeWindowCs,parse(Float64,pointeurLine[6]))

        end
    end
    # Vset = union(Vset,Pset)
    println("\n ************* Data : *************")
    println("V : $V")
    println("P : $P")
    println("J : $J")
    println("Js : $Js")
    println("Jl : $Jl")
    println("Latitude Depot  : \n $latitudeDepot")
    println("Longitude Depot : \n $longitudeDepot")

    println("Latitude Parking  : \n $latitudeParking")
    println("Longitude Parking : \n $longitudeParking")

    println("Demande stisfies by big truck  : \n $demandeCl")
    println("Latitude doing by big truck  : \n $latitudeCl")
    println("Longitude doing by big truck : \n $longitudeCl")
    println("Time window by big truck : \n $timeWindowCl")

    println("Demande stisfies by Small truck : \n $demandeCs")
    println("Latitude doing by Small truck  : \n $latitudeCs")
    println("Longitude doing by Small truck : \n $longitudeCs")
    println("Time window by Small truck : \n $timeWindowCs")
    close(f)
    return V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,demandeCl,latitudeCl,longitudeCl,timeWindowCl,demandeCs,latitudeCs,longitudeCs,timeWindowCs
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
fname = "C1-2-8.txt"
function loadData(fname)
    Q,ALPHA,T,W,S = loadParametre()
    V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,demandeCl,latitudeCl,longitudeCl,timeWindowCl,demandeCs,latitudeCs,longitudeCs,timeWindowCs = loadInstance(fname)
    cout = loadMatriceCost()
    return Q,ALPHA,T,W,S,V,P,J,Js,Jl,latitudeDepot,longitudeDepot,latitudeParking,longitudeParking,demandeCl,latitudeCl,longitudeCl,timeWindowCl,demandeCs,latitudeCs,longitudeCs,timeWindowCs,cout
end
loadData(fname)
