default: update switch

hostname := `hostname | cut -d "." -f 1`

[macos]
build target_host=hostname flags="":
    nix build ".#darwinConfigurations.{{ target_host }}.system" {{ flags }}

[macos]
trace target_host=hostname: (build target_host "--show-trace")

[macos]
switch: (build hostname)
    sudo darwin-rebuild switch --flake ".#{{ hostname }}"

update:
    sudo nix flake update

update-sources:
    fd .nix --exec update-nix-fetchgit

clean:
    nix flake check --no-build

gc:
    sudo nix-collect-garbage -d
    sudo nix store optimise --verbose

repair:
    sudo nix store verify --all --repair
