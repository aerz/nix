{...}: {
  programs.zed-editor = {
    extensions = [
      "html"
      "emmet"
      "astro"
    ];
    userSettings = {
      languages.CSS.language_servers = [
        "tailwindcss-intellisense-css"
        "!vscode-css-language-server"
        "..."
      ];
      lsp.tailwindcss-language-server.settings = {
        includeLanguages.astro = "html";
        experimental.classRegex = [
          "class=\"([^\"]*)\""
          "class='([^']*)'"
          "class:list=\"{([^}]*)}\""
          "class:list='{([^}]*)}'"
        ];
      };
    };
  };
}
