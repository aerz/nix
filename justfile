default: update switch

hostname := `hostname | cut -d "." -f 1`

[macos]
build target_host=hostname flags="":
  nix build ".#darwinConfigurations.{{target_host}}.system" {{flags}}

[macos]
trace target_host=hostname: (build target_host "--show-trace")

[macos]
switch:
  sudo darwin-rebuild switch

update:
  sudo nix flake update

gc:
  nix-collect-garbage -d
  nix-collect-garbage --delete-older-than 7d
  nix-store --gc
