inputs: final: prev: {
  aerospace = inputs.nixpkgs-aerospace.legacyPackages.${prev.stdenv.hostPlatform.system}.aerospace;
}
