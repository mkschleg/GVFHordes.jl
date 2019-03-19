module Horde
import Base.get

export GVF, GVFHorde, get_parameters, get,
    FeatureCumulant, ConstantDiscount, NullPolicy

include("GVF/GVF.jl")

abstract type AbstractHorde end

struct GVFHorde{T<:AbstractGVF, F} <: AbstractHorde
    gvfs::Vector{T}
    model::F
end

function get(gvfh::GVFHorde, state_t, action_t, state_tp1, action_tp1, preds_tp1)
    C = map(gvf -> get(cumulant(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Γ = map(gvf -> get(discount(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Π_probs = map(gvf -> get(policy(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    return C, Γ, Π_probs
end

(gvfHorde::GVFHorde)(state) = gvfHorde.model(state)


end # module

