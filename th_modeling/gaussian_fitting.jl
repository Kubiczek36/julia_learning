using Images, Optim, ImageCore, ProgressBars

function coordinates(img::AbstractArray{T,2}) where T<:Number
    h, w = size(img)
    x = repeat(collect(0:w-1)', outer=(h, 1))
    y = repeat(collect(0:h-1), outer=(1, w))
    return x, y
end

# image center of mass

function fit_blob(img::AbstractArray, init_guess::Vector)
    # Define a 2D Gaussian function
    gauss(x, y, A, x0, y0, σx, σy) = A * exp(-((x - x0)^2 / (2σx^2) + (y - y0)^2 / (2σy^2)))
    # Define the objective function to minimize (sum of squared residuals)
    function obj(params)
        A, x0, y0, σx, σy = params
        x, y = coordinates(img)
        img_vals = img
        gauss_vals = gauss.(x, y, Ref(A), Ref(x0), Ref(y0), Ref(σx), Ref(σy))
        return sum((img_vals - gauss_vals).^2)
    end
    # Minimize the objective function using the Nelder-Mead algorithm
    res = optimize(obj, init_guess, NelderMead())

    # Extract the fitted parameters
    A_fit, x0_fit, y0_fit, σx_fit, σy_fit = res.minimizer

    return A_fit, x0_fit, y0_fit, σx_fit, σy_fit
end

function center_of_mass(img)
    x = 1:size(img, 1)
    y = 1:size(img, 2)
    x0 = sum(x .* img) / sum(img)
    y0 = sum(y .* img) / sum(img)
    return x0, y0
end

# image second moment
function second_moment(img)
    x = 1:size(img, 1)
    y = 1:size(img, 2)
    x0, y0 = center_of_mass(img)
    σx = sqrt(sum((x .- x0).^2 .* img) / sum(img))
    σy = sqrt(sum((y .- y0).^2 .* img) / sum(img))
    return σx, σy
end


function get_gaussian_init_guess(img::AbstractArray)
    x = 1:size(img, 1)
    y = 1:size(img, 2)
    x0 = sum(x .* img) / sum(img)
    y0 = sum(y .* img) / sum(img)
    σx = sqrt(sum((x .- x0).^2 .* img) / sum(img))
    σy = sqrt(sum((y .- y0).^2 .* img) / sum(img))
    # image center of mass
    # center = center_of_mass(img)
    # image second moment
    # σx, σy = second_moment(img)
    # initial guess
    init_guess = [maximum(img),x0, y0, σx, σy]
    return init_guess
end
#

# read array from the hdf5 file
using HDF5

f = h5open("/Users/jakub.dokulil/Desktop/drift/2023-01-16-mock_measurment/data.h5", "r")
dataset = f["cursor stacks"]
#convert dataset to array
data = read(dataset);

@info "data size is: $(size(data))"

fit_data = zeros(size(data, 5), size(data, 4), size(data, 3), 5);

print("size of fit_data: $(size(data))")
print("gonna have size: $(size(fit_data))")
@info "Starting to fit blobs"
for time in ProgressBar(1:size(data, 5))
    for cursor in 1:size(data, 4)
        for grid in 1:size(data, 3)
            # println("grid: $(grid), cursor: $(cursor), time: $(time)")
            @debug "grid: $(grid), cursor: $(cursor), time: $(time)"
            @debug "$(data[:, :, grid, cursor, time])"
            image = UInt8.(data[:, :, grid, cursor, time])
            init_guess = get_gaussian_init_guess(image);
            fit_data[time, cursor, grid, :] .= fit_blob(image, init_guess);
        end
    end
    # @info "Finished time $(time)"
end

# save fit data as hdf5 file
f = h5open("/Users/jakub.dokulil/Desktop/drift/2023-01-16-mock_measurment/fit_data_1.h5", "w")
write(f, "fit_data", fit_data)
close(f)

using Metal

function vadd(a, b, c)
    i = thread_position_in_grid_1d()
    c[i] = a[i] + b[i]
    return
end

a = MtlArray([1]); b = MtlArray([2]); c = similar(a);

@metal threads=length(c) vadd(a, b, c)

@metal threads=length(c) a+b

Array(c)