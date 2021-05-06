module Utilitas

	using Pkg: add,dependencies
	using TOML: parse
	using Downloads: download
	using JLFzf: inter_fzf
	using JSON3: read
	
	function __init__()
		reglist = parse(see\kstart(download("https://raw.githubusercontent.com/JuliaRegistries/General/master/Registry.toml", IOBuffer())))["packages"]
		k = [c for (b,c) in [a for (a, b) in values(reglist)]]
	end	

	export search, seadd, gelat, chklat, chkall
	
	include("pkgops.jl")
end
