# The output is generated from:
# determinate-nixd completions fish
#
# The goal is to improve Fish’s performance by letting the shell load this
# content only when needed, instead of using eval as the documentation suggests.
#
# https://docs.determinate.systems/determinate-nix/#determinate-nixd-completion
# https://fishshell.com/docs/current/completions.html#where-to-put-completions

# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_determinate_nixd_global_optspecs
    string join \n nix-bin= config-file= attribution= flakehub-api-addr= flakehub-frontend-addr= flakehub-cache-addr= install-determinate-systems-addr= h/help
end

function __fish_determinate_nixd_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_determinate_nixd_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

function __fish_determinate_nixd_using_subcommand
    set -l cmd (__fish_determinate_nixd_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd[1] $argv
end

complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -l nix-bin -d 'Path to Nix\'s bin directory, like /nix/var/nix/profiles/default/bin' -r -F
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -l config-file -d 'The path to a determinate-nixd configuration file' -r -F
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -l attribution -d 'Diagnostics attribution' -r
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -l flakehub-api-addr -d 'The FlakeHub API address' -r
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -l flakehub-frontend-addr -d 'The FlakeHub Frontend address' -r
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -l flakehub-cache-addr -d 'The FlakeHub Cache address' -r
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -l install-determinate-systems-addr -d 'The install.determinate.systems address' -r
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -s h -l help -d 'Print help'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a auth -d 'Authentication subcommands'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a status -d 'Display your current FlakeHub login status'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a daemon -d 'Start the Determinate Nixd daemon (intended only for use by systemd and launchd)'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a init -d 'Initialize Determinate Nix after system boot'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a upgrade -d 'Upgrade Determinate Nix to the latest version advised by Determinate Systems'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a bug -d 'Report a bug to Determinate Systems'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a login -d 'Log in to FlakeHub. An alias for `auth login`'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a fix -d 'Automatically fix issues in Nix expressions'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a completion -d 'Prints completion for shells to use'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a builder
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a version -d 'Print the Determinate Nix version'
complete -c determinate-nixd -n __fish_determinate_nixd_needs_command -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and not __fish_seen_subcommand_from login bind logout reset help" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and not __fish_seen_subcommand_from login bind logout reset help" -f -a login -d 'Log in to FlakeHub using one of the available methods'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and not __fish_seen_subcommand_from login bind logout reset help" -f -a bind -d 'Bind the local Determinate installation to a specific FlakeHub organization'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and not __fish_seen_subcommand_from login bind logout reset help" -f -a logout -d 'Log the local Determinate installation out of FlakeHub'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and not __fish_seen_subcommand_from login bind logout reset help" -f -a reset -d 'Reset the local Determinate installation\'s authentication with FlakeHub'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and not __fish_seen_subcommand_from login bind logout reset help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from login" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from login" -f -a token -d 'Log in to FlakeHub using a FlakeHub token generated in the FlakeHub UI'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from login" -f -a github-action -d 'Log in to FlakeHub using a Github Actions workflow identity'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from login" -f -a gitlab-pipeline -d 'Log in to FlakeHub using a GitLab CI/CD pipeline token'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from login" -f -a aws -d 'Log in to FlakeHub using AWS STS credentials'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from login" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from bind" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from logout" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from reset" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a login -d 'Log in to FlakeHub using one of the available methods'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a bind -d 'Bind the local Determinate installation to a specific FlakeHub organization'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a logout -d 'Log the local Determinate installation out of FlakeHub'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a reset -d 'Reset the local Determinate installation\'s authentication with FlakeHub'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand status" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand daemon" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand init" -l stop-after -d 'Stop initialization after completing a specific phase' -r -f -a "init\t''
nix-configuration\t''
certificates\t''
mount\t''"
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand init" -l keep-mounted -d 'Continue running the init command in perpetuity to keep the Nix store mounted'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand init" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand upgrade" -l profile -d 'The profile for which you\'d like to upgrade Determinate Nix' -r -F
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand upgrade" -l tools -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand upgrade" -l daemon -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand upgrade" -l version -d 'Target upgrade version [default: stable]' -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand upgrade" -l finalize
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand upgrade" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand bug" -l attach -d 'Any files that you\'d like to attach to the bug report (as a comma-separated list) Note, these files are always included:' -r -F
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand bug" -l advisory -d 'Whether you\'d describe the bug report as an advisory'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand bug" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and not __fish_seen_subcommand_from token github-action gitlab-pipeline aws help" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and not __fish_seen_subcommand_from token github-action gitlab-pipeline aws help" -f -a token -d 'Log in to FlakeHub using a FlakeHub token generated in the FlakeHub UI'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and not __fish_seen_subcommand_from token github-action gitlab-pipeline aws help" -f -a github-action -d 'Log in to FlakeHub using a Github Actions workflow identity'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and not __fish_seen_subcommand_from token github-action gitlab-pipeline aws help" -f -a gitlab-pipeline -d 'Log in to FlakeHub using a GitLab CI/CD pipeline token'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and not __fish_seen_subcommand_from token github-action gitlab-pipeline aws help" -f -a aws -d 'Log in to FlakeHub using AWS STS credentials'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and not __fish_seen_subcommand_from token github-action gitlab-pipeline aws help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from token" -l token-file -d 'An optional path to a file containing the token' -r -F
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from token" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from github-action" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from gitlab-pipeline" -l jwt-env-var -d 'The name of the JWT environment variable' -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from gitlab-pipeline" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from aws" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from help" -f -a token -d 'Log in to FlakeHub using a FlakeHub token generated in the FlakeHub UI'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from help" -f -a github-action -d 'Log in to FlakeHub using a Github Actions workflow identity'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from help" -f -a gitlab-pipeline -d 'Log in to FlakeHub using a GitLab CI/CD pipeline token'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from help" -f -a aws -d 'Log in to FlakeHub using AWS STS credentials'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand login; and __fish_seen_subcommand_from help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and not __fish_seen_subcommand_from hashes help" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and not __fish_seen_subcommand_from hashes help" -f -a hashes -d 'Correct hash mismatch errors in fixed-output derivations'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and not __fish_seen_subcommand_from hashes help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from hashes" -l since -d 'Only consult build events starting at this moment. The following formats are accepted:' -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from hashes" -s B -l before-context -d 'Number of lines to show before a hash mismatch in the source code' -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from hashes" -s A -l after-context -d 'Number of lines to show after a hash mismatch in the source code' -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from hashes" -l auto-apply -d 'Automatically fix mismatches when Determinate Nixd knows there is only one match for a hash it finds'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from hashes" -l json -d 'Output JSON for consuming from tools'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from hashes" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from help" -f -a hashes -d 'Correct hash mismatch errors in fixed-output derivations'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand fix; and __fish_seen_subcommand_from help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand completion" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand builder" -l memory-size -d 'Amount of memory to give the builder VM, in bytes' -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand builder" -l cpu-count -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand builder" -l kernel-loglevel -d 'The `loglevel=N` kernel parameter' -r
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand builder" -l kernel -d 'The path to the kernel Image for the VM' -r -F
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand builder" -l initrd -d 'The path to the initrd file for the VM (must be in a format that the provided kernel can boot)' -r -F
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand builder" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand version" -s h -l help -d 'Print help'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a auth -d 'Authentication subcommands'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a status -d 'Display your current FlakeHub login status'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a daemon -d 'Start the Determinate Nixd daemon (intended only for use by systemd and launchd)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a init -d 'Initialize Determinate Nix after system boot'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a upgrade -d 'Upgrade Determinate Nix to the latest version advised by Determinate Systems'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a bug -d 'Report a bug to Determinate Systems'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a login -d 'Log in to FlakeHub. An alias for `auth login`'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a fix -d 'Automatically fix issues in Nix expressions'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a completion -d 'Prints completion for shells to use'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a builder
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a version -d 'Print the Determinate Nix version'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and not __fish_seen_subcommand_from auth status daemon init upgrade bug login fix completion builder version help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a login -d 'Log in to FlakeHub using one of the available methods'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a bind -d 'Bind the local Determinate installation to a specific FlakeHub organization'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a logout -d 'Log the local Determinate installation out of FlakeHub'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a reset -d 'Reset the local Determinate installation\'s authentication with FlakeHub'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from login" -f -a token -d 'Log in to FlakeHub using a FlakeHub token generated in the FlakeHub UI'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from login" -f -a github-action -d 'Log in to FlakeHub using a Github Actions workflow identity'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from login" -f -a gitlab-pipeline -d 'Log in to FlakeHub using a GitLab CI/CD pipeline token'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from login" -f -a aws -d 'Log in to FlakeHub using AWS STS credentials'
complete -c determinate-nixd -n "__fish_determinate_nixd_using_subcommand help; and __fish_seen_subcommand_from fix" -f -a hashes -d 'Correct hash mismatch errors in fixed-output derivations'
