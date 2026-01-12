{...}: {
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    configFile = ./oh-my-posh.toml;
  };
}
