{inputs}: [
  inputs.nix4vscode.overlays.default
  (import ./vscode-extensions.nix)
  (import ./mas.nix)
]
