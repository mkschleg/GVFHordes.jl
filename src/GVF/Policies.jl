export NullPolicy

import Base.get

abstract type AbstractPolicy <: AbstractParameterFunction end

function get(π::AbstractPolicy, args::GVFArgs) end

struct NullPolicy <: AbstractPolicy
end

get(π::NullPolicy, args::GVFArgs) = 1.0

