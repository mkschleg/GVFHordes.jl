import Base.get

abstract type AbstractParameterFunction end

function get(apf::AbstractParameterFunction, state_t, action_t, state_tp1, action_tp1, preds_tilde) end

function call(apf::AbstractParameterFunction, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    get(apf::AbstractParameterFunction, state_t, action_t, state_tp1, action_tp1, preds_tilde)
end

# This is a potential direction for letting people add more functionality if need be...
# function get(apf::AbstractParameterFunction, args...; kwargs...) end
# call(apf::AbstractParameterFunction, args...; kwargs...) = get(apf, args; kwargs)

include("Discounts.jl")
include("Cumulants.jl")
include("Policies.jl")

abstract type AbstractGVF end

function get(gvf::AbstractGVF, state_t, action_t, state_tp1, action_tp1, preds_tilde) end

get(gvf::AbstractGVF, state_t, action_t, state_tp1, preds_tilde) =
    get(gvf::AbstractGVF, state_t, action_t, state_tp1, nothing, preds_tilde)

get(gvf::AbstractGVF, state_t, action_t, state_tp1) =
    get(gvf::AbstractGVF, state_t, action_t, state_tp1, nothing, nothing)

struct GVF{C<:AbstractCumulant, D<:AbstractDiscount, P<:AbstractPolicy} <: AbstractGVF
    cumulant::C
    discount::D
    policy::P
end

function get(gvf::GVF, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    c = get(gvf.cumulant, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    γ = get(gvf.discount, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    π_prob = get(gvf.policy, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    return c, γ, π_prob
end

struct GVFCollection{C<:AbstractCumulant, D<:AbstractDiscount, P<:AbstractPolicy} <: AbstractGVF
    cumulants::Vector{C}
    discounts::Vector{D}
    policies::Vector{P}
end

function get(gvfc::GVFCollection, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    C = map(c -> get(c, state_t, action_t, state_tp1, action_tp1, preds_tilde), gvfc.cumulants)
    Γ = map(γ -> get(γ, state_t, action_t, state_tp1, action_tp1, preds_tilde), gvfc.discounts)
    Π_probs = map(π -> get(π, state_t, action_t, state_tp1, action_tp1, preds_tilde), gvfc.policies)
    return C, Γ, Π_probs
end
