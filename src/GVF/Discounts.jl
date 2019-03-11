import Base.get

abstract type AbstractDiscount <: AbstractParameterFunction end

function get(γ::AbstractDiscount, args::GVFArgs)
    #Is there something that goes here for the generic discount?
end

struct ConstantDiscount{T} <: AbstractDiscount
    γ::T
end

get(cd::ConstantDiscount, args::GVFArgs) = cd.γ


