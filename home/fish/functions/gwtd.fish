function gwtd --description "Remove worktree and branch from active worktree directory."
    read -l -P "Remove worktree and branch? [y/N] " confirm

    if test "$confirm" = y -o "$confirm" = Y
        set -l cwd (pwd)
        set -l worktree (basename $cwd)
        # split on first "--" to recover root repo name and branch name
        set -l parts (string split -m1 -- "--" $worktree)

        if test (count $parts) -eq 2
            set -l root $parts[1]
            set -l branch $parts[2]

            cd ../$root
            git worktree remove $worktree --force
            # only delete the branch if the worktree removal succeeded
            and git branch -D $branch
            or echo "Worktree removal failed; branch '$branch' kept."
        else
            echo "This doesn't look like a worktree created with 'gwtn', aborting."
        end
    end
end
