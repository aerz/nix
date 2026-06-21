{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."emacs-plus/build.yml".text = ''
    icon: savchenkovaleriy-big-sur
  '';
}
