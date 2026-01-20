final: prev: {
  vscode-extensions =
    prev.vscode-extensions
    // {
      # overrides
      vscodevim =
        prev.vscode-extensions.vscodevim
        // {
          vim = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "vim";
              publisher = "vscodevim";
              version = "1.32.4";
              hash = "sha256-+hyJZinWsa6U+s0fdrx2wUi6tOV3FNKf8O1qMMZEdkQ=";
            };
          };
        };
      jnoortheen =
        prev.vscode-extensions.jnoortheen
        // {
          # https://github.com/NixOS/nixpkgs/pull/474971
          nix-ide = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "nix-ide";
              publisher = "jnoortheen";
              version = "0.5.5";
              hash = "sha256-epdEMPAkSo0IXsd+ozicI8bjPPquDKIzB3ONRUYWwn8=";
            };
          };
        };
      bmalehorn =
        prev.vscode-extensions.bmalehorn
        // {
          # https://github.com/NixOS/nixpkgs/pull/453781
          vscode-fish = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "vscode-fish";
              publisher = "bmalehorn";
              version = "1.0.49";
              hash = "sha256-oG0KOvQZ2E5FroXaUT6lGw1zDSQ/bisHLMMkygbGqQE=";
            };
          };
        };

      # additions
      miguelsolorio =
        (prev.vscode-extensions.miguelsolorio or {})
        // {
          symbols = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "symbols";
              publisher = "miguelsolorio";
              version = "0.0.25";
              hash = "sha256-nhymeLPfgGKyg3krHqRYs2iWNINF6IFBtTAp5HcwMs8=";
            };
          };
        };
      yanivmo =
        (prev.vscode-extensions.yanivmo or {})
        // {
          navi-cheatsheet-language = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "navi-cheatsheet-language";
              publisher = "yanivmo";
              version = "1.0.1";
              hash = "sha256-xnFnX3sa5kblw+kIoJ5CkrZUHDKaxxjzdn361eY0dKE=";
            };
          };
        };
      dnut =
        (prev.vscode-extensions.dnut or {})
        // {
          rewrap-revived = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "rewrap-revived";
              publisher = "dnut";
              version = "17.9.0";
              hash = "sha256-au71N3gVDMKnTX9TXzGt9q4b3OM7s8gMHXBnIVZ/1CE=";
            };
          };
        };
      vorg =
        (prev.vscode-extensions.vorg or {})
        // {
          vorg = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "vorg";
              publisher = "vorg";
              version = "0.0.7";
              hash = "sha256-5hJIJShMasGNWuP9YxtGvton26uI3+zmXssnbqfBF1A=";
            };
          };
        };
      chadalen =
        (prev.vscode-extensions.chadalen or {})
        // {
          vscode-jetbrains-icon-theme = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "vscode-jetbrains-icon-theme";
              publisher = "chadalen";
              version = "2.36.0";
              hash = "sha256-p5hqytkF5Hg2d9N+XwZ5DfG2GEfoSPYXX0FCeUUR2Yc=";
            };
          };
        };
      subframe7536 =
        (prev.vscode-extensions.subframe7536 or {})
        // {
          custom-ui-style = prev.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "custom-ui-style";
              publisher = "subframe7536";
              version = "0.6.6";
              hash = "sha256-9hM0ZzTFgVqceYNx4cy30W/r4rpPnvcfHfCtHJXXfIA=";
            };
          };
        };
    };
}
