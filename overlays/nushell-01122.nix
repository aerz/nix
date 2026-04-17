# nushell 0.112.1 build failure
# https://github.com/NixOS/nixpkgs/pull/510439
inputs: final: prev: {
  nushell = inputs.nixpkgs-nushell.legacyPackages.${prev.system}.nushell;
}
