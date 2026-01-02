function tk -d "Kill tmux session"
    tmux kill-session -t $argv[1]
end

complete -c tk -xa "(tmux list-sessions -F '#{session_name}' 2>/dev/null)"
