struct GVFArgs{S,A,P}
    state_t::Union{S,Nothing}
    action_t::Union{A,Nothing}
    state_tp1::Union{S,Nothing}
    action_tp1::Union{A,Nothing}
    preds_tilde::Union{P, Nothing}
end


GVFArgs(state_t::S, action_t::A, state_tp1::S, preds_tilde::P) where {S,A,P} = GVFArgs{S,A,P}(state_t, action_t, state_tp1, nothing, preds_tilde)
GVFArgs(state_t::S, action_t::A, state_tp1::S) where {S,A} = GVFArgs{S,A,Nothing}(state_t, action_t, state_tp1, nothing, nothing)
GVFArgs(state_t::S, action_t::A) where {S,A} = GVFArgs{S,A,Nothing}(state_t, action_t, nothing, nothing, nothing)
GVFArgs(state_t::S, state_tp1::S) where {S} = GVFArgs{S,Nothing,Nothing}(state_t, nothing, state_tp1, nothing, nothing)
GVFArgs(state_tp1::S) where {S} = GVFArgs{S,Nothing,Nothing}(nothing, nothing, state_tp1, nothing, nothing)
GVFArgs() = GVFArgs{Nothing,Nothing,Nothing}(nothing, nothing, nothing, nothing, nothing)
