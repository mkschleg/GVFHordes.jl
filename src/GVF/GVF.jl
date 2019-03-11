import Base.get


abstract type AbstractParameterFunction end

function get(apf::AbstractParameterFunction, state_t, action_t, state_tp1, action_tp1, preds_tilde) end

function call(apf::AbstractParameterFunction, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    get(apf::AbstractParameterFunction, state_t, action_t, state_tp1, action_tp1, preds_tilde)
end

# This is a potential direction for letting people add more functionality if need be...
# function get(apf::AbstractParameterFunction, args...; kwargs...) end
# call(apf::AbstractParameterFunction, args...; kwargs...) = get(apf, args; kwargs)

include("GVFArgs.jl")
export GVFArgs

include("Discounts.jl")
include("Cumulants.jl")
include("Policies.jl")

abstract type AbstractGVF end

function get(gvf::AbstractGVF, args::GVFArgs) end
get(gvf::AbstractGVF, state_t::S, action_t::A, state_tp1::S) where {S,A} = get(GVFArgs(state_t, action_t, state_tp1))
get(gvf::AbstractGVF, state_t::S,state_tp1::S) where {S} = get(GVFArgs(state_t, state_tp1))
get(gvf::AbstractGVF, state_t::S,action_t::A,state_tp1::S,preds_tilde::P) where {S,A,P} = get(GVFArgs(state_t, action_t, state_tp1, preds_tilde))


struct GVF{C<:AbstractCumulant, D<:AbstractDiscount, P<:AbstractPolicy} <: AbstractGVF
    cumulant::C
    discount::D
    policy::P
end

function get(gvf::GVF, args::GVFArgs)
    c = get(gvf.cumulant, args)
    γ = get(gvf.discount, args)
    π_prob = get(gvf.policy, args)
    return c, γ, π_prob
end
