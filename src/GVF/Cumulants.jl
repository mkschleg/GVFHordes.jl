"""File describing cumulants"""


"""
    AbstractCumulant

    - Abstract type which all cumulants should inherit.

"""
abstract type AbstractCumulant <: AbstractParameterFunction end

function get(cumulant::AbstractCumulant, args::GVFArgs) end


"""
    FeatureCumulant

    - Basic Cumulant which takes the value c_t = s_tp1[idx] for 1<=idx<=length(s_tp1)
"""
struct FeatureCumulant <: AbstractCumulant
    idx::Int
end

get(cumulant::FeatureCumulant, args::GVFArgs) = args.state_tp1[cumulant.idx]
