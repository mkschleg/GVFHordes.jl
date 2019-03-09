"""File describing cumulants"""


"""
    AbstractCumulant

    - Abstract type which all cumulants should inherit.

"""
abstract type AbstractCumulant <: AbstractParameterFunction end

function get(cumulant::AbstractCumulant, state_t, action_t, state_tp1, action_tp1, preds_tilde) end


"""
    FeatureCumulant

    - Basic Cumulant which takes the value c_t = s_tp1[idx] for 1<=idx<=length(s_tp1)
"""
struct FeatureCumulant <: AbstractCumulant
    idx::Int
end

get(cumulant::FeatureCumulant, state_tp1) = ϕ[cumulant.idx]
get(cumulant::FeatureCumulant, state_t, action_t, state_tp1, action_tp1, preds_tilde) = get(cumulant, state_tp1)
