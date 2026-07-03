function gwtn --description "Create a new worktree and branch from current git directory."
    argparse --min-args=1 --max-args=1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: gwtn <branch name>"
        return 0
    end

    set -l branch $argv[1]
    set -l base (basename (pwd))
    set -l path "../$base--$branch"

    git worktree add -b $branch $path
    and cd $path
end
