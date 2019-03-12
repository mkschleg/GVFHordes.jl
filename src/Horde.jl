module Horde

export GVF, GVFHorde, GVFHorde_matt, get_parameters, get,
    FeatureCumulant, ConstantDiscount, NullPolicy
include("GVF/GVF.jl")


abstract type AbstractHorde end

# Andrew's Implementation
# struct GVFHorde{C<:AbstractCumulant, D<:AbstractDiscount, P<:AbstractPolicy} <: AbstractHorde
#     cumulants::Vector{C}
#     discounts::Vector{D}
#     policies::Vector{P}
# end

# function get(gvfh::GVFHorde, state_t, action_t, state_tp1, action_tp1, preds_tp1)
#     C = map(c -> get(c, state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.cumulants)
#     Γ = map(γ -> get(γ, state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.discounts)
#     Π_probs = map(π -> get(π, state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.policies)
#     return C, Γ, Π_probs
# end

# Matt's Implementation
struct GVFHorde{T<:AbstractGVF} <: AbstractHorde
    gvfs::Vector{T}
end

function get(gvfh::GVFHorde, state_t, action_t, state_tp1, action_tp1, preds_tp1)
    C = map(gvf -> get(cumulant(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Γ = map(gvf -> get(discount(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Π_probs = map(gvf -> get(policy(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    return C, Γ, Π_probs
end



end # module
