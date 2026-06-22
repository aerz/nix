{config, ...}: {
  xdg.configFile."emacs-plus/build.yml".text = ''
    icon: savchenkovaleriy-big-sur
  '';

  home.sessionPath = [
    "${config.home.homeDirectory}/.config/emacs/bin"
  ];
}
