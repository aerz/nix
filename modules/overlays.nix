{inputs, ...}: {
  nixpkgs.overlays = import ../overlays {inherit inputs;};
}
