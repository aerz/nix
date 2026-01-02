function t -d "Create or attach tmux session"
    if test (count $argv) -gt 0
        tmux new-session -A -s $argv[1]
    else
        tmux new-session -A -s (basename $PWD)
    end
end

complete -c t -xa "(tmux list-sessions -F '#{session_name}' 2>/dev/null)"
