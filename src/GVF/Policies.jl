export NullPolicy

import Base.get

abstract type AbstractPolicy <: AbstractParameterFunction end

function get(π::AbstractPolicy, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    throw(DomainError("get(PolicyType, args...) not defined!"))
end


struct NullPolicy <: AbstractPolicy
end

get(π::NullPolicy, state_t, action_t, state_tp1, action_tp1, preds_tilde) = 1.0
