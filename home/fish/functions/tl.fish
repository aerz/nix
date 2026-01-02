function tl -d "List tmux sessions"
    tmux list-sessions
end

complete -c tl -xa "(tmux list-sessions -F '#{session_name}' 2>/dev/null)"
