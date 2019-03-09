import Base.get

abstract type AbstractDiscount <: AbstractParameterFunction end

function get(γ::AbstractDiscount, state_t, action_t, state_tp1, action_tp1, preds_tilde)
    #Is there something that goes here for the generic discount?
end

get(γ::AbstractDiscount, state_t, action_t, state_tp1) = get(γ::AbstractDiscount, state_t, action_t, state_tp1, nothing, nothing)
get(γ::AbstractDiscount, state_tp1) = get(γ::AbstractDiscount, nothing, nothing, state_tp1, nothing, nothing)

struct ConstantDiscount{T} <: AbstractDiscount
    γ::T
end

get(cd::ConstantDiscount) = cd.γ
get(cd::ConstantDiscount, state_t, action_t, state_tp1, action_tp1, preds_tilde) = get(cd)


