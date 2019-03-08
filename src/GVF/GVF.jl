using .Cumulants
using .Policies
using .Discounts

struct GVF{C,D,π}
    cumulant::C
    discount::D
    policy::π
end

