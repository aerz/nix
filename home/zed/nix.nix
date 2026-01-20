{...}: {
  programs.zed-editor = {
    extensions = [
      "nix"
      "fish"
      "toml"
      "just"
    ];
    userSettings = {
      # disable language features when no profile active
      languages.Nix = {
        language_servers = [
          "!nil"
          "!nixd"
        ];
      };
      profiles.nix = {
        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
          };
          Fish = {
            formatter.external.command = "fish_indent";
          };
        };
        lsp = {
          nil = {
            initialization_options = {
              formatting.command = [
                "alejandra"
                "--quiet"
                "--"
              ];
              diagnostics = {};
              nix.flake = {
                autoArchive = true;
                autoEvalInputs = true;
              };
            };
          };
        };
      };
    };
  };
}
