function man -d "Man command with fzf"
    if test (count $argv) -gt 0
        command man $argv
        return
    end

    set -l page (command man -k . | fzf | awk '{print $1}')
    test -n "$page"; and command man $page
end
