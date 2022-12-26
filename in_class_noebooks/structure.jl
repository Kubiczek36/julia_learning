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

# ╔═╡ dfeab2a8-8533-11ed-3a3d-a7b5037e0cd4
begin
	using Pkg
	Pkg.activate("../.")
end

# ╔═╡ 207eb72a-07e8-4911-8731-050bd04af4d5
using LinearAlgebra, SparseArrays, PlutoUI, Images, Colors, ColorSchemes, Plots

# ╔═╡ 1ad9db66-e608-430c-8eeb-62676dcd67e3
using Statistics

# ╔═╡ 1ab54b74-8c19-4819-889d-f6bf5c57c5d0
import ImageMagick

# ╔═╡ aa8c7e80-ef8b-4233-a236-06942afb9878
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 90a237f1-6a2b-4f54-afac-b2c7b2bf40c8
begin
	show_image(M) = get.([ColorSchemes.rainbow], M ./ maximum(M))
	show_image(x::AbstractVector) = show_image(x')
end

# ╔═╡ 06941c25-d7c3-4753-81c8-a5ea42ff9980


# ╔═╡ 55726546-2f08-42e8-a7b5-dbd20058230e
struct OneHot <: AbstractVector{Int} # how it will look like on the outside
	# in this cas it will be a vector filled with Intagers
	n::Int
	k::Int
end

# ╔═╡ 761d6b3e-7a60-4a80-979b-4e4641cccde8
Base.size(x::OneHot) = (x.n, ) # <- here the function is defined
#         | here it says that the x is a OneHot structure

# ╔═╡ c45c50aa-1177-4ac3-b319-9a5714ac3507
Base.getindex(x::OneHot, i::Int) = Int(x.k == i) # we check whge

# ╔═╡ 86d133df-0b09-4740-8b87-c53e92ebac5e
md"""
lets define the functions
"""

# ╔═╡ c6183a82-a26f-488c-98e6-9e7dd08799be
myonevotvect = OneHot(4,3)

# ╔═╡ 99b7efe6-c54d-40e6-b32a-529e387b096d
A = Matrix(Diagonal([1,4,5]))

# ╔═╡ 3490561a-1372-4c46-970f-49ac0a6b85b2
sparse(A)

# ╔═╡ 532191b1-10a5-40a7-8171-ec1edf578405
outerprod(a,b) = [x*y for x ∈ a, y ∈ b]

# ╔═╡ 69ed404c-c0dd-4e62-be8e-5bd2950c4961
@bind size1 Slider(1:20, show_value = true)

# ╔═╡ e8a42ca5-bf4e-4ee9-bd40-e0958febf9d4
@bind size2 Slider(1:20, show_value = true)

# ╔═╡ 00bf4e3a-a87e-466c-a33f-9cae07c7566c
outerprod(1:size1, 1:size2)

# ╔═╡ c9d0e4a7-6d77-4c9e-b035-db896fd17b04
struct Rectangle
	width::Float64
	height::Float64
end

# ╔═╡ dc1493d3-59fb-40f1-8295-45254063b766
r = Rectangle(3,4)

# ╔═╡ 866341ef-4eb3-44c8-bbca-2949709b7824


# ╔═╡ 18f20313-8376-4ab6-a554-a0c7983a834b
width(r::Rectangle) = r.width

# ╔═╡ 9ac9d550-bb29-48bc-b134-656ea514fc23
width(3f0)

# ╔═╡ 6571637f-e8be-4d09-99d7-64f72a96650f
begin
	area(r::Rectangle) = r.width * r.height
	area(x) = x
end

# ╔═╡ 006e3554-fc9f-4a07-9377-876f8110e65b
area(2)

# ╔═╡ 7c621db4-7b72-44df-91a8-b70c8ea6bb88
md"""
## Multiple dispatch
based on the arguments of the function the methods chooses to do something
"""

# ╔═╡ 648ac077-71e7-4c3c-b780-f989a4dae8da
cc = 3 + 4im #just complex num

# ╔═╡ ba74407f-93ac-4ff6-b11a-36f3e319d4ad
@which cc + 3

# ╔═╡ c80e65f1-6466-4f6e-b573-b638183dcc09
@which cc + cc

# ╔═╡ 512ceddd-1294-449b-b451-8438d05d5041
md"""
## macros
"""

# ╔═╡ 4f8bd6a7-9753-46c1-a8a9-28e2a716dc82
peakflops()

# ╔═╡ 6832020c-494f-4758-b72d-17fc552aa6fc
@elapsed peakflops()

# ╔═╡ 1a94912a-78d4-4881-9978-f99ea5fc1e99
@macroexpand @elapsed peakflops()

# ╔═╡ 3d78ef60-1c56-4286-aa1e-ead0816dcdbb
x = 1 + 2

# ╔═╡ 7c73679c-df0e-4184-b58e-fe80fb74462c
md"""
We have ways how to quote the code with `:( expresions )` or `quote ... end`
"""

# ╔═╡ 15e309fb-6228-4495-8635-5630fd65b311


# ╔═╡ 98f8a157-c383-40b3-b523-ede47d830195
expr = :(1 + 2)

# ╔═╡ d56ffc1a-be84-4334-94e3-75e1a2121c17
expr3 = :(y + 1)

# ╔═╡ 192bccd0-6855-41cb-bf04-795ec4678f32
with_terminal() do
	print(dump(expr3))
end

# ╔═╡ 85baedfd-cf32-4c09-a685-18dbff41da30
expr3.args

# ╔═╡ d62fa687-2b09-4282-bd50-d0749e8c0cf5
flag = outerprod([3,4,7], ones(6))

# ╔═╡ 06b4ced9-551b-40f5-9716-de0ee5034af0
show_image(flag)

# ╔═╡ 4e95ec7c-b79e-4e91-9170-da93730286f8
img = outerprod([1;0.4;rand(50)], rand(500));

# ╔═╡ e63718d4-2675-41f7-8c20-c589dfa43b13
show_image(img)

# ╔═╡ 29aa15c4-b316-490a-ba18-563dfee0c73c
noisy_img = img .+ 0.03 .* randn.();

# ╔═╡ e9c0908b-f965-40d2-aeb8-9bf3cb7fed9d
show_image(noisy_img)

# ╔═╡ 1fef2533-30fd-44cc-aa65-15f832636409
img[1:2, 1:20]

# ╔═╡ 7ebf8d00-9467-40c2-a4ec-f2de33fbe788
begin 
	xx = img[1, :]
	yy = img[2, :]
end

# ╔═╡ 89d029f7-5431-4487-8c4d-92cea934c8be
md"""
## Plotting the data 

we use the `Plots.jl` lib
"""

# ╔═╡ 1b8c142b-26ca-4284-bd99-4edceb76e384
scatter(xx, yy, label = "original image", framestyle=:origin)

# ╔═╡ 9878f936-613f-4c42-bfcb-8b90d962972a
begin
	xs = noisy_img[1, :]
	ys = noisy_img[2, :]
	
	scatter(xs, ys, label="noisy", m=:., alpha=0.3, ms=4, ratio=1)
	scatter!(xx, yy, 
			leg=:topleft, label="rank-1", ms=3, alpha=0.3, 
			size=(500, 400), m=:square, c=:red,
			framestyle=:origin)
end

# ╔═╡ e9b00467-d8e7-47d3-843e-df8d87e9d6b8
begin
	xs_centered = xs .- mean(xs);
	ys_centered = ys .- mean(ys);
end

# ╔═╡ f38548c7-3c84-406c-bc22-f450ecf7ae2f
scatter(xs_centered, ys_centered, framestyle = :origin)

# ╔═╡ d0135df4-12bd-4c3b-a364-c8c60c883eac
a = 2

# ╔═╡ d7bdc236-7a7c-462f-b378-ad6c61e705a1
c = 3 + 2im

# ╔═╡ 50cdac1c-bd40-4408-a8c2-a6f1dc287ca2
@code_native a * c

# ╔═╡ 47fa1232-7afd-4d2d-bb7e-54ffde21d001


# ╔═╡ Cell order:
# ╠═dfeab2a8-8533-11ed-3a3d-a7b5037e0cd4
# ╠═1ab54b74-8c19-4819-889d-f6bf5c57c5d0
# ╠═aa8c7e80-ef8b-4233-a236-06942afb9878
# ╠═207eb72a-07e8-4911-8731-050bd04af4d5
# ╠═90a237f1-6a2b-4f54-afac-b2c7b2bf40c8
# ╠═06941c25-d7c3-4753-81c8-a5ea42ff9980
# ╠═55726546-2f08-42e8-a7b5-dbd20058230e
# ╟─86d133df-0b09-4740-8b87-c53e92ebac5e
# ╠═761d6b3e-7a60-4a80-979b-4e4641cccde8
# ╠═c45c50aa-1177-4ac3-b319-9a5714ac3507
# ╠═c6183a82-a26f-488c-98e6-9e7dd08799be
# ╠═99b7efe6-c54d-40e6-b32a-529e387b096d
# ╠═3490561a-1372-4c46-970f-49ac0a6b85b2
# ╠═532191b1-10a5-40a7-8171-ec1edf578405
# ╠═00bf4e3a-a87e-466c-a33f-9cae07c7566c
# ╠═69ed404c-c0dd-4e62-be8e-5bd2950c4961
# ╠═e8a42ca5-bf4e-4ee9-bd40-e0958febf9d4
# ╠═c9d0e4a7-6d77-4c9e-b035-db896fd17b04
# ╠═dc1493d3-59fb-40f1-8295-45254063b766
# ╠═866341ef-4eb3-44c8-bbca-2949709b7824
# ╠═18f20313-8376-4ab6-a554-a0c7983a834b
# ╠═9ac9d550-bb29-48bc-b134-656ea514fc23
# ╠═6571637f-e8be-4d09-99d7-64f72a96650f
# ╠═006e3554-fc9f-4a07-9377-876f8110e65b
# ╠═7c621db4-7b72-44df-91a8-b70c8ea6bb88
# ╠═648ac077-71e7-4c3c-b780-f989a4dae8da
# ╠═ba74407f-93ac-4ff6-b11a-36f3e319d4ad
# ╠═c80e65f1-6466-4f6e-b573-b638183dcc09
# ╠═512ceddd-1294-449b-b451-8438d05d5041
# ╠═4f8bd6a7-9753-46c1-a8a9-28e2a716dc82
# ╠═6832020c-494f-4758-b72d-17fc552aa6fc
# ╠═1a94912a-78d4-4881-9978-f99ea5fc1e99
# ╠═3d78ef60-1c56-4286-aa1e-ead0816dcdbb
# ╠═7c73679c-df0e-4184-b58e-fe80fb74462c
# ╠═15e309fb-6228-4495-8635-5630fd65b311
# ╠═98f8a157-c383-40b3-b523-ede47d830195
# ╠═d56ffc1a-be84-4334-94e3-75e1a2121c17
# ╠═192bccd0-6855-41cb-bf04-795ec4678f32
# ╠═85baedfd-cf32-4c09-a685-18dbff41da30
# ╠═d62fa687-2b09-4282-bd50-d0749e8c0cf5
# ╠═06b4ced9-551b-40f5-9716-de0ee5034af0
# ╠═4e95ec7c-b79e-4e91-9170-da93730286f8
# ╠═e63718d4-2675-41f7-8c20-c589dfa43b13
# ╠═29aa15c4-b316-490a-ba18-563dfee0c73c
# ╠═e9c0908b-f965-40d2-aeb8-9bf3cb7fed9d
# ╠═1fef2533-30fd-44cc-aa65-15f832636409
# ╠═7ebf8d00-9467-40c2-a4ec-f2de33fbe788
# ╟─89d029f7-5431-4487-8c4d-92cea934c8be
# ╠═1b8c142b-26ca-4284-bd99-4edceb76e384
# ╠═9878f936-613f-4c42-bfcb-8b90d962972a
# ╠═1ad9db66-e608-430c-8eeb-62676dcd67e3
# ╠═e9b00467-d8e7-47d3-843e-df8d87e9d6b8
# ╠═f38548c7-3c84-406c-bc22-f450ecf7ae2f
# ╠═d0135df4-12bd-4c3b-a364-c8c60c883eac
# ╠═d7bdc236-7a7c-462f-b378-ad6c61e705a1
# ╠═50cdac1c-bd40-4408-a8c2-a6f1dc287ca2
# ╠═47fa1232-7afd-4d2d-bb7e-54ffde21d001
