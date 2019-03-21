using Flux


# handy loss functions

tderror(v_t, c, γ_tp1, ṽ_tp1) = @. c + γ_tp1 * ṽ_tp1 - v_t
tdloss(v_t, c, γ_tp1, ṽ_tp1) = Flux.mse(c .+ γ_tp1.*ṽ_tp1, v_t)


mutable struct Linear{A, V}
    W::A
    b::V
end

Linear(in::Integer, out::Integer; init=Flux.zeros) =
    Linear(init(out, in), Flux.zeros(out))

Linear(x) = W*x + b

abstract type AbstractUpdate end


function train!(model, horde::AbstractHorde, opt, lu::AbstractUpdate, state_t, action_t, state_tp1, action_tp1)
    preds_tilde = Flux.data(model(state_tp1))
    c, γ, π_prob = get(horde, state_t, action_t, state_tp1, action_tp1)
    train!(model, opt, lu, state_t, state_tp1, c, γ_tp1, ρ; prms=nothing)
end

struct TD <: AbstractUpdate
end

function train!(model::Linear, opt, lu::TD, state_t, state_tp1, c, γ_tp1, ρ; prms=nothing)

    v_t = model(state_t)
    v_tp1 = model(state_tp1)

    # TODO: Aggressively optimized code goes here.
    δ = tderror(v_t, c, γ_tp1, v_tp1)
    weights .+= (α.*δ)*state_t'

end

function train!(model, opt, lu::TD, state_t, state_tp1, c, γ_tp1, ρ; prms=nothing)
    if prms == nothing
        prms = params(model)
    end
    grads = Flux.gradient(()->tdloss(model(state_t), c, γ_tp1, Flux.data(model(state_tp1))), prms)
    for p in prms
        Flux.update!(opt, p, grads[p])
    end
end

struct TDLambda <: AbstractUpdate
    λ::Float64
    traces::IdDict
    γ_t::IdDict
    TDLambda(λ) = new(λ, traces)
end

function train!(model, opt, lu::TD, state_t, state_tp1, c, γ_tp1, ρ; prms=nothing)

    if prms == nothing
        prms = params(model)
    end

    v_t = model(state_t)
    v_tp1 = model(state_tp1)

    γ_t = get!(lu.γ_t, model, zero(γ_tp1))::Array{Float64, 1}

    δ = tderror(v_t, c, γ_tp1, Flux.data(v_tp1))

    # Hack to get gradients working without jacobian... I.E. for single layer
    grads = gradient(()->sum(δ), params(model))

    for weights in prms
        e = get!(lu.traces, weights, zeros(weights))::typeof(Flux.data(weights))
        e .= convert(Array{Float64, 2}, Diagonal(γ_t)) * λ * e - grads[weights].data
        Flux.Tracker.update!(opt, weights, e.*(δ))
    end

    γ_t .= γ_tp1
end

# # Force to be a single layer only!
# function train!(model, horde::AbstractHorde, opt, lu::TDLambda, state_t, action_t, state_tp1, action_tp1; prms=nothing)

#     preds_t = model(state_t)
#     preds_tp1 = Flux.data(preds[end])
#     cumulants, discounts, ρ = get_question_parameters(gvfn.cell, state_t, action_t, state_tp1, action_tp1, preds_tilde)

#     train!(model, opt, lu::TD, state_t, state_tp1, c, γ_tp1, ρ; prms=prms)

# end

