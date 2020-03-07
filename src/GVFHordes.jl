module GVFHordes

# include("GVF/GVF.jl")
# export GVF
include("gvf.jl")

"""
    AbstractHorde

An abstract collection of GVFs.
"""
abstract type AbstractHorde end

"""
    Horde{T<:AbstractGVF} <: AbstractHorde

The simplest implementation of a horde as a collection of AbstractGVFs.
"""
struct Horde{T<:AbstractGVF} <: AbstractHorde
    gvfs::Vector{T}
end

function Base.get(gvfh::Horde, state_t, action_t, state_tp1, action_tp1, preds_tp1)
    C = map(gvf -> get(cumulant(gvf), state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Γ = map(gvf -> get(discount(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Π_probs = map(gvf -> get(policy(gvf), state_t, action_t), gvfh.gvfs)
    return C, Γ, Π_probs
end

function Base.get!(C::Array{T, 1}, Γ::Array{F, 1}, Π_probs::Array{H, 1}, gvfh::Horde, state_t, action_t, state_tp1, action_tp1, preds_tp1) where {T, F, H}
    C .= map(gvf -> get(cumulant(gvf), state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Γ .= map(gvf -> get(discount(gvf), state_t, action_t, state_tp1, action_tp1, preds_tp1), gvfh.gvfs)
    Π_probs .= map(gvf -> get(policy(gvf), state_t, action_t), gvfh.gvfs)
    return C, Γ, Π_probs
end

Base.get(gvfh::Horde, state_tp1, preds_tp1) =
    get(gvfh::Horde, nothing, nothing, state_tp1, nothing, preds_tp1)

Base.get(gvfh::Horde, state_t, action_t, state_tp1) =
    get(gvfh::Horde, state_t, action_t, state_tp1, nothing, nothing)

Base.get(gvfh::Horde, state_t, action_t, state_tp1, preds_tp1) =
    get(gvfh::Horde, state_t, action_t, state_tp1, nothing, preds_tp1)

@forward Horde.gvfs Base.length




end # module
