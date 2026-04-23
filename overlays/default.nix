{inputs}: [
  inputs.nix4vscode.overlays.default
  (import ./vscode-extensions.nix)
  (import ./mas.nix)
  (import ./nushell-01122.nix inputs)
]
