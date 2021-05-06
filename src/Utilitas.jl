module Utilitas

	using Pkg: add,dependencies
	using TOML: parse
	using Downloads: download
	using JLFzf: inter_fzf
	using JSON3: read
	
	export search, seadd, gelat, chklat, chkall
	
	include("pkgops.jl")
end
