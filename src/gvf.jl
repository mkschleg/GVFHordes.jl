
using Lazy
using StatsBase
using Random

import Base.get, Base.get!

"""
    GVFParamFuncs

Module containing and the GVF parameter function types. Cleaner to keep these in a seperate namespace where the user can decide to `using` if desired.
"""
module GVFParamFuncs

import Base.get

using ..Random
using ..StatsBase
using ..MinimalRLCore

export
    AbstractCumulant,
    FeatureCumulant,
    PredictionCumulant,
    ScaledCumulant,
    FunctionalCumulant
include("gvf/cumulant.jl")

export
    AbstractDiscount,
    ConstantDiscount,
    StateTerminationDiscount
include("gvf/discount.jl")

export
    AbstractPolicy,
    NullPolicy,
    PersistentPolicy,
    RandomPolicy,
    FucntionalPolicy
include("gvf/policy.jl")

end

"""
    AbstractGVF

This is the base type for a General Value Function. See the "Horde: A scalable real-time architecture for learning knowledge from unsupervised sensorimotor interaction" paper for more details.
"""
abstract type AbstractGVF end

"""
    get(gvf::AbstractGVF, state_t, action_t, state_tp1, action_tp1, preds_tp1)

Get the parameters for the cumulant, discount, and probability of taking an action given the parameters.
"""
function Base.get(gvf::AbstractGVF, state_t, action_t, state_tp1, action_tp1, preds_tp1) end

function cumulant(gvf::AbstractGVF) end
function discount(gvf::AbstractGVF) end
function policy(gvf::AbstractGVF) end

"""
    GVF{C<:AbstractCumulant, D<:AbstractDiscount, P<:AbstractPolicy} <: AbstractGVF

A realized version of a GVF where the cumulant, discount, and policies can be any structure following the AbstractCumulant, AbstractDiscount, or AbstractPolicy api respectively.
"""
struct GVF{C<:GVFParamFuncs.AbstractCumulant,
           D<:GVFParamFuncs.AbstractDiscount,
           P<:GVFParamFuncs.AbstractPolicy} <: AbstractGVF
    cumulant::C
    discount::D
    policy::P
end

cumulant(gvf::GVF) = gvf.cumulant
discount(gvf::GVF) = gvf.discount
policy(gvf::GVF) = gvf.policy

function Base.get(gvf::GVF, state_t, action_t, state_tp1, action_tp1, preds_tp1)
    c = get(gvf.cumulant, state_tp1, action_tp1, preds_tp1)
    γ = get(gvf.discount, state_t, action_t, state_tp1, action_tp1, preds_tp1)
    π_prob = get(gvf.policy, state_t, action_t)
    return c, γ, π_prob
end



