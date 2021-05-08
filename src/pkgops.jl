import TOML: parse
import Downloads: download
import JLFzf: inter_fzf
import Pkg: add, dependencies
import JSON3: read

#reglist = parse(seekstart(download("https://raw.githubusercontent.com/JuliaRegistries/General/master/Registry.toml", IOBuffer())))["packages"]
#k = [c for (b,c) in [a for (a, b) in values(reglist)]]
#v = collect(values(Dict(values(reglist))))
#v = [v[i][2] for i in 1:length(v)]

"""
Searches and returns the information of the selected package
"""
function search()
	x = inter_fzf(k, "--read0")
	if(x!="")
		z = uppercase(x[1])
		str = parse(seekstart(download("https://raw.githubusercontent.com/JuliaRegistries/General/master/$(z)/$(x)/Package.toml", IOBuffer())))["repo"][20:end-4]
		if(str[end-6:end-3] != "_jll")
			y = read(seekstart(download("https://api.github.com/repos/$(str)", IOBuffer())))[:description]
			println(x*".jl :", "\t", y)
		else
			println(x*".jll :", "\t", "A jll package")
		end
		return x
	end
end

"""
Searches and adds the selected package into the current environment
"""
function seadd()
	x = search()
	println("Do you want to add this package to the current environment? (y/n)")
	i = readline()
	if i == "y"
		Pkg.add(x)
	end
end

function installed()
    deps = dependencies()
    installs = Dict{String, VersionNumber}()
    for (uuid, dep) in deps
        dep.is_direct_dep || continue
        dep.version === nothing && continue
        installs[dep.name] = dep.version
    end
    return installs
end

"""
Search and get the latest version of a package
"""
function gelat(x::String = String(search()))
	y = "$(x[1])"
	y = uppercase(y)
	z = keys(parse(seekstart(download("https://raw.githubusercontent.com/JuliaRegistries/General/master/$(y)/$(x)/Versions.toml", IOBuffer()))))
	return maximum(VersionNumber.([i for i in z]))
end

"""
Compare the latest version of a package to the current version
"""
function chklat(x::String = String(inter_fzf(collect(keys(installed())), "--read0")))
	a = installed()[x]
	y = gelat(x)
	println("Installed version => $(a) \nLatest version => $(y)")
end

"""
Check if all the installed packages are at the latest version or not
"""
function chkall()
	a = installed()
	flag = false
	for (i, j) in a
		b = ""
		try
			b = gelat(i)
		catch e
			continue
		end
		if(j != b)
			flag = true
			println("$(i)       Latest version = $(b) \t Current version = $(j)\n")
		end
	end
	if(!flag)
		println("All packages are on the latest version")
	end
end

chklat()
