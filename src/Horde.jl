module Horde
import Base.get

export GVF, PredictionGVF, get_parameters, get,
    FeatureCumulant, ConstantDiscount, NullPolicy

include("GVF/GVF.jl")


mutable struct GVFHorde{T<:AbstractGVF}
    gvfs::Array{T, 1}
end

@forward GVFHorde.gvfs Base.getindex, Base.length, Base.first, Base.last, Base.iterate, Base.lastindex

function get(horde::AbstractHorde, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    c = zeros(length(horde))
    γ = zeros(length(horde))
    π_prob = zeros(length(horde))

    get!(c, γ, π_prob, GVFHorde.gvfs, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    return c, γ, π_prob
end


function get!(c, γ, π_prob, horde::AbstractHorde, state_t, action_t, state_tp1, action_tp1, preds_tilde)

    pf_tpls = get.(GVFHorde.gvfs, state_t, action_t, state_tp1, action_tp1, preds_tilde)

    c .= first.(pf_tpls)
    γ .= getindex.(pf_tpls, 2)
    π_prob .= last.(pf_tpls)
    return c, γ, π_prob
end


end # module

