inputs: final: prev: {
  aerospace = inputs.nixpkgs-aerospace.legacyPackages.${prev.system}.aerospace;
}
