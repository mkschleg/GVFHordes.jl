include("Discounts.jl")
include("Cumulants.jl")
include("Policies.jl")

struct GVF{C,D,π}
    cumulant::C
    discount::D
    policy::π
end
