
using Flux
# I'm not sure if it is useful to actually have this abstract type explicitly defined.
# abstract type AbstractLearningUpdate end
# function train!(model, opt, lu::AbstractLearningUpdate, args...) end

mutable struct Linear{A}
    Wi::A
    Linear(in, out; init=Flux.zeros) = new(param(init(out, in)))
end

(layer::Linear)(x) = (layer.Wi*x)

# maybe implement forward and backward...

struct TD #<: AbstractLearningUpdate
end

function train!(model, horde::AbstractHorde, opt, lu::TD, state_t, action_t, state_tp1, action_tp1)

    preds_tilde = Flux.data(model(state_tp1))
    c, γ, π_prob = get(horde, state_t, action_t, state_tp1, action_tp1)

    δ = c + γ.*preds_tilde - model(state_t)
    Δθ = Flux.gradient(()->mean(δ.^2), params(model))

    Flux.update!(opt, params(model), Δθ)

end

struct TDLambda #<: AbstractLearningUpdate
    λ::Float64
    traces::IdDict
end

function train!(model::Linear, horde::AbstractHorde, opt, lu::TDLambda, state_t, action_t, state_tp1, action_tp1)

    preds_tilde = Flux.data(model(state_tp1))
    c, γ, π_prob = get(horde, state_t, action_t, state_tp1, action_tp1, preds_tilde)

    δ = c + γ.*preds_tilde - model(state_t)
    grads = Flux.gradient(()->sum(δ), params(model)) # this doesn't really work for a neural network.

    traces = get!(lu.traces, model, zeros(typeof(model.Wi[1]), size(model.Wi)...))::Array{typeof(model.Wi[1]), 2}
    traces .= convert(Array{Float64, 2}, Diagonal(discounts)) * λ * traces - grads[model.Wi]

    Flux.update!(opt, params(model), traces.*δ)

end


struct OnlineRTD{S, A}
    #should RTD take care of states and actions? -> NO, but maybe an online variant can...
    τ::UInt64
    states::Array{S}
    actions::Array{A}
end

function train!(model::Flux.Recur{T}, horde::AbstractHorde, opt, lu::RTD, states, actions)

end


struct RTD
#should RTD take care of states and actions? -> NO, but maybe an online variant can...
end

function train!(model::Flux.Recur{T}, horde::AbstractHorde, opt, lu::RTD, states, actions)

end

