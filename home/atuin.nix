{...}: {
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
    daemon.enable = true;

    flags = [
      "--disable-up-arrow"
      "--disable-ai"
    ];

    settings = {
      search_mode = "fuzzy";
      style = "compact";
      inline_height = 20;
      show_preview = true;
      enter_accept = true;

      auto_sync = false;
      update_check = false;
      workspaces = true;

      history_filter = [
        "^ansible-vault encrypt_string"
      ];

      search.filters = [
        "workspace"
        "global"
        "host"
        "session"
        "directory"
      ];

      ui.columns = [
        "duration"
        "time"
        "command"
      ];
    };
  };
}
