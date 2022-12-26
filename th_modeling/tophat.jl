### A Pluto.jl notebook ###
# v0.19.11

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

# ╔═╡ c687b983-d79b-495e-9d4b-77c57eccd2d9
begin
	using Pkg
	Pkg.activate(".")
end

# ╔═╡ ec260f2d-7c8b-41eb-8901-735607c851fd
using PlutoUI, GLMakie, FourierTools

# ╔═╡ 3e4832b4-382f-11ed-3042-db1a671b145d
md"""
# Tophat sim
"""

# ╔═╡ b68fedfb-729c-49d3-ab63-afff5ea77fc1
md"""## used functions"""

# ╔═╡ ca0bcad6-bc02-421f-9138-8efc223218e8
function meshgrid(xin,yin)
	nx=length(xin)
	ny=length(yin)
	xout=zeros(ny,nx)
	yout=zeros(ny,nx)
	for jx=1:nx
	    for ix=1:ny
	        xout[ix,jx]=xin[jx]
	        yout[ix,jx]=yin[ix]
	    end
	end
	return (x=xout, y=yout)
end;

# ╔═╡ a00719a8-7fcb-4ec6-ad20-a3744d5eaa2c
function THmask(arr, r)
	center = size(arr)[1] /2
	x = LinRange(-1,1, size(arr)[1])
	y = LinRange(-1,1, size(arr)[2])
	x,y = meshgrid(x,-y)
	mask = ((x.^2) + (y.^2)) .≤ r^2
	#print(mask)
	arr[mask] .= 1 + 0im
	arr[.~mask] .= -1 + 0im
#	print(arr[1,:])
#	print(angle.(arr)[mask])
	return arr
end;

# ╔═╡ b0b7e950-ee31-4162-8117-98e21016a81c
function plotWave(arr)
	f = Figure(resolution = (1000, 400))
	
	x = LinRange(-1,1, size(arr)[1])
	y = LinRange(-1,1, size(arr)[2])

	ax1, hm1 = heatmap(f[1,1], 
		x, y, 
		abs.(arr),
		axis = (title = "Intensity", aspect = 1), 
		colormap = Reverse(:deep))
	
	cb1 = Colorbar(f[1, 2], hm1)
	cb1.limits = (0, 1)
	
	ax2, hm2 = heatmap(f[1,3], x, y, angle.(arr), axis = (title = "Phase", aspect = 1), colormap = :phase, colorrange = (0, 2π))
	
	cb2 = Colorbar(f[1, 4], hm2)
	cb2.limits = (0, 2π)
	cb2.ticks = [0, π, 2π]
	
	return f
end;

# ╔═╡ 96b06b88-9019-4a9a-830e-c9f302877ad6
angle

# ╔═╡ 1f012f6d-f5f0-407b-a757-5d079bf0a682
md"""
## The code

Pick the relative size of the `TH mask` and `sampling` of the field

$(@bind th_dia PlutoUI.Slider(0:0.01:1; default=0.5, show_value=true))

$(@bind sampling PlutoUI.Slider(100:5000; default=100, show_value=true))
"""

# ╔═╡ 3700c9c3-978f-4df9-8249-046c808eb892
planeWave = ones(ComplexF64, sampling, sampling);

# ╔═╡ 1078cd99-217e-4c52-876d-54ba2a774e77
begin
	x = LinRange(-1,1, sampling);
	x,y = meshgrid(x,-x);
end;

# ╔═╡ ca1c9f3b-8671-425e-beeb-c80c29db5607
thBeam_fr = THmask(planeWave, th_dia);

# ╔═╡ 88705c29-ac0c-48c2-bbac-b329c98f63e7
angle.(thBeam_fr);

# ╔═╡ 107eddeb-5ff7-451c-9c6e-582b460b96b6
angle.([1+ 0im, -1 + 0im])

# ╔═╡ 4ba4bbdc-beb1-4784-9a1e-5dced97347e7
plotWave(thBeam_fr)

# ╔═╡ 94671ff8-1633-401f-989b-94ba3341140c
md"""
The PSF of such a beam, obtained with fft.
$(plotWave(ifftshift2d(ifft2d(thBeam_fr))))

__Detail of the PSF, Drag to zoom__

$(@bind zoom PlutoUI.Slider(0:Int(floor(size(thBeam_fr)[1]*0.2)); default=floor(size(thBeam_fr)[1]*0.05)))
"""


# ╔═╡ a2b37471-59f8-4d50-b6b3-531d9a16210e
begin
	halfsize = Int(floor(zoom/2));
	middle = Int(floor(size(thBeam_fr)[1]/2));
	plotWave(fftshift2d(fft2d(thBeam_fr))[middle - halfsize:middle+halfsize+2, middle - halfsize:middle + halfsize+2])
end

# ╔═╡ 37f1a72b-125f-4035-b2ff-12c850a7a96c
md"### log plot"

# ╔═╡ 8b0e1861-5dee-407e-b7a2-9f7c5ae0fa93
begin
	plotWave(log.(fftshift2d(fft2d(thBeam_fr)))[middle - halfsize:middle+halfsize+2, middle - halfsize:middle + halfsize+2])
end

# ╔═╡ e8a9d3bb-9a6e-4adf-81f9-fde4f6ec8ac0
plotWave(fftshift2d(fft2d(mask)))

# ╔═╡ 62625121-39d3-45f4-ba4e-ca86dc7165c6


# ╔═╡ 79dcaa8e-3052-4442-babf-6bec7b6d2d46
#Gray.(angle.(mask))

# ╔═╡ 24009fcb-2dbc-46bb-be45-97f25dcec3dd
begin
#	f = Figure
# 	ax = Axis(f[1, 1], aspect = 1)
#	heatmap(ax, x, y, angle.(mask))
end

# ╔═╡ 69aa00b8-85e6-4986-b9a2-7ec8488db61c
md"""
to plot wave use:
```julia
begin
	f = Figure(resolution = (800, 400))
#	ax = Axis(f[1, 1], aspect = 1)
#	heatmap!(ax, x, y, angle.(mask))
#	Colorbar(f[1,2])
#	f
	ax1, hm1 = heatmap(f[1,1], LinRange(-1,1, sampling), LinRange(-1,1, sampling), abs.(mask), axis = (title = "Intensity", aspect = 1, xticks = [-1, 0, 1], yticks = [-1, 0, 1]), colormap = Reverse(:deep))
	cb = Colorbar(f[1, 2], hm1)
	cb.limits = (0, 1)
	ax2, hm2 = heatmap(f[1,3], LinRange(-1,1, sampling), LinRange(-1,1, sampling), angle.(mask), axis = (title = "Phase", aspect = 1), colormap = :viridis)
	cb = Colorbar(f[1, 4], hm2)
	cb.limits = (0, 2*π)
end
```
This cell have been added just to have documentation of the plotting function which is up there.
"""

# ╔═╡ 31b7c267-548d-438a-bf59-3b3a64b389fd
#planeWave = ones(ComplexF64, dim, dim)

# ╔═╡ aa667c6b-d0ae-4af8-b665-2e2a999e70d9
plotWave(mask)

# ╔═╡ 2f3c7e4f-4214-412c-8b71-abac8b950736
planeWave[.~mask]

# ╔═╡ e21f2bcf-ad55-4f54-9982-ebdeb66d8a4a
size(planeWave)[1]

# ╔═╡ ddd15980-f17b-497a-a6e2-4db4fe9fa344
@bind row_i PlutoUI.Slider(1:0.5:20, show_value=true)

# ╔═╡ 12fff017-36af-474e-9a42-de86f14b4df9


# ╔═╡ Cell order:
# ╟─3e4832b4-382f-11ed-3042-db1a671b145d
# ╠═c687b983-d79b-495e-9d4b-77c57eccd2d9
# ╠═ec260f2d-7c8b-41eb-8901-735607c851fd
# ╟─b68fedfb-729c-49d3-ab63-afff5ea77fc1
# ╠═ca0bcad6-bc02-421f-9138-8efc223218e8
# ╠═a00719a8-7fcb-4ec6-ad20-a3744d5eaa2c
# ╠═b0b7e950-ee31-4162-8117-98e21016a81c
# ╠═96b06b88-9019-4a9a-830e-c9f302877ad6
# ╟─1f012f6d-f5f0-407b-a757-5d079bf0a682
# ╠═3700c9c3-978f-4df9-8249-046c808eb892
# ╠═1078cd99-217e-4c52-876d-54ba2a774e77
# ╠═ca1c9f3b-8671-425e-beeb-c80c29db5607
# ╠═88705c29-ac0c-48c2-bbac-b329c98f63e7
# ╠═107eddeb-5ff7-451c-9c6e-582b460b96b6
# ╠═4ba4bbdc-beb1-4784-9a1e-5dced97347e7
# ╟─94671ff8-1633-401f-989b-94ba3341140c
# ╠═a2b37471-59f8-4d50-b6b3-531d9a16210e
# ╟─37f1a72b-125f-4035-b2ff-12c850a7a96c
# ╟─8b0e1861-5dee-407e-b7a2-9f7c5ae0fa93
# ╠═e8a9d3bb-9a6e-4adf-81f9-fde4f6ec8ac0
# ╠═62625121-39d3-45f4-ba4e-ca86dc7165c6
# ╟─79dcaa8e-3052-4442-babf-6bec7b6d2d46
# ╟─24009fcb-2dbc-46bb-be45-97f25dcec3dd
# ╟─69aa00b8-85e6-4986-b9a2-7ec8488db61c
# ╠═31b7c267-548d-438a-bf59-3b3a64b389fd
# ╠═aa667c6b-d0ae-4af8-b665-2e2a999e70d9
# ╠═2f3c7e4f-4214-412c-8b71-abac8b950736
# ╠═e21f2bcf-ad55-4f54-9982-ebdeb66d8a4a
# ╠═ddd15980-f17b-497a-a6e2-4db4fe9fa344
# ╠═12fff017-36af-474e-9a42-de86f14b4df9
