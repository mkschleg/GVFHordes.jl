

# I'm not sure if it is useful to actually have this abstract type explicitly defined.
# abstract type AbstractLearningUpdate end
# function train!(model, opt, lu::AbstractLearningUpdate, args...) end


struct TD #<: AbstractLearningUpdate
end

function train!(model, horde::AbstractHorde, opt, lu::TD, state_t, action_t, state_tp1, action_tp1)

    preds_tilde = Flux.date(model(state_tp1))
    c, γ, π_prob = get(horde, state_t, action_t, state_tp1, action_tp1)

    δ = c + γ.*preds_tilde - model(state_t)
    Δθ = Flux.gradient(()->mean(δ.^2), params(model))

    Flux.update!(opt, params(model), Δθ)

end



