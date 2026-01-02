function ts -d "Switch between tmux sessions"
    tmux switch-client -t $argv[1]
end

complete -c ts -xa "(tmux list-sessions -F '#{session_name}' 2>/dev/null)"
