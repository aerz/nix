function tcd -d "Create tmux session in current dir"
    set session_name (basename $PWD)
    tmux new-session -A -s $session_name
end
