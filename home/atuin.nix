{
  config,
  lib,
  ...
}: {
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
      secrets_filter = true;

      history_filter = [
        "^ansible-vault encrypt_string"
        "^export [A-Z_]+_KEY="
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

  programs.fish.interactiveShellInit = lib.mkIf config.programs.atuin.enable ''
    function fish_should_add_to_history
      return 1
    end
  '';
}
