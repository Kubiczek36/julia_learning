### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 0f2a68c5-a526-4ce7-86fe-49629e14e6d8
begin
	using Pkg
	Pkg.activate("../.")
end

# ╔═╡ 1b76220e-1728-4414-9c5b-13794d4cc9d2
begin
	using PlutoUI
	using CSV, DataFrames
	using Shapefile, ZipFile
	using LsqFit
end

# ╔═╡ baca7d32-8567-11ed-036c-c977db587718
md"""
# Epidemic propag
"""

# ╔═╡ b5879302-22cc-4177-bc04-fc661d7e3ab3
@bind day Clock(0.5)

# ╔═╡ 1af5d360-76fc-41f9-b053-92775cd45258
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv";

# ╔═╡ 883cf3f5-5876-486e-8660-d18e775d9e82
download(url, "covid_data.csv")

# ╔═╡ 0cdc7151-ae6b-44c7-960b-eae01b850a00
begin
	csv_data = CSV.File("covid_data.csv");   
	data = DataFrame(csv_data) 
end

# ╔═╡ 0400d896-0c25-481e-ab7f-593ecdc63eaf
begin
	data_2 = rename(data, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude")   
	# head(data_2)
end

# ╔═╡ eae3dc30-2c35-4da2-aa16-7c5b9993aff8
rename!(data, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude")

# ╔═╡ 40e89bb9-2028-4054-852a-eb9acad3fdef
all_countries = data[:, :country]

# ╔═╡ b47143f8-8e79-4cf2-8019-71aaa1a14b9e
countries = unique(all_countries);

# ╔═╡ c6eb88a7-dac3-4bc7-b353-181744424191
@bind country Select(countries)

# ╔═╡ Cell order:
# ╠═baca7d32-8567-11ed-036c-c977db587718
# ╠═0f2a68c5-a526-4ce7-86fe-49629e14e6d8
# ╠═1b76220e-1728-4414-9c5b-13794d4cc9d2
# ╠═b5879302-22cc-4177-bc04-fc661d7e3ab3
# ╠═1af5d360-76fc-41f9-b053-92775cd45258
# ╠═883cf3f5-5876-486e-8660-d18e775d9e82
# ╠═0cdc7151-ae6b-44c7-960b-eae01b850a00
# ╠═0400d896-0c25-481e-ab7f-593ecdc63eaf
# ╠═eae3dc30-2c35-4da2-aa16-7c5b9993aff8
# ╠═40e89bb9-2028-4054-852a-eb9acad3fdef
# ╠═b47143f8-8e79-4cf2-8019-71aaa1a14b9e
# ╠═c6eb88a7-dac3-4bc7-b353-181744424191
