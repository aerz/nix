default: update switch

[macos]
switch:
  sudo darwin-rebuild switch

update:
  sudo nix flake update

gc:
  nix-collect-garbage -d
  nix-collect-garbage --delete-older-than 7d
  nix-store --gc
