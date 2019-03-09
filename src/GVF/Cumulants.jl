"""File describing cumulants"""


"""
    AbstractCumulant

    - Abstract type which all cumulants should inherit.

"""
abstract type AbstractCumulant <: AbstractParameterFunction end

function get(cumulant::AbstractCumulant, state_t, action_t, state_tp1, action_tp1, preds_tilde) end
