export NullPolicy

import Base.get

abstract type AbstractPolicy <: AbstractParameterFunction end

function get(π::AbstractPolicy, state_t, action_t, state_tp1, action_tp1, preds_tp1)
    throw(DomainError("get(PolicyType, args...) not defined!"))
end


struct NullPolicy <: AbstractPolicy
end

get(π::NullPolicy, state_t, action_t, state_tp1, action_tp1, preds_tp1) = 1.0
