function ta -d "Attach to tmux session (default: main)"
    if test (count $argv) -eq 0
        tmux new-session -A -s main
    else
        tmux attach -t $argv[1]
    end
end
