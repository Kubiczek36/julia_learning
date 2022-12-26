using Statistics, GLMakie, Distributions;
Makie.inline!(true)

x = 0:10
d = Binomial(10,0.5)
f = Figure()
plot(x, pdf.(d, x)) 
lines!(x, pdf.(d, x)) 

pdf.(d, x)[end]

begin 
    trial = 1
    k = Float32.(LinRange(0,1,900000))
    val, ind = findmax(pdf.(Binomial.(10,k), trial))
    k[ind]
    figure, axis, lineplot = lines(k, pdf.(Binomial.(10,k), trial));
    l2 = scatter!(axis, k[ind], val);
    figure
end
    
figure